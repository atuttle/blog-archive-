---
layout: post
categories: 'adam'
cover: 'assets/images/covers/astronaut-art.jpg'
title: Advanced Authentication with Taffy APIs
date:  2013-07-10
location: Coatesville, PA, USA
tags: taffy security
subclass: 'post'
navigation: True
---

I get a lot of advice requests for Taffy implementations, but the one I get most commonly has to be non-trivial authentication.

What separates trivial from non-trivial? What I'd consider "trivial" authentication would be using SSL and requiring HTTP Basic Auth with every request. It's simple and it doesn't reinvent the wheel. In version 1.3, Taffy also added [a helper method for getting the Basic Auth credentials](http://docs.taffy.io/3.1.0#getbasicauthcredentials) so that you can easily validate them and respond as appropriate.

Non-trivial would be anything more complicated than that. Anything up to and including OAuth. I've never had the pleasure of implementing OAuth, but I regularly do a slightly simplified version, which I'll explain for you in this post.

OAuth was designed for the use-case when there are 3 separate parties involved; for example Twitter, your Twitter App of choice, and you -- you being the granting authority for your Twitter account. OAuth is a way for you to tell Twitter that it's ok for {Twitter App Of The Week} to use your account on your behalf, without giving that application your password, and in such a way that you and Twitter can work together to revoke that app's privileges instantly and at any time.

I have done a lot of APIs where there are only two involved parties: The account holder ("you") and the API/client; because the API provider also provides (codes) the apps. What I'm about to describe works very well, and actually pretty easily, in this last situation.

### Let's Talk Theory

My apps generally allow you to use multiple devices -- perhaps you have both an iPad and an iPhone, and you want to use our app from both. Nothing wrong with that, right? But there's always the concern that someone might get your password or steal your phone and start doing less than desirable things with your account.

You, as the API designer, want to be able to revoke a specific device's access individually (e.g. kick the 2nd iPad connected to your account out, without kicking out the 1st iPad or the iPhone), so that means each device will authenticate and then from that point on include a token with each request instead of the username & password. Each device gets a unique token, and all tokens are tied back to a single account. An account can have many device tokens.

As far as the user is concerned, they just need to log in once on each device, and from then on every time they use the app they're already logged in. As far as I -- the APP & API administrator -- am concerned, you or I (on your behalf if I detect suspicious activity) can easily block a single discrete device at any time by revoking its token.

Sound Good? Let's Implement It.

### Step 1: Authentication & Token Generation

The first thing you need is an API endpoint that accepts authentication requests and will return the device its own token on a successful authentication.

```
component extends="taffy.core.resource" taffy_uri="/authenticate" {

    public function post(username, password, deviceId) {

        //implementation of verifying the username/password are up to you...
        var authSuccess = authenticate(username, password);

        if (!authSuccess){
            return noData().withStatus(401, "Not Authorized");
        }

        //create a new device token:
        var deviceToken = createUUID();

        //saving the device token to the database is up to you...
        saveDeviceToken(username, deviceId, deviceToken);

        //tell the device auth was successful and give it the device token
        return representationOf({ token: deviceToken }).withStatus(200, "OK");

    }

    private function authenticate(username, password){}
    private function saveDeviceToken(username, deviceId, deviceToken){}

}
```

You'll notice that in addition to the username and password we're also accepting a deviceId. The majority of my mobile development experience is with Phonegap, wherein we can access the device id on Android, and a UUID that represents the device-installation on iOS (this will change if the user uninstalls and reinstalls the application). You can capture whatever metadata you like here. In addition to deviceId, we tend to also grab OS version and a few other little things so that we can data-mine our install base, as well as tie any in-app feedback back to a particular device (e.g. lots of reports of a bug from iPad2 but nothing from the original iPad). The sky is the limit, you just need to store this metadata with the device token.

If you wanted to, you could add an additional check for an existing device token for the supplied device Id, and return that if it exists instead of creating a new one.

### Step 2: Require the Token for (Almost) All Requests

This is done via the Taffy lifecycle event method `onTaffyRequest`, in `Application.cfc`:

```
component extends="taffy.core.api" {

    function onTaffyRequest(verb, cfc, requestArguments, mimeExt, headers){

        //allow white-listed requests through
        if (cfc == "authenticate"){
            return true;
        }

        //otherwise require a device token
        if (!structKeyExists(requestArguments, "deviceToken")){

            return newRepresentation().noData().withStatus(401, "Not Authenticated");

        //and make sure it's valid
        }else if (!validateToken(requestArguments.deviceToken)){

            return newRepresentation().noData().withStatus(403, "Not Authorized");

        }

        //if a token is included, and valid, allow the request to continue
        return true;
    }

    private function validateToken(token){}

}
```

We verify that the `cfc` argument is `authenticate`, because the authentication cfc was named `authenticate.cfc`. [BeanId rules apply](https://github.com/atuttle/Taffy/wiki/Organizing-your-resources-into-subfolders). This effectively white-lists every method in the `authenticate` cfc, but if you want to be more selective you could also check the verb argument to see which method is being requested.

### Where do we go from here?

We've now setup a situation in which all requests require a device token (a.k.a. API Key), unless currently authenticating. This device token implies a few things, and it's possible to inject them into the request context so that they're made available in every resource automatically. For example, what if most of your resources wanted to know the username of the account making the request? Instead of having the device include it in the request details, you can look it up during request startup and add it to the request arguments.

Here we'll be building onto `onTaffyRequest`. For the sake of brevity I'm going to omit the parts I wrote above for authentication. Just know that you can (and should) include the code for both. I would do what follows after everything from the previous example, before the final `return true;`.

```
function onTaffyRequest(verb, cfc, requestArguments, mimeExt, headers){

    var userMetadata = getUserMetadata(requestArguments.deviceToken);
    structAppend(requestArguments, userMetadata);

    return true;

}

private function getUserMetadata(deviceToken){}
```

If `getUserMetadata` returns a structure, all of the data from the structure will be passed to the requested resource as if it were part of the request. You can use the device token to lookup the username, or userId, or device type, or myriad other things available in your data through that user-association. Be careful, however: This happens for every request. Don't use it lightly. (e.g. Don't run two database queries when one will do.)

How do you access this injected data? The same way you access other request arguments: through method arguments.

```
component extends="taffy.core.resource" taffy_uri="/widgets/sprockets/{sprocketTypeId}" {

    function get(sprocketTypeId, color, userId){

        //the device will include the sprocketTypeId in the URI, and the desired color in the request arguments

        //but you've used the deviceToken to look up the userId and injected it into the request arguments

        //all three values are available through the method arguments

    }

}
```

I hope this has clearly explained what I consider to be a relatively complex (but no OAuth!) authentication mechanism that is robust and secure. When you break it down into discrete chunks like this, there's really not a whole lot to it, and that's a big part of why I like Taffy's approach. Less is more!

Finally, remember that there are an infinite number of ways to remove the epidermis from your feline. Don't feel like you have to do it this way -- this is just an explanation of how I like to set things up, in the hopes that it inspires you or possibly even completely meets your needs.
