---
layout: post
title:  "Creating an Emacs MELPA package with Cask"
date: 2015-06-20
categories: Emacs, packaging
---

[Cask](https://github.com/cask/cask) is a great tool but is currently a bit
lacking in documentation, so I thought I'd contribute a little by
documenting how I created the
[MELPA](https://github.com/milkypostman/melpa) package for
[electric-operator](https://github.com/davidshepherd7/electric-operator)
using Cask.


# Why Cask?

The Cask documentation compares it to Ruby's gemspec or node.js's
package.json. If you already know what those are then great, you probably
know why you want to use Cask. If (like me) you have no idea then you might
be a bit stuck, so I'll try to explain.

Basically: Cask aims to take care of all the annoying fiddly bits involved
in Emacs package development.

I would say that the main feature is that it installs the *correct
versions* of dependencies *locally*. By locally I mean that packages
installed with cask don't "leak" into your real Emacs config. It also
provides support for running Emacs commands (think: compiling, testing)
with these local packages.

For example imagine your package requires the latest version of `dash` to
run its tests, but a contributor is using an older version and doesn't want
to upgrade (maybe their favourite package only works with the older
version). Without Cask they would be stuck, but by using Cask they can have
both versions of `dash` installed.


# Cask for package creation

Cask also handles the automatic creation packaging information from its
knowledge of the dependencies. That's what I'm going to talk about for the
rest of this post.

The standard way to specify dependencies for a package, at least for
packages consisting of a single `.el` file, is to write a specially
formatted comment at the top of the file. This seems very error prone to
me, it would be so easy to forget to add a new dependency or update a
version number! The advantage of using Cask for this is that it already
knows all about your dependencies. Even better: the Cask's information
about your dependencies *must* be correct, because when running tests or
compilation with cask the *only* visible packages are the specified
dependencies.

The downside is that Cask puts it's package information in a separate file.
So you have to create a multi-file packages which is a
[bit more complex](http://www.gnu.org/software/emacs/manual/html_node/elisp/Multi_002dfile-Packages.html).
Luckily MELPA takes care of all the extra complexity for us.


# The Cask file

All of Cask's information about dependencies is stored in a file named
`Cask`. Here's the contents of the `Cask` file for electric-operator:

    (package "electric-operator" "0.1" "Automatically add spaces around operators")

    (files "electric-operator.el")

    (source melpa)

    (depends-on "dash")
    (depends-on "s")

    ;; Need at least this version for dash's threading macros
    (depends-on "names" "20150618.0")

    (development
     (depends-on "ecukes")
     (depends-on "espuds"))


I think it's pretty self explanatory, so I'll just add that the
documentation for the file format is
[here](https://cask.readthedocs.org/en/latest/guide/dsl.html).

Once the Cask file is defined you can generate the package information file
(`electric-operator-pkg.el` in my case) for your package just by running

    cask pkg-file



# Create a MELPA recipe

MELPA's github-repo-to-emacs-package transformation is pretty much magic.
All you need to do is add a
[recipe file](https://github.com/milkypostman/melpa#recipe-format) for your
package to the MELPA github repository (using the normal github method of
fork, modify and pull-request). That's it! Although you should also read
and follow
[the contribution guidelines](https://github.com/milkypostman/melpa#contributing-new-recipes)
before actually submitting a pull-request for your recipe.

The recipe file for electric-operator is very simple:

    (electric-operator :repo "davidshepherd7/electric-operator"
                       :fetcher github
                       :files ("electric-operator.el" "electric-operator-pkg.el"))

other single-elisp-file recipes will proabaly be very similar.
