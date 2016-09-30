---
layout: post
categories: 'adam'
cover: 'assets/images/covers/minecraft.jpg'
cover_blur: true
title: "Giggle Driven Development"
summary: "Adam shares a tale of playing programming games with his kids"
date: 2016-09-30 09:00:00
tags: Coding Kids
subclass: 'post'
navigation: True
---

Yesterday morning while spending time with my kids before they left for school, and completely by accident, I found myself on a website making use of some really neat technology that made programming problems and lego-block style "coding" of solutions really novel, simple, and approachable. We had a bunch of fun working on some of the problems together, and I feel compelled to share.

![Sample (wrong) source code](/assets/images/posts/2016/giggle-fail-algorithm.png)

The technology is called [Blockly][blockly] (by Google), and [these are the games we played][blockly_games].

The games start out with a simple puzzle mechanic that teaches you how to snap the puzzle pieces (that will later become "code") together, and then moves on to the most basic form of coding challenges. The challenges get successively harder as you go, requiring the understanding of a new concept to complete each level.

This feels like a very natural next step after [Robot Turtles][robot_turtles], a board game that teaches beginning programming concepts. I backed it on kickstarter and my kids and I enjoy breaking it out from time to time. Two things that Robot Turtles lacks and that Blockly introduces pretty early on are branching (if/else) and looping constructs. Those concepts would be really hard to model out with a deck of cards laid out on a table &ndash; the mechanic used in Robot Turtles &ndash; but the snap-together pieces approach in Blockly actually works pretty well.

![A screen shot of one of our failed attempts, which elicited much laughter](/assets/images/posts/2016/giggle-fail.jpg)

But the thing that really sucked my kids in was what happens when you fail. Instead of just making a "you can't do that" noise and stopping the little maze-wanderer dead in its tracks, the astronaut flies off into space. If you're playing with the default skin that resembles Google Maps then it sounds like the character walks into a wall. Hard. And if you're using the panda theme, it makes some sort of "mew" noise and then falls off of the bottom of the screen.

That accidental joy: turning a failure into laughter; that's what drew my kids in and made them want to do more. They sought out more failures, and in doing so, learned more about the concepts being taught. Not because they wanted to learn more about programming, but because they thought it was hilarious when the astronaut floated off into space and they wanted to understand how to make it happen again, intentionally.

![A screen shot of MIT Scratch](/assets/images/posts/2016/giggle-scratch.png)

In the past, I've tried introducing them to [MIT's Scratch][scratch], but it never seemed to interest them. From what I've seen so far, Scratch can be quite a bit more complex, though the only thing I've seen done with it is to make (sometimes interactive) animations. Maybe once they get some more time in with Blockly they'll be more interested in Scratch. Or maybe my kids are puzzle gamers, and just not interested in creating animations.

But clearly the hilarious (to a 5 and 7 year old) way that failure happens in these Blockly games is part of what makes them so appealing.

And what can we learn from this as we create interfaces for non-technical users in business applications? We aren't teaching them to write code, but if we can turn their mistakes into something that makes them _want_ to spend more time using the application, I would consider that a win.

How cool would it be to have some negative behavior in your app enable [Power Mode][power] instead of some boring "You can't do that" validation? I don't know when it would be appropriate to do so (outside of, perhaps, April Fools) but it strikes me as the type of thing that is harmless and would elicit joy from the users, if used sparingly.

<small><a href="https://www.flickr.com/photos/philiproeland/12100005003">Photo credit</a></small>

[blockly]: https://developers.google.com/blockly/
[blockly_games]: https://blockly-games.appspot.com/
[robot_turtles]: http://www.robotturtles.com/
[scratch]: https://scratch.mit.edu/
[power]: https://github.com/codeinthedark/awesome-power-mode
