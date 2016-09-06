---
layout: post
categories: 'adam'
cover: 'assets/images/covers/sit-clouds.png'
title: "My Experience With AWS Reserved EC2 Instances and Deploying Docker in Production"
summary: "Field notes from Adam's dive into the deep end, deploying containerized web applications in the cloud!"
date: 2016-09-06 09:00:00
tags: Docker AWS
subclass: 'post'
navigation: True
---

This is going to be more field-notes than how-to, but when I tweeted about how I had such an easy experience getting some Docker containers running in production I had several people express interest in reading about my experiences, so here we are.

The backstory is that I had one app in particular that was on a terrible, terrible web host (like really, the worst) &ndash;and it was for a paid client, at that&ndash; so when the host spent more time offline than online in June, and ignored my numerous support tickets, I decided to take my money elsewhere. The app happened to be a fairly simple website for a non-profit organization, with a members-only area, a way to pay dues and register for events, and a few other odds and ends. On the host-that-shall-remain-nameless this app was running on Adobe ColdFusion 10, and using a local MariaDB. I am not willing to pay the price Adobe charges for their AMIs long term, so I knew I had to convert to Lucee.

Having recently attended the [dev.Objective()][devo] conference and subsequently been [playing with Docker][playing] I decided I would use it to develop the necessary changes. It really made getting a development environment up and running terribly easy. In fact, I've made it this far in my life without _properly_ learning how to install and configure Tomcat, why start now?

And truly, that's the best part about all of this: **Standing on the shoulders of giants.** My most sincere thanks go to the Lucee team, in particular Geoff Bowers who manages their docker images. Also many thanks to the fine folks in the #lucee and #docker channels on the [CFML Slack][cfml-slack] who helped me through issues as they would come up.

<p><video src="/assets/images/posts/2016/first-water-landing-720p.webm" controls>
	Sorry, your browser doesn't support embedded videos,
	but don't worry, you can <a href="/assets/images/posts/2016/first-water-landing-720p.webm">download it</a>
	and watch it with your favorite video player!
</video></p>

Right, so after a month of evenings and weekends toiling away at the code changes, I got my local docker container for my app into good shape. I also managed to get a separate container up with MariaDB and network the two together. It worked, but it wasn't pretty. I had a series of shell scripts to stand it up and hold it together, but nothing I would want to use in production. Most importantly, I had no idea how I would make the DB survive a container restart (it was building from scratch on every start).

For the former problem (my poorly written shell scripts) [docker-compose][compose] came to the rescue, and for the latter (DB data storage) all I had to do was RTFM. Compose makes it easy to define a set of containers that need to be started and networked together, and manage them. And [the MariaDB docker image docs][mariadb-docker] literally have a heading, "Where to Store Data."

I'm not going to spell out how those things work in detail, but here's my `docker-compose.yml` file:

```yaml{10,12,22-24}
version: '2'
services:
  web:
    container_name: myapp_web
    restart: always
    build: ./
    ports:
    - "8888:80"
    volumes:
    - ./:/var/www/myapp
    links:
    - db:myapp_db
    environment:
        TZ: 'America/New_York'
  db:
    container_name: myapp_db
    restart: always
    image: mariadb:latest
    ports:
    - "6633:3306"
    volumes:
    - ./database:/var/lib/mysql
    - ./res/create-database.sql:/docker-entrypoint-initdb.d/create-databse.sql
    - ./res/myapp.sql:/docker-entrypoint-initdb.d/myapp.sql
    environment:
        TZ: 'America/New_York'
        MYSQL_ROOT_PASSWORD: 'godmode'
```

I've highlighted a few of the interesting bits:

- `./:/var/www/myapp` &mdash; mount the current directory into the into the container as a volume at `/var/www/myapp`, so that code changes I make on my laptop (because that's where I have my editor open) are immediately visible in the container.
- `db:myapp_db` &mdash; from inside the **web** container, make the **db** container available as hostname `myapp_db`
	- Not pictured: My Application.cfc has a datasource configured with the following connectionString: `'jdbc:mysql://myapp_db:3306/myapp?...'`, so you can see that you simply access the linked docker container by hostname.
- mount three volumes for the db container:
	- `./database:/var/lib/mysql` uses the local **database** folder as the storage location for all of the data that MariaDB will create. (Starts out empty)
	- `./res/create-database.sql:/docker-entrypoint-initdb.d/create-databse.sql` is a script that MariaDB will run on startup if it hasn't already created any databases (appears to be first-run). In this script I create my database and setup the website user account and privileges. After the first time the container is run, when there is data in the **database** folder, this file will be ignored.
	- `./res/myapp.sql:/docker-entrypoint-initdb.d/myapp.sql` will run after `create-database.sql` and is just the most recent production mysqldump prepended with `use myapp;`. After the first time the container is run, when there is data in the **database** folder, this file will be ignored.

With those two problems solved, I moved on to thinking about how to manage all of this. I settled on a Makefile because I knew it would work both on my local Mac and on Ubuntu, where this will ultimately live. (Credit to [Mark Mandel][mahk] for the idea to use Make in the first place. Smart dude.) Here's my Makefile:

```bash{1,7-9}
file_date = $(shell date +%Y-%m-%d)

default:
	docker ps

db-backup:
	tar czf myapp_db.$(file_date).tar.gz database
	aws s3 cp myapp_db.$(file_date).zip s3://myapp/backups/ && rm -f myapp_db.$(file_date).zip
	curl https://nosnch.in/my-secret-key

build:
	docker-compose up -d --build

up:
	docker-compose up -d

bash:
	docker exec -it myapp_web /bin/bash

logs:
	docker-compose logs -f
```

Probably the most interesting part of this is the `db-backup` target. This Makefile is to be used outside of the container, so what this target does is gzip up a copy of the **database** folder and push it into Amazon S3 using their [AWS CLI][awscli]. Lastly it notifies [Dead Man's Snitch][dms] that the backup has run so that I can sleep soundly. Should we ever need to restore the database, it should be as simple as unzipping the appropriate backup file into the database folder and starting the container.

![Nginx welcome screen](/assets/images/posts/2016/sit-flying-1.jpg)


### All Problems Solved. Time to Go to Production!

I spent a lot of time over the last month thinking about this. Despite being interested in Google's cloud offerings, I had already sold my client on AWS so I knew I was going to be hosting it there. But should I use their [EC2 Container Service][ecs]? If not that, then what? I am aware of Kubernetes but suspect it would be easier to use on Google's cloud than Amazon's. Mostly this whole config was just a big question mark for me.

One thing I did know is that scaling is _just not an issue_. This app will only ever need one container and that's it. I don't need a cluster, I just need something that will restart it on the off chance the process dies. (That's what `restart: always` does in docker-compose, by the way.) So while it would be fun to run some sort of clustered setup, it would be the very definition of overkill.

For that reason, I decided to go with a standard vanilla Ubuntu AMI, on which I installed Git, Docker, and the AWS CLI. Because of the agreement I negotiated with my client, I knew I wanted a `3-year-reserved-full-upfront` EC2 instance, to save money over the on-demand prices. I've used EC2 before, but never reserved instances, so that was another question mark. Like many things AWS, it makes sense once you understand how it works but was not immediately obvious without reading the documentation very carefully.

#### Getting a Reserved EC2 Instance

Reserved instances are kind of funny. When you buy it, you're not buying an EC2 instance: You're buying the contract to host an EC2 instance of a certain type, for a certain time period, in a certain location. For example, a `t2.large` for three years in `us-east-1d`. The clock starts ticking as soon as the payment form is submitted, so if it were to take a week for you to stand that instance up, you just donated a week's hosting costs to Amazon. Be ready to start that instance before you submit your payment so that you can switch tabs and start it immediately.

The Reserved Instance contracts (I'm just calling them contracts, I don't know if there's a more official nomenclature) are sold on a sort of marketplace. I had heard that if you buy 3 years but end up wanting to terminate early, you're allowed to sell the remainder on the marketplace &mdash; I just didn't know how or where to do that. When I was searching for my contract, I only found one option to buy from "3rd party" rather than Amazon.

From there, it works just like any other EC2 instance: save your key file and then connect to the server with SSH: `ssh -i ~/.ssh/my_server-root.pem ubuntu@ec2-{my-ip-address}.compute-1.amazonaws.com`.

### Setting up My Server

The first thing I needed to do was [install Docker on Ubuntu][install-docker], which was pretty straight-forward:

All of the below commands are taken from the above Docker on Ubuntu link, after parsing out which commands were necessary for Ubuntu 14.04 Trusty. If you're on a different version, make sure to follow the right docs. And I'm probably running `apt-get update` more than is strictly necessary, but it was repeated in the guide and I didn't see any harm in running it again, so I just followed instructions. (Standing on the shoulders of giants, remember?)

```bash
$ uname -r
3.13.0-95-generic
```

Great news! I'm on a recent enough kernel!

```bash
$ sudo apt-get update
$ sudo apt-get install apt-transport-https ca-certificates
$ sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
$ sudo echo "deb https://apt.dockerproject.org/repo ubuntu-trusty main" > /etc/apt/sources.list.d/docker.list
$ sudo apt-get update
$ apt-cache policy docker-engine
$ sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual
$ sudo apt-get install docker-engine
$ sudo service docker start
$ sudo docker run hello-world
```

Also from that guide:

> For [Ubuntu] 14.10 and below the above installation method automatically configures upstart to start the docker daemon on boot

... Nice! One less thing to figure out. At this point I was thinking something like, "So the Docker daemon will autostart, but how am I going to make sure my containers autostart, too?" Spoiler alert: I restarted my instance with the containers running and when everything came back up they were brought up too. 👌

At this point I've got Docker running but no docker-compose. Coming from a Mac I was surprised they didn't come bundled together. I was even more surprised that compose wasn't available through apt. Fortunately it was easy enough to google up some instructions on [installing docker-compose on Ubuntu 14.04][compose-ubuntu].

```bash{1,4}
$ sudo usermod -aG docker $(whoami)
$ sudo apt-get -y install python-pip
$ sudo pip install docker-compose
$ which docker-compose && docker-compose --version
```

The `usermod` line adds the current user (ubuntu) to the `docker` group, which prevents the need to use sudo every time I want to run a docker command. The last line shows where the compose executable is found and prints its version, just to confirm that all is well.

And now to install the aforementioned AWS CLI:

```bash
$ sudo pip install awscli
```

### Configuring My App

Now that all of the pre-requisites are satisfied, it's time to get my containers running and verify that my app is working. I cloned my git repo to `/opt/myapp` and then `chown -R ubuntu ubuntu /opt/myapp` so that sudo isn't required for simple things like getting the latest code with `git pull`.

I have both my `Dockerfile` for building my web container and my `docker-compose.yml` in the root of my repo, so it was as simple as `cd /opt/myapp && docker-compose up` to start them.

Once the containers were done building, I confirmed that the web container was serving the website on port 8888. Internal to the container it's listening on port 80, but that port is being shared on the host as 8888, as you can see in my `docker-compose.yml` config above. From the host I make an HTTP request to localhost:8888:

```bash
$ wget localhost:8888 -O /dev/null
Resolving localhost (localhost)... 127.0.0.1
Connecting to localhost (localhost)|127.0.0.1|:8888... connected.
HTTP request sent, awaiting response... 200 OK
Length: 19789 (19K) [text/html]
Saving to: ‘/dev/null’

100%[==========================================>] 19,789      --.-K/s   in 0s

2016-09-05 09:56:39 (173 MB/s) - ‘/dev/null’ saved [19789/19789]
```
Awesome, it's working!

#### Reverse Proxy

This part isn't strictly necessary. If I only wanted to run this one thing on the server I could just directly expose the container's port 80 as the server's port 80 and call it a day. But putting a reverse-proxy in the middle allows me to add more containers to this server to do other things, which I hope to do in the near future. So I quickly wrapped it up in an [Nginx][nginx] reverse proxy:


```bash
$ sudo apt-get install nginx
```

Once installed, Nginx is already running:

![Nginx welcome screen](/assets/images/posts/2016/nginx-welcome.png)

I didn't spend a lot of time searching out the best Nginx Reverse Proxy tutorial; it was something that was pretty easy to figure out from just the hints in the [2nd google result][proxy] (jump down to "Step 7").

I deleted the symlink at `/etc/nginx/sites-enabled/default` to disable the welcome screen, then added my own `/etc/nginx/sites-available/myapp.com` file with this content:

```
server {
	listen 80 default_server;

	server_name myapp.com www.myapp.com aws.myapp.com;

	location / {
		proxy_pass http://127.0.0.1:8888;
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header Host $host;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto $scheme;
	}
}
```

Then symlink this file into `/etc/nginx/sites-enabled/`, and restart nginx. This will proxy all requests to my container that's listening on port 8888, which is good enough for now!

### Remaining Problems

Something's wonky with the system time inside the docker container. By default it comes up as UTC. My host was also UTC. I live in US/Eastern and my client is in US/Eastern so it just makes things easier for my servers to use US/Eastern, too. (Though really, [Timezones can die in a fire for all I care][tz].)

But I noticed this in the Lucee admin overview at around 22:33 (10:33pm) on Sept 4th:

![Nginx welcome screen](/assets/images/posts/2016/docker-lucee-time.png)

What's odd is that it's ahead by ten hours (The container and the host were both in UTC at the time). I changed both to use Timezone `America/New_York` and restarted both the host and the containers, but that doesn't seem to have helped. Setting the Timezone in the MariaDB container seems to have worked: `select current_timestamp;` returns my current local time, so I have to imagine there's some disconnect between the system time and Lucee.

Just to verify I did add a comment to a view where I spit out the current value of `#now()#` and it matches what I see in the Lucee dashboard. So the website thinks that the time is off by a few hours. Not ideal, but I can live with it while I work with the folks in #lucee and #docker to find a fix.

I initially made some scripting changes to my Dockerfile to set the timezone and install NTP, but later found some advice to set an environment variable named `TZ` with the desired Timezone. That worked too (in that `$ date` reported the desired date & time), so I ripped out the Dockerfile changes. The environment variable approach works for the MariaDB container too, an added bonus.

### Conclusion

Soup to nuts, it went surprisingly smoothly. Aside from the Timezone/system time issue, I finished all of that in a day. I started at about 9:00am, took short breaks for lunch and dinner, and finished before 10:00pm. I had mentally prepared myself to stay up until the wee hours of the morning pulling out what's left of my hair, as I usually would in a similar situation, but it just wasn't necessary. The time that I saved, I turned around and used to write this blog post. 🤓

<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">I mean, it&#39;s also not even 10:00pm... This is just not how I envisioned my night going.<br><br>I&#39;ll allow it. <a href="https://t.co/iDwVd8PXgv">pic.twitter.com/iDwVd8PXgv</a></p>&mdash; Adam Tuttle (@AdamTuttle) <a href="https://twitter.com/AdamTuttle/status/772607180721750018">September 5, 2016</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

[playing]: http://adamtuttle.codes/TIL-adding-a-jvm-ssl-cert-docker/
[devo]: http://www.devobjective.com/
[cfml-slack]: http://cfml-slack.herokuapp.com/
[compose]: https://docs.docker.com/compose/
[mariadb-docker]: https://hub.docker.com/_/mariadb/
[mahk]: http://www.compoundtheory.com/
[awscli]: https://aws.amazon.com/cli/
[dms]: http://adamtuttle.codes/the-right-tool-success-notifications/
[ecs]: https://aws.amazon.com/ecs/
[install-docker]: https://docs.docker.com/engine/installation/linux/ubuntulinux/
[compose-ubuntu]: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-14-04
[nginx]: https://www.digitalocean.com/community/tutorials/how-to-install-nginx-on-ubuntu-14-04-lts
[proxy]: https://www.digitalocean.com/community/tutorials/how-to-configure-nginx-as-a-web-server-and-reverse-proxy-for-apache-on-one-ubuntu-14-04-droplet
[tz]: https://youtu.be/-5wpm-gesOY
