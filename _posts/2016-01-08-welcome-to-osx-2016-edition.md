---
layout: post
categories: 'adam'
cover: 'assets/images/covers/macbook-in-the-dark.jpg'
title:  'Welcome to OSX, 2016 Edition'
summary: "Adam forgot to write a post summary here to show up on social sites. Whoops!"
date:   2016-01-08 13:30:00
tags: OSX Tips
subclass: 'post'
navigation: True
---

Recently a friend told me that he had switched to a Mac full time and asked if I had any advice for software, or just in terms of general usage. I would have swarn that I already had a blog post on the topic that I wanted to link to him (outdated though it may be), but try as I might I couldn't find it. So here we go, I'm starting from scratch!

## Fundamental Improvements: TotalFinder, iTerm2, and TotalSpaces

I find the default experience with Finder to be grating. In my Windows days I used [TotalCommander][tcmd] almost exclusively to deal with the File System, and I had memorized tons of keyboard shortcuts to the point where I almost never needed the mouse. There exists a similar app for OSX, called [Path Finder][pathfinder], _which I don't use._ I first stumbled on Path Finder before I was really able to afford spending a bunch of money on apps like that (I bought my first Mac, a base-model 12" macbook, refurbished, on Black Friday). In the interim I started using a free app that made my terminal into a Visor (more on that next), and then later the same developer introduced [TotalFinder][totalfinder].

I can't say enough good things about TotalFinder: Almost everything that gets on my nerves about the default Finder melts away with TF. I use it as a Visor (pops up from the bottom of my screen when I hit a global keyboard shortcut), frequently use the "dual mode" of side-by-side finders, love the Chrome tabs, and I'm _so_ happy to be able to force folders to sort to the top. There are many more features, but even just those alone are worth the $9 license to me.

Now back to that Terminal visor. BinaryAge, developers of TotalFinder, also had a free product called [TotalTerminal][totalterminal] (no longer actively developed and not compatible with OSX 10.11+) which, for me, harkened back to my days playing the original Quake. With my global keyboard shortcut <code>ctrl+`</code>, an always-available terminal window would slide down from the top of the screen to await my commands. Very handy. For reasons surrounding Zsh and Oh-my-zsh, I've abandoned the default OSX terminal app in favor of [iTerm2][iterm], which is much more customizable and also supports the Visor feature.

I have <code>alt+&grave;</code> configured as my Finder visor shortcut, and <code>ctrl+&grave;</code> for my terminal. That's the "back-tick" or "grave" character &ndash; the one above my TAB key and what you get if you omit the Shift key when typing `~`. These two things are core to the way I work on my laptop, and being on a machine without them slows me down and trips me up significantly.

I also use [TotalSpaces][totalspaces], though I flip between phases where I prefer everything to have its own space and everything in one space with just `cmd+tab` to switch between them. Currently the latter. Regardless, TotalSpaces is worth $9 to get back the awesome Exposé functionality from the days before Lion. [I really hate Mission Control][expose].

## Developer Stuff

In my terminal, I prefer to use Zsh with [Oh-my-zsh][omz]. There are dozens of great plugins and even more themes to choose from.

I write my code in [Sublime Text 3][sublime], and also keep my eye on [Atom][atom] though the plugin ecosystem is still too lacking to make it my daily driver. I have already documented [my sublime keymap][keymap] pretty thoroughly. Plugins, all available through package control:

- AdvancedNewFile
- AutoFileName
- AutoSpell
- Babel
- Babel snippets
- ColdFusion (sigh)
- Color Highlighter
- GitGutter
- GutterColor
- Indent XML
- JavaScriptNext - ES6 Syntax
- JSCS-Formatter
- JSHint Gutter
- LESS
- Material Theme
- Number King
- Package Control
- React Templates
- ReactJS Snippets
- SideBarEnhancements
- SublimeLinter
- SublimeLinter-jscs

I also write my blog posts in Sublime using Markdown. It's all [hosted on GitHub][blog], actually. For managing MySQL databases (local and remote) I use [Sequel Pro][sql].

Pretty much everything else that I use near-daily is [Node.js][node] and node modules. I currently use Grunt pretty heavily to do LESS, Handlebars.js, and Browserify compiling, along with a few other things (sourcemaps, [cache busting][cache], etc); but I see myself moving toward Gulp/Webpack in the future. Just need time to learn them. If you just need to stand up a quick basic static-file web server in a random directory, I like [nws][nws].

Do enough Node stuff and eventually you'll run into native modules that require compiling locally on your system. That, or if you do any iOS development at all (even with PhoneGap), you're going to need XCode. Better to just bite the bullet early and install it / update it as needed through the App Store.

On the off chance that you need an (S)FTP/S3 client, [Transmit][transmit] is pretty good.

[Microsoft Remote Desktop][rdp] is actually reasonably good for managing a few windows boxes remotely. And if you need to test something in Internet Explorer, you can get free virtual machines for most flavors from [modern.ie](https://dev.windows.com/en-us/microsoft-edge/tools/vms/mac/). I use [VirtualBox][virtualbox] for my VM's.

Most of the time I do my Git work in the terminal, but occasionally I'll want a GUI for block-level staging or history browsing. In those cases I like [SourceTree][sourcetree].

I use Keynote for presentations where I won't be doing any live code demos, or various web presentation frameworks when I am.

## Other Great Stuff

You _will not find a better password manager_ than [1Password][1p]. Fast, secure, and beautiful to boot. Integrates really well with major browsers and has system keyboard shortcuts for quick access. They even have an Android Keyboard that makes accessing your passwords on the go a snap. I bought a family license and forced it on my wife and mom, too. When my kids are old enough to start having passwords for stuff, they'll be forced into it too.

All of the computers in my house backup to [Backblaze][backblaze].

For email, I've tried a bunch over the years. None are ever as good as straight up webmail. That said, _all_ of my email is through Google Mail. If you have a work Exchange server or something, I can understand why you would want a local native client. I just don't have a recommendation for you.

I have access to somewhere between half a dozen and a dozen calendars, and coordinating them can be a real pain. I really like [Sunrise Calendar][sunrise] and was deeply saddened to hear that they were aqui-hired and will be shutting down the public facing options eventually.

For a basic running todo list I use [Todoist][todoist]. I tried premium but didn't feel the added features were worth it to me. For taking notes, I like [Write][write]. I sync them with DropBox so that they are also available on my iPod and iPad.

I use [LibreOffice][libre] for office documents. Whatever you do, [don't use OpenOffice][notoo]!

If I need to record some or all of my screen, I always use QuickTime Player (should come on your Mac). I don't do a ton of video editing yet, so iMovie is still sufficient for my needs. I see [FinalCut][finalcut] in my future, though. Just like Windows, the best video player is [VLC][vlc] hands down.

Need to figure out what's eating up so much disk space? Try [Disk Inventory X][dix].

I don't have any scientific data to back this up, but subjectively I feel like my eyes are _way_ less strained working on the computer late at night with [Flux][flux]. It reddens (de-blues?) your screen more as more time passes after sunset.

Have you got more great app suggestions? [Let me know what they are!][twitter]

[tcmd]: http://www.ghisler.com/
[pathfinder]: http://www.cocoatech.com/pathfinder/
[totalfinder]: http://totalfinder.binaryage.com/
[totalterminal]: http://totalterminal.binaryage.com/
[iterm]: https://www.iterm2.com/
[totalspaces]: http://totalspaces.binaryage.com/
[expose]: http://fusiongrokker.com/post/what-i-hate-about-osx-lion-s-mission-control
[omz]: http://ohmyz.sh/
[sublime]: http://www.sublimetext.com/3
[atom]: https://atom.io/
[keymap]: http://fusiongrokker.com/post/my-sublime-keymap-common-kb-shortcuts
[sql]: http://www.sequelpro.com/
[blog]: https://github.com/atuttle/blog
[node]: https://nodejs.org/
[cache]: http://adamtuttle.codes/modern-cache-busting-for-the-platforms-of-yeasteryear/
[nws]: https://github.com/knpwrs/nws
[transmit]: https://panic.com/transmit/
[rdp]: https://itunes.apple.com/us/app/microsoft-remote-desktop/id715768417?mt=12
[virtualbox]: https://www.virtualbox.org/wiki/Downloads
[sourcetree]: https://www.sourcetreeapp.com/
[1p]: https://agilebits.com/onepassword
[backblaze]: https://www.backblaze.com/
[sunrise]: https://calendar.sunrise.am/
[todoist]: https://en.todoist.com/
[write]: http://writeapp.net/mac/
[libre]: https://www.libreoffice.org/
[notoo]: http://www.theguardian.com/technology/askjack/2015/sep/03/switch-openoffice-libreoffice-or-microsoft-office
[finalcut]: http://www.apple.com/final-cut-pro/
[vlc]: http://www.videolan.org/vlc/index.html
[dix]: http://www.derlien.com/
[flux]: https://justgetflux.com/
[twitter]: https://twitter.com/adamtuttle
