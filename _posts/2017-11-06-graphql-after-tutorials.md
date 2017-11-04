---
layout: post
categories: 'adam'
cover: 'assets/images/covers/transit.jpg'
cover_blur: false
title: 'GraphQL After Tutorials: The blog post I wish I had when I started'
date: 2017-11-06
location: Coatesville, PA, USA
tags: GraphQL
subclass: 'post'
navigation: True
---

There is a ton of great getting started content out there for you to, well, get started with GraphQL. For starters, I recommend [How To GraphQL](https://www.howtographql.com/). And if your server platform of choice is node.js, I also recommend [Apollo Server](https://github.com/apollographql/apollo-server) because it does a tremendous job of getting rid of boilerplate and letting you focus on your schema and resolvers. Of course, if you're using React for your front-end, they also make a pretty great GraphQL client: [Apollo Client](https://github.com/apollographql/apollo-client).

But what I wanted to write about here is all of the things that were going on in my head after I finished the getting started tutorials. So I'm going to assume you've got a little bit of your schema and resolvers written and they're working well.

But what about related data types from my schema? What about authentication? Action-authorization? Error logging? How does my client get the inserted id back from a create mutation?

### Related Data

This one is specific to Apollo Server. You have a `User` type and a `Role` type, and users can have Roles:

```js
type Role {
	roleId: Int!
	name: String
}

type User {
	userId: ID!
	name: String
	roles: [Role]
}
```

If you're using a traditional SQL database then you likely have a table that defines that many-to-many relationship. How do you query that?

There's a special place to put that resolver:

```js{3-7}
const resolvers = {
	Query: {...},
	User: {
		roles(obj) {
			return roleService.getUserRoles(obj.userId);
		}
	},
	Mutation: {...}
};
```

The `obj` arg passed to this `User.roles` resolver is the User record after it gets resolved.

> **Note:** This is not the most efficient approach, using two separate queries. I've heard rumors that it's possible to "look ahead" at the incoming query and detect certain situations to fork off to a more efficient single-query approach. I haven't figured that out yet.

### Authentication

The general line here is, "don't reinvent the wheel." Whatever you're using for the rest of your application should be fine for the API too. This took me some time to wrap my head around since I've spent years adding token-based auth to REST APIs.

In my case, I've got an Express-powered web app using `express-session` and `connect-redis` to load people's sessions. There are a couple of different ways to use Apollo Server but to hook into your Express Session plugin setup, you need to use `graphqlExpress` (provided in `apollo-server`) to create an Express instance and then hook it up to Apollo Server. In the options for graphqlExpress you can pass a `context` object, to be passed to all resolvers.

```js{7-8}
server.use(
	'/graphql',
	bodyParser.json(),
	graphqlExpress(request => {
		return {
			schema,
			//make req user available to all resolvers
			context: { user: request.session.user }
		};
	})
);
```

Of course this assumes that you've already created `session.user` -- the same way that you would for any other web app.

This _does not_ reject requests that aren't logged in. Just like a regular express app, that would be up to you too. The usual approach for your web app is to redirect to the login screen. For REST APIs the usual approach is to return a 401, which the client understands to mean that the user isn't authenticated. I don't know if that's the official solution for GraphQL APIs too, but it's what I'm doing:

```js
server.use((req, res, next) => {
	if ( !req.session.hasOwnProperty('user') ){
		return res.status(401).end();
	}
});
```

#### Action-Authorization

Now that I know the person making the request is logged in, what if I want to make sure they don't do things they shouldn't have access to?

Let's assume you have a service method that is used to save updates to user accounts, but in order to use it you want to make sure the user has a specific role, `save-user`.

The first thing you need to do is get that session user from the resolver's context argument and pass it to the service method:

```js{4-5}
const resolvers = {
	Query: {...},
	Mutation: {
		saveUser: (root, args, context) => {
			return userService.saveUser(context.user, args.user);
		}
	}
};
```

And then you need to enforce the role requirement:

```js{2-3}
const saveUser = (reqUser, userToSave) => {
	if ( reqUser.roles.indexOf('save-user') === -1 ){
		throw new Error("Access Error");
	}
	//save userToSave...
};
```

### Error Logging

This one turns out to be pretty easy. What you do with the errors is up to you (write to a log file, push them out to a service like Raygun, etc). We just need to give Apollo Server a function that does what we want with the exception:

```javascript{7}
server.use(
	'/graphql',
	bodyParser.json(),
	graphqlExpress(request => {
		return {
			schema,
			formatError: (err) => { console.error(err.stack); },
			context: { user: request.session.user }
		};
	})
);
```

### Getting inserted id from mutation

Apollo client gives us a really powerful `mutate` method ([docs](https://www.apollographql.com/docs/react/basics/mutations.html#calling-mutations)), but of course with power comes a bit of complexity. One common necessity that I ran into and had some trouble with, even after following a tutorial that showed me exactly this, was getting the inserted id value back from a mutation that creates a database row.

Let's say we're creating a new user and after it's saved we want to redirect to the view/edit screen for the new record. The mutate options object can contain an `update` method that gets called with the response from the mutation. So if your createUser mutation returns the created user, you might do the following:

```js{3-4}
mutate({
	variables: { user: userToSave },
	update: (store, { data: user }) => {
		redirectToEditUser( user.userId );
	}
});
```

## What's next?

This post represents most of what I've learned in the last week or two as I've gotten the first few screens of my app ported over to GraphQL.

What's next? Honestly, I don't really know! _Unknown unknowns._ Eventually I want to figure out that more efficient lookup approach I mentioned in the **Related Data** section. But I'm sure I still have much to learn about GraphQL, so expect more tips in the future...

Did this post help you out? [Send me a shout-out on Twitter](https://twitter.com/AdamTuttle). I'd love to hear from you.