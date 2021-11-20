---
layout: post
title:  "Are custom dev setups worthwhile?"
date:  2021-11-20
categories:
---


I work on a heavily customised version of Ubuntu which I treat a bit like Arch
Linux but with more stable packages (i.e. custom X session with no GNOME etc,
only running what I configure). I also use Emacs with a lot of configuration for
almost all of my programming work. I was nudged down this path by [The Art of
Unix Programming](https://nakamotoinstitute.org/static/docs/taoup.pdf), and I
assumed that it would pay off but didn't have much real foresight on the issue.
In retrospect this kind of setup has some tradeoffs so I'm often unsure whether
to recommend that younger engineers do something similar or stick with more
standardised tools.

Being willing to put some effort into customising your setup can get you some
nice benefits, e.g.

* Tiling window managers to remove a lot of fiddling with window layouts.
* Hotkeys for the tools and commands that you use the most (e.g. opening your
  todo list in a new editor window with one keystroke).
* If using a mouse causes you RSI problems, no problem: configure things such
  that you rarely need to use one.
* You can choose to only use applications with a text-based configuration, store
  all of the files in git, and so be able to configure a new machine to work
  exactly the same way in minutes.
* You can use a more RSI-friendly keyboard layout (Colemak!) and rebind keys to
  be sensible in the alternative layout.
* You also gain the ability to quickly experiment with new ideas. Because you
  already understand the basics additional configuration is easy.

But maybe the most important thing is the knowledge that you get along the way.
In customising your environment you are forced to learn all sorts of little
things which can pay off later. I first learned about systemd, bash scripting,
udev, makefiles and much more in this way. All of these examples have been
useful in my day job. Learning about such things while trying to make your
window manager do something neat is much more fun and rewarding than learning
them from books or exercises. In fact I suspect almost no-one learns this stuff
in an academic way because it would be so dull!

You also gain more abstract knowledge too. The practice of customising your
environment pushes you to work closely with a wide variety of software written
in a wide variety of languages. This exposes you to various philosophies on
configuration, updating, compilation, dependency management, correctness etc.
For example you gain an appreciation for simple interfaces and code because it
makes your life eaisier. You get to see how different styles of typechecking and
auotmated testing play out in terms of how reliable the software is (spoiler:
old untested lisp code often doesn't do as well as e.g. well tested Haskell).

Along the same lines, you are pushed to experiment with multiple languages. My
go to languages for real work are python, C++, and javascript, but through
environment configuration I've had plenty of exposure to outliers like lisp,
Haskell and bash. This makes it easier to understand new languages or language
features e.g. my prior experience with lisp made it particularly easy for me to
understand javascript well.



One downside of all this is that it takes some work. As long as it's still fun
this isn't a problem, but sometimes these days I just want my computers to work
without needing to think about anything. An example: my laptop doesn't currently
autodetect external monitors. I know that I could write a udev rule to
automatically run the appropriate xrandr command but I haven't bothered yet. So
2.5 years after switching from a desktop to a laptop I still run a command
whenever I plug in a monitor.

Another is that sometimes you just have to live with something a little janky.
In my case I wanted a status bar containing live graphs of CPU/memory/disk and
applets for wifi, volume, skype, etc. But I couldn't find anything that supports
both so I'm actually running two status bars that look like they are one. This
is fine except that depending on the screen size there can be a slight gap or
overlap between them. Purely an aesthetic issue, but annoying nonetheless.

But maybe the biggest downside: the more standard your environment is the more
you can benefit from economies of scale in getting new features and keeping
everything bug-free. For example this seems to be happening with VS code - any
new text editing idea is quickly added to VS code, but sometimes they take
longer to reach Emacs (and longer still for a high quality version). Similarly
when you work for a sufficiently large company they will likely have some
engineers working on tooling and the more standard your enviroment is the more
you can benefit from this.

An aside: some people avoid doing a lot of custom configuration because they
want to be able to work easily on other people's computers. I haven't found this
to be an issue yet: I've probably spent double-digit hours working on other
people's computers vs >20,000 hours on mine!


So to sum it up: maybe. Some configuration is probably worth the effort (e.g.
tiling window managers and custom OS-level hotkeys are low effort, high payoff
and easy to maintain), others might not be worthwhile directly (e.g. [writing
your own Emacs package to do
autoformatting](https://github.com/davidshepherd7/electric-operator/)). But
aside from the direct benefits, tinkering with computers and programming for fun
outside of work can teach you a lot. If you find configuring your environment
fun then it is a great way to learn!
