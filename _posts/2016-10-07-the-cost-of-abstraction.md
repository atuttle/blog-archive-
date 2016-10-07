---
layout: post
categories: 'adam'
cover: 'assets/images/covers/landing-at-night.jpg'
cover_blur: false
title: "The Cost of Abstraction"
summary: "Adam forgot to write a summary blurb for this article! Oops!"
date: 2016-10-07 11:00:00
tags: Coding Learning
subclass: 'post'
navigation: True
---

Earlier today a friend and colleague who is almost 40 sent me a link to this article: [Reflections of an "Old" Programmer][old]. I'm 34, so still a few years shy of Ben, but I have been starting to get the feeling that I'm an "old" coder too. So hopefully my thoughts in response aren't too far off-base.

I think the motivation for Ben's post is correct:

> Without ... effort, we could be worse at our jobs in 5 years than we are today. There is no coasting.

But his metaphors are full of holes and his thesis of knowledge decay is too broad. Allow me to explain.

### Metaphors revisited

[Ignaz Semmelweis][handwasher], a Hungarian doctor in the mid 1800s, was ridiculed because he believed that microscopic living organisms could reside on your skin and be transmitted from one patient to the next, spreading disease. Of course today we understand about bacteria and viruses and we wash our hands between surgeries.

Ben asserts that doctors (probably) don't find themselves constantly dealing with knowledge decay and the threat of getting worse at their jobs over time:

> The doctor at 40 doesn't seem to be worried about discovering that all his knowledge of the vascular system is about to evaporate in favor of some new organizing theory. The same goes for the lawyer, the plumber, the accountant, or the english teacher.

While there is a nugget of truth in this quote (more on that in a moment), I would assert in response that Ben probably doesn't know too many doctors, lawyers, plumbers, accountants, or teachers. Or at least he doesn't ask them about their Continuing Learning Efforts.

Your family doctor probably attends at least once conference a year, and very likely _regularly_ attends lunch-and-learn sessions paid for by pharmaceutical companies where she gets free lunch in exchange for learning about the company's new drugs: How they work, what they do, and what off-label uses they might be good for, to name just a few things. I have friends that were pharma reps and friends that are doctors, and I'm speaking from first-hand conversations with them.

Anyone remember "New Math"? Ben's parents were probably complaining about it when he was in 6th-10th grade, if my math is correct. Teachers were learning and applying new techniques for helping kids to understand mathematical concepts. The same is probably true for reading, writing, and other concepts too. And we're going through it again now: What people often refer to as "common core" (which I support) &ndash;which is actually just a new program put in place to _satisfy_ common core&ndash; is an updated approach to teaching based on scientific research on the subject.

Lawyers must be aware of new laws and precedents. Accountants have to keep up with the latest loop-holes to help their billionaire clients avoid paying taxes. Plumbers need to know about new materials (my house is plumbed with PEX pipes) and tools.

In all of these cases, if someone abandons learning new things the day they get their first job they will not have a very long career at all.

### That nugget of truth

> The doctor at 40 doesn't seem to be worried about discovering that all his knowledge of the vascular system is about to evaporate in favor of some new organizing theory.

This part is right, though. The vascular system is well understood and documented, and the hardware is unlikely to change drastically over the course of a doctor's career. Except artificial blood vessels and hearts and whatever other medical innovations come along in the next 40 years...

There are certain concepts in any field, which I'll refer to as "core concepts," that have a half life of much longer than the average human lifespan, if not effectively infinite.

Looping, Branching, Recursion: These are all programming core concepts that you will not likely find yourself abandoning for new approaches in our lifetime. Not unless there are major breakthroughs in Quantum Computing, followed by mass market production of quantum computers to make them as common as PCs are today. These are the vascular and nervous systems of the computer: You're speaking using concepts born at a lower level of abstraction, even if you're using a 4th or 5th generation language.

In the beginning there were 1st generation languages: byte code punched into cards. Then there were 2nd generation languages that abstracted a collection of bytecode commands into a single command that could be written with letters and numbers in a text file, i.e. Assembly. 3rd generation languages like C abstract collections of 2GL commands into a single line of code. And repeat for 4th and 5th generation languages.

Each layer of abstraction exists because it "makes hard things easier" than the previous generation. But we're at a point now where we've based our knowledge on something 4 or 5 layers of abstraction away from implementation. And because of that, things change more frequently.

The problems that these JavaScript frameworks du jour are attempting to solve are simply not solved: The scientists (programmers) are still experimenting with different methods and techniques, and no consensus has been reached on the best ways to tackle these problems. Nor is it likely to be in our lifetime. So in this limited scope, I agree with Ben: the half-lives of these things are low when contrasted with core concepts.

It is these higher layers of abstraction that are changing, not the core concepts. When you switch to a new tool or framework, recursion still works the same way it used to.

You can't compare your highly abstracted concepts to the core concepts of another profession and proclaim that our industry is just different. That we churn more knowledge. We don't. Drugs get discontinued. Lead paint and leaded gasoline (and if you're me, you're hoping gasoline altogether!) are on their way out. Every industry evolves.

**This is the cost of working at a high level of abstraction.**

### The result is the same

Even with all of the above nit-picking, I agree with Ben's conclusion: Focus on learning the core concepts of your field well and they will serve you well for a long time to come. For everything else, don't rush to be an early adopter, and wait for some amount of consensus to grow before you dive in head-first.

Early adoption is for "kids" (pre-30's) that have time to be burned by bad decisions and recover from those burns. Us old-folks need to focus on stability and sustainability.

But I still think React Native looks pretty neat.

[old]: http://www.bennorthrop.com/Essays/2016/reflections-of-an-old-programmer.php
[handwasher]: https://en.wikipedia.org/wiki/Ignaz_Semmelweis
