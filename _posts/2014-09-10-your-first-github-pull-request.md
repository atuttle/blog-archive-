---
layout: post
categories: 'adam'
cover: 'assets/images/covers/branches.jpg'
title:  GitHub Tip for Your First Pull Request
date:   2014-09-10
location: Coatesville, PA, USA
tags: git github
subclass: 'post'
navigation: True
---

There is a mistake that I see a lot of people new to GitHub, or new to making Pull Requests, making. It's something I find myself explaining often in people's first PR threads; so I thought I would clean it up a little bit and share it here for the benefit of a wider audience.

In Git, unlike SVN and other centralized Version Control Systems, branches are easy, fast, and awesome. You should be using the heck out of them. And, if you're not, then that can come back to bite you when you get around to sending pull requests. I'll illustrate the problem with an example.

Let's say you want to contribute something to [CFDocs](https://github.com/foundeo/cfdocs). So you fork the repository, clone your fork to your local machine, and edit the code. You're only planning on doing this one little thing, so why bother making a branch?

You make your change, everything looks great, so you open a pull request. You select that you want to merge in the changes from your master branch into the original repo's master branch:

![Pull Request Screen Shot](/assets/images/posts/2014/pr-1.png)

You submit your pull request, and happily go on about your business. All is right with the world.

As it happens, it takes [Pete](https://foundeo.com/) a few days to get to your Pull Request, but in the meantime, you've become inspired at how easy it was to do that, so you want to help more!

You make more changes, push them up to your repository, and then... oops. Because you still have an open Pull Request against your master branch, pushing new commits to that branch updates the Pull Request and adds those commits. Oops indeed! These new commits have nothing to do with the original PR and really should not be included.

The solution to this problem is **branches**.

If you create a branch for each feature, or for each discrete pull-request that you want to submit, then they will stay in their separate silos. This is particularly important if the project author asks you to make changes (add tests, change formatting, etc). Then you can update the code in one branch without affecting the other; and as luck would have it, these changes are automatically merged into the PR when you push them up to your fork on GitHub.

Here's a more appropriate workflow:

1. Fork the repo to your account
1. Clone the repo to your local machine: `git clone https://github.com/atuttle/cfdocs.git` (replace the account and repo names, of course)
1. Create a branch to do your work in, and name it after what you're working on: `git checkout -B ormExecuteQueryImprovements`
1. Make your changes, and commit them to your local clone
1. Push your changes, in their branch, back up to GitHub: `git push -u origin ormExecuteQueryImprovements`
1. Then, open your PR and select this new branch as the HEAD of the PR.
1. Profit

I hope this saves you the headache of adding commits to the wrong Pull Request and helps you enjoy your experience with Git and GitHub a little bit more.

### Update

It was suggested that I also add information on pulling in upstream changes to stay up to date. Here you go!

As so often happens after you've forked, coded, and pull-requested, the project continues to move forward — instantly making your clone outdated and out of sync. If you want to continue to contribute, you need to pull in those "upstream" (e.g. from the canonical repo) changes so that your future pull requests are based on the latest code and can be more easily merged. If you don't, there's a chance that your changes will be difficult to merge, and possibly even based on outdated code, making them (hate to say it, but) nearly worthless! For ongoing participation via fork and pull-request, this process is absolutely critical.

Here's what I do:

1. Add a new remote to your local clone of your fork, named upstream, and using the git url (http or ssh) of the original repository that you forked. In my example I'm using the url for the **cfdocs** repo in the **foundeo** organization:<br/>`git remote add upstream https://github.com/foundeo/cfdocs.git`
1. Before starting new changes of your own, make sure you've got the latest code from upstream: `git checkout master` to get your own master branch and then `git pull --rebase upstream master` to merge in any changes from upstream.
  - **update-update:** I've recently decided to start using the `--rebase` flag on all of my pulls [to keep the revision history cleaner](http://gitready.com/advanced/2009/02/11/pull-with-rebase.html).
1. Now create your new branch for your new feature/bug-fix: `git checkout -B arrayMapImprovements`
1. Make your changes and commit them.
1. Merge upstream master again, into your branch this time (still just `git pull --rebase upstream master` — default target is your current branch), just to make sure that anything that changed since you started coding is also already merged (e.g. if it took you several days to make your changes, or if the canonical repo is fast-moving)
1. Submit your new pull request from your new branch. (Once accepted and merged into the original repository, your local feature branches can be deleted)
1. Rinse and repeat
