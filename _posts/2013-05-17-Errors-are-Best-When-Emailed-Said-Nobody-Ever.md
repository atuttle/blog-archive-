---
layout: post
categories: 'adam'
cover: 'assets/images/covers/dylan-no-stress.png'
title:  Errors are Best When Emailed... Said Nobody Ever
date:   2013-05-17
location: Minneapolis, MN, USA
tags: Talks
subclass: 'post tag-Talks'
navigation: True
---

<script async class="speakerdeck-embed" data-id="6142a1bd3e2b408786cf9c508c953d5c" data-ratio="1.33333333333333" src="https://speakerdeck.com/assets/embed.js"></script>

Exceptions happen. Bugless code is a myth.

I hope I don't have to convince many people that sending every exception via email is not the greatest idea since sliced bread. "Sure, it sucks... But what else can I do?" would be a natural response. I've been there. How else can you keep track of exactly what's going wrong in your application? How else will you be alerted when something goes wrong?

For many of you, email probably plays the role of courier between your application and your bug database (JIRA, Bugzilla, etc). But that's not what email was intended for, and to be honest, it's a poor tool for the job, so it does a crappy job.

The truth is that there are better options, but nobody can blame you for not knowing about them... Until now. I'm going to show you the two most popular options available for CF, how to use them to get useful analytical data back about your application's health, or lack thereof, and how you can extend the concept beyond just your CFML. And the real surprise is that it's easy.
