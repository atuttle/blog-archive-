---
layout: post
categories: 'adam'
cover: 'assets/images/covers/technology-music-sound-audio.jpg'
title:  'The Right Tool for the Job: Success Notifications'
summary: "Adam Tuttle attempts to convince you to send yourself less email."
date:   2016-03-14 09:30:00
tags: Email Best-Practices
subclass: 'post'
navigation: True
---

In what I hope is the first in a long series of short posts describing small steps I'm taking to _do the right thing&trade;_, today I want to talk about eliminating _yet another email notification_. In a way I guess you could say I'm on a campaign against email, at least as a method of anything other than async remote communication.

Back in the dark ages of 2013 I gave a conference presentation on an open source tool that I use called [BugLogHQ](http://www.bugloghq.com/), an alternative to sending yourself emails containing debug information when an exception occurs in your app &ndash; and I hasten to reiterate: one with many advantages. My team and I still use BLHQ to this day, and it is remarkably better than emailing error debug information. [You can see the conference session abstract and the slides here](/errors-are-best-when-emailed-said-nobody-ever/). Not as good as being there, but it should give you an idea of how great BLHQ can be, comparatively.

Having solved the error logging problem, the next thing that shows up in my email occasionally, ripe for disruption, is _success notifications_ for scheduled jobs like database backups, and membership expiration reminders. What these types of notifications need is not a success notification, but a failure notification. Hopefully error logging catches any errors that occur during those jobs, but what happens if the cron job gets disabled?

_Will you notice that you didn't get that email last night when the backups should have run?_

What you really need in this situation is a [dead man's switch](https://en.wikipedia.org/wiki/Dead_man%27s_switch). These take many forms, but at their simplest you can think of them as a grenade with the pin removed. If you loosen your grip and the "spoon" is released from the grenade ... boom. In digital form, releasing the spoon would be your scheduled job missing a "check in," and the boom would be a notification that your job hasn't run on schedule.

![Grenade](/assets/images/posts/2016/brain_grenade.jpg)
<small>Photo credit: <a href="https://www.flickr.com/photos/lapolab/16833901255/">lapolab</a></small>

Enter [Dead Man's Snitch](https://deadmanssnitch.com/r/228ab4a26f). This app actually started out as a side project for a local Philly entrepreneur and aquiantance of mine; and I like to support local businesses, especially when they're awesome. DMS is a web service that your job calls to "check in" via a simple HTTP GET request. Miss a check in and they'll let you know. There are a bunch of different schedules available, and at varying price levels you get access to different integrations (i.e. Slack).

There are a few nuances that I'm leaving out to keep this simple, so if you're interested or just have questions, go [check out the site](https://deadmanssnitch.com/r/228ab4a26f) for more information. And hey, maybe give the service a shot: you get 1 snitch for free into perpetuity, so why not?

<small>_Disclosure: The links in this post, while not a paid advertisement, are referral links. If you sign up for an account then I get a free snitch for my account. Obviously I think the service is pretty great: I have a paid account for personal use as well as a paid account for my business; and I'm hoping you will sign up too. But if referral links just aren't your thing, [here's a clean one](https://deadmanssnitch.com/)._</small>
