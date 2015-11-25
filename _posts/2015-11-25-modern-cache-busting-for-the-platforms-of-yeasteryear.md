---
layout: post
categories: 'adam'
cover: 'assets/images/covers/balloon.jpg'
cover_blur: false
title:  'Modern Cache Busting for the Platforms of Yesteryear'
summary: "I wanted something that didn't require every developer to have to know and remember to update a version number in the layout file any time they made a CSS change. Since we're already using Grunt to compile our LESS into CSS, it made sense to find a way to build it into that process."
location: Coatesville, PA, USA
date:   2015-11-25 11:30
tags: Grunt CSS
subclass: 'post'
navigation: true
---

If you work with a platform born in the last 5-10 years, chances are pretty good you've got something like the [Rails asset pipeline][rap] to take care of stuff like this for you. But if your platform of choice (or in my case this time... platform of consequence) doesn't handle it for you, you may be wondering how best to integrate cache busting into your application.

The application I'm working on is built on ColdFusion, and it doesn't do this job for me. There are a lot of things I wish CF did that it doesn't, and when appropriate I solve these problems with a Grunt task. This application has a dozen or so different grunt tasks. Today I added cache busting, and I thought I'd share the process with you. It took me a few minutes of noodling about the best way to _automate_ the process to land on this solution.

Typically, the most basic cache busting is done by appending a query string to the request and changing that query string when you know that the file has changed:

```html
<link rel="stylesheet" href="style.css?bust_cache=123" />
```

I knew I wanted something that didn't require every developer on the team to have to know and remember to update a version number in the layout file any time they made a CSS change. Since we're already using Grunt to compile our LESS into CSS, it made sense to find a way to build it into that process, thus nothing new for the team to remember.

The first step was to register a new Grunt task to create my cache-busting value. I went with an MD5 hash of the current time, but there are lots of other alternative approaches you can employ. Another popular one is to MD5 hash the entire file.

```javascript
grunt.registerTask('cache-bust-admin', function() {
	var newHash = md5( new Date().getTime().toString() );
	fs.writeFileSync('./cache-admin.md5', newHash, 'utf8');
});
```

With this added to my Gruntfile, I added my new task to the task-set that's run automatically when LESS files change:

```javascript{8}
,watch: {
	less_admin: {
		files: ['www/admin/assets/css/*.*','www/admin/assets/less/**']
		,tasks: ['css:admin']
	}
}

grunt.registerTask('css:admin', ['less:admin','cache-bust-admin']);
```

Now, every time the CSS updates, `cache-admin.md5` updates too. The next step is to load it into my application, and then reference it from my layout. In my `Application.cfc` file:

```javascript{4-7}
function onApplicationStart(){
	/* ... */

	application.cache_hash = fileRead(
		expandPath('../../cache-admin.md5')
		, "utf-8"
	);
}
```

And the layout:

```html
<cfoutput>
	<link rel="stylesheet" href="style.css?cache=#application.cache_hash#" />
</cfoutput>
```

Every time we reinitialize our application &ndash; part of an automated deploy &ndash; it will read the contents of the `cache-admin.md5` file and store it in memory; then use that value to ensure css is always updated in the browser, while maintaining aggressive cacheing.

[rap]: http://guides.rubyonrails.org/asset_pipeline.html
