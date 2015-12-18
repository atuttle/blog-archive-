---
layout: post
categories: 'adam'
cover: 'assets/images/covers/waves-on-rocks.jpg'
title:  'Expose Node.js on an IIS Server by Reverse Proxying With ARR'
summary: "When you have a Windows + IIS server and you want to add Node.js support without disrupting the existing IIS websites"
date:   2015-12-18 08:00:00
tags: Windows IIS Node.js
subclass: 'post'
navigation: True
---

Here's something I've wanted to be able to do for a long time now: I have a Windows server, running IIS and a dozen or so websites on various technologies like PHP, CFML, and ASP.NET. I'd like to add node.js support to that mix without disrupting any of the existing websites.

**Last night I finally figured out how!** It was the result of a lot of google searches and trial-and-error, so I'm no expert on the settings I'll be showing here, but it definitely works. _Have you got a better method? Please [hit me up on twitter!][twitter]_

Granted: Windows is not an ideal environment to host node apps, but you can still get a lot done with it, so you might as well know how to use what's at your disposal.

## Let's do it!

First things first, you need to be running IIS7 or later, and you need to [install Application Request Routing (ARR)][arr].

Then, you need your server to accept network connections for your desired hostname. Add a website as you normally would, binding the hostname to the desired IP address:

![Configure the website as you normally would](/assets/images/posts/2015/iis-node-website.png)

Next, we need to setup a virtual Server Farm (Microsoft's vocabulary, not mine). After you've installed ARR, you should have a new section in the sidebar of IIS labeled **Server Farms**. Right click that and choose **Create Server Farm**.

![Create a new server farm](/assets/images/posts/2015/iis-node-create-server-farm.png)

Give your server farm a name &ndash; anything will do &ndash; I named mine `localhost`. Make sure to check the `online` box. Click the `Next` button, and enter `127.0.0.1`  as the server address. Again, check the `online` box and enable `Advanced settings...`. Expand the newly available advanced settings, and change the http port to match the port your node web app will listen to.

If your node app is using express and binds to port 3000 like so: `app.listen(3000)`, then you'll enter port 3000 for the `httpPort` row.

![Server farm settings](/assets/images/posts/2015/iis-node-farm-settings.png)

Click the `Finish` button and then _decline_ the offer to add Rewrite Rules automatically (click the `No` button).

Select your new Farm in the sidebar, and you should be presented with a list of options like this:

![Server farm tiles](/assets/images/posts/2015/iis-node-farm-tiles.png)

Open the `Caching` options and disable disk cache. This is one of those things that I don't know is strictly necessary for my goal of running Node, but I saw it recommended in a blog post somewhere (regarding ASP.NET sites using Linq), and it's working for me, so why not?

Then go into `Routing Rules` and select `URL Rewrite...` from the actions panel on the right. After you do this, you should notice that the Server object in the left panel has become selected, rather than your server farm. This is expected: the change you're making will apply to the whole server.

You shouldn't have any rules configured yet, but if you do, edit it &ndash; otherwise create one. Use these settings:

- Change `Regular Expressions` to `Wildcards`
- Enter `*` for the pattern
- Add a new condition
  - Condition input: `{HTTP_HOST}` (I had trouble with this at first and it _may_ have been because I copy/pasted that string in. I recommend typing it manually. There should be autocomplete to help.)
  - Check: `Matches the pattern`
  - Pattern: The hostname of the website you want to be bound to your node app. For this example I'm using `www.hooli.xyz`.
- Change Action Type to: `Route to server farm` and select the server farm you created for your node app

![Rewrite settings](/assets/images/posts/2015/iis-node-rewrite-config.png)

Now start up your node app and load the domain in your browser. It should all be configured and working!

If you want to spin up more node apps, they'll need to listen on a different port, and you'll want to add more Server Farms and routing rules to route requests to a specific farm based on the `{HTTP_HOST}` value.

## Where to go from here

In theory it should be easy to take this a step further and run multiple node processes for the same app that listen on different ports, and use IIS as a load balancer between them. Perhaps a topic for a future blog entry.

## Shortfalls

Coming from a background like CFML or PHP where the app server is (typically) shared by all websites I sometimes found myself wishing for a simpler connection process, but then I would remember that separation of processes is a strength, not a weakness. If one website falls over, none of the others are necessarily affected. Still, it would be nice if it was less work to add a new node-powered website.

## What did I get wrong?

I'm probably jinxing it by referencing [Cunningham's Law][cl]; but here goes anyway. "The best way to get the right answer on the Internet is not to ask a question, it's to post the wrong answer."

Are you dying to point out how horribly wrong I am? [Please tweet at me!][twitter]

[twitter]: https://twitter.com/adamtuttle
[arr]: http://www.iis.net/downloads/microsoft/application-request-routing
[cl]: https://meta.wikimedia.org/wiki/Cunningham%27s_Law
