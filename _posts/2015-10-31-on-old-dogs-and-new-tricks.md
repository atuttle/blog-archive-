---
layout: post
categories: 'adam'
cover: 'assets/images/covers/cover4.jpg'
title:  On Old Dogs and New Tricks
date:   2015-10-31 23:59:59
tags: CFML React Static Jekyll GitHub
subclass: 'post tag-CFML'
navigation: True
---

Consider the following code. This isn't an exercise in figuring out what something does, or how to do it, so I'll just tell you: it updates a list of items (e.g. user input) so that all items in the list are quoted with single-quotes. If it finds them, it strips out double quotes, too (only if both open and close quotes exist).

```javascript{5}
x = "foo,'bar',""baz"",qux";

x = x
  .listToArray()
  .map(function(item){
    if (item.left(1) == "'" && item.right(1) == "'") return item;
    if (item.left(1) == '"' && item.right(1) == '"'){
      item = item.left( item.len()-1 ); //chop trailing "
      item = item.right( item.len()-1 ); //chop leading "
      return "'#item#'";
    }
    return "'#item#'";
  })
  .toList();
```

Would it surprise you to find out that this code is CMFL?

A few short years ago (a lifetime, on the internet), I would have been shocked to see this and learn that it is, indeed, ColdFusion code. It's very [ECMAScripty][ecma], it's functional, and it uses some of the language trimmings modern modern languages love: map and reduce. `array.toList()` is really just a reducer, if you think about it.

I'm not heralding ColdFusion, here. I've been working with the platform for more than a decade now and I'm pretty sick of it, to be honest. As a former ColdFusion Product Manager once told me, "You don't really know a programming language unless you can name 10 things you hate about it." By that measure, I'd estimate that I know CFML really, _really_, _**really**_ well.

Whatever your opinion of ColdFusion, it is undeniably changing. The next version is on the horizon. They're in private beta (to which I declined to participate); and I would wager public beta is closer than most people would think.

_Everything old is new again._

Me, too.

I'll be 35 in April. While technically not even half way through my career (assuming I retire at 65), 35 feels kind of "old" in tech. I've gone from being one of the hungry young guys that's eager to replace the stagnant developers that came before me, to one of those old kodgers that's unsettled (even if just a little bit) by new JS frameworks coming out every week.

For the last few years my developer career has started to stagnate. I decided not to speak at any conferences in 2015; in part to give myself a break from the crazy amount of work that I put into a presentation that I give only once or twice, but also in part to find out if I would miss it. (I do.) I haven't learned anything new &mdash; nothing big, at least. I haven't grown.

I learned the fundamentals of Node.js at the end of 2014, and have been using them to my great advantage since, but that was the last time I truly learned something new. I've been heads-down working on [AlumnIQ][iq], doing the occasional freelance gig, and somehow this has filled my time. As an ambitious person, it seems weird to me to have been able to go an entire year without any major changes (never mind the fact that I bought a new house and moved in the middle of the summer, and I'm a Cub Scout leader now). In some ways I was sating my need for growth by solving hard problems with boring tech.

It makes for (very) brief periods of excitement&mdash;problem solved! hooray! 🎉🍻&mdash;interspersed with lots of headaches and hair pulling. By contrast, when learning a new piece of technology, every time you master another bit of it you're rewarded with endorphins for having learned something new and exciting.

The first step is admitting you have a problem.

In the last two weeks, I've started learning [React][react] and really making an effort to learn [ES2015][es2015] (I've only dabbled until now). I haven't combined the two yet. I don't yet understand ES2015 well enough to be able to look at it and understand how it works instantly, like I can with ES5. I'm also very interested in the static-website-generator craze. In fact I'm writing this blog post as my first new entry to a [Jekyll][jekyll] blog that I intend to host via [GitHub Pages][ghpages].

2016 will be a high-growth year for me. That's my goal. I guess I'm a little early for the New Years Resolution party, but planning ahead is a good way to set myself up for success, right?

Now if you'll excuse me, I have some React components to write.

[ecma]: https://en.wikipedia.org/wiki/ECMAScript
[iq]: http://www.alumniq.com
[react]: https://facebook.github.io/react/
[es2015]: https://babeljs.io/docs/learn-es2015/
[jekyll]: https://jekyllrb.com/
[ghpages]: https://pages.github.com/
