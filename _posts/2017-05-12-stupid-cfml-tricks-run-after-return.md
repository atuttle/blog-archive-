---
layout: post
categories: 'adam'
cover: 'assets/images/covers/spiderweb.jpg'
cover_blur: false
title: "Stupid CFML Tricks: Run after return"
summary: "Adam discovers an inadvisable approach to running one-off background tasks in CFML"
date: 2017-05-12 15:30:00
tags: CFML
subclass: 'post'
navigation: True
---

A few months back I ran into an interesting situation where I needed to use try/finally, but this was inside a method and I wanted to return a value from within the try. So I tried it, and to my surprise it worked!

```
try {
	return 1;
} finally {
	writeLog( file: "debug", text: "I'm still here, doing my thing!" );
}
```

It occurred to me that you could use this to your advantage to provide an early-returning method once all remaining work can be done in the background and won't affect the response. For example, audit logging.

```
component displayName="fooController" {

	property auditService;
	property fooService;

	function save( form ){
		try {
			return fooService.saveChanges( form );
		} finally {
			auditService.audit( 'save-changes', session.user, form );
		}
	}

}
```

In this case, the audit should never affect the response of the save request, even if it were to fail for some reason.

I found this mildly interesting, but I don't recommend putting a ton of work in your finally blocks. I don't know what will happen if the thread is ready to return to the user but you're still giving it a lot of work to do, or any other edge- or corner-case.

In my case, I'm using it for cases where cleanup work absolutely must be done, no matter what, even if an exception is thrown; but this is usually something small like 1 little query, not a lot of background processing. I would reasonably expect my cleanup tasks to be done before the view were even done rendering.

Filed under interesting but probably not advisable.
