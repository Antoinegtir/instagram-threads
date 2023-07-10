Contributing to Threads
=======================

We invite you to contribute to Threads! Please read the following sections

The objectif to contribute to the Threads repo is to submit new idea that could inspire the official BeReal developer to develop new features.

Helping out in the issue database
---------------------------------

Triage is the process of going through bug reports and determining if they are valid, finding out
how to reproduce them, catching duplicate reports, and generally making our issues list
useful for our engineers.

If you want to help us triage, you are very welcome to do so!


Quality Assurance
-----------------

One of the most useful tasks, closely related to triage, is finding and filing bug reports. Testing
beta releases, looking for regressions, creating test cases, adding to our test suites, and
other work along these lines can really drive the quality of the product up. Creating tests
that increase our test coverage, writing tests for issues others have filed, all these tasks
are really valuable contributions to open source projects.

Developing for Threads
----------------------

If you would prefer to write code, you may wish to start don't hesitate to fork the repo and submit a pull request.

### Branching and Merging

- Do not push directly to the main branch.
- Create a branch related to the current issue and make a pull request (PR) to merge the branch.
- At least one person must approve the PR before it can be merged.

To develop for Threads, you will eventually need to become familiar
with our processes and conventions. This section lists the documents
that describe these methodologies. The following list is ordered: you
are strongly recommended to go through these documents in the order
presented.

the name of the branch must be the number of the issue followed by the name of the issue with a gitmoji that explian expilicitly the change.


Here's an example of a valid PR message: `#001 : Improve the UI of the profile page 🎨`


1. [Setting up your framework development environment](https://github.com/flutter/flutter/wiki/Setting-up-the-Framework-development-environment),
   which describes the steps you need to configure your computer to
   work on Flutter's framework. Flutter's framework mainly uses Dart.

2. [Tree hygiene]()
   which covers how to land a PR, how to do code review, how to
   handle breaking changes, how to handle regressions, and how to
   handle post-commit test failures.

3. [Our style guide](),
   which includes advice for designing APIs for Flutter, and how to
   format code in the framework.
   Here's an example of a valid commit message: `✨ Added new feature to improve user experience`

# commit norm:

- :globe_with_meridians: = Docker & Virtual Env
- :sparkle: = to new features in the workspace
- :test_tube: = test politics
- :see_no_evil: = add ignore file
- :art: = improve some functions
- :bug: = fix some bugs
- :memo: = update documentation
- :construction: = start to build new feature
- :heavy_minus_sign: = remove code or file/folder
- :bricks: = split functions
- :adhesive_bandage: = norm code

Social events in the contributor community
------------------------------------------

Finally, one area where you could have a lot of impact is in contributing to social interactions among the Threads contributor community itself.

# Test Politics

- Test will be written in the same folder as the file to test

# Objectif of Contribution

- Write graphical unit test that allow to took sreenshot of each page of Threads, but you need to be authentificated by strength to firebase so instead use a prototype json the firebase data could not be injected so use the following json prototype in /proto of a classical user and the screenshot will be took.

- Write a pipeline that do the screenshot realized previously using  github action that do the screenshot and display them in the pull request in order to compare the graphical evolution of the app.
