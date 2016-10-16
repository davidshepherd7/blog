---
layout: post
title:  "Debugging a slow system shutdown"
categories: linux systemd ninja
---

I've read some interesting debugging stories recently, so here's one of mine.
Hopefully it might help others who have similar issues.

Recently my laptop started taking *much* longer than usual to turn off:
instead of ~1 second it would take ~20. Around the same time I had the exact
same problem on my work machine which runs a different version of Ubuntu. So it
seemed likely that the issue was something in my configuration rather than a
real bug.

I started by [enabling persistant systemd logs](systemd-logs) so that I could
read the logs recorded during a shutdown. Once that was set up I rebooted the
laptop, then checked the logs with `journalctl --boot=-1`. Skimming through the
last few items I noticed that there was a 28 second wait before the line
`Stopped LSB: "privilege escalation detection system"` which seemed suspicious.

Some more googling and I found [this askUbuntu question](askUbuntu) by someone
having the same issue as me. It turns out that I'd unwittingly installed
something called ["ninja"](ninja-daemon) that watches out for suspicious looking
programs running as root. I suspect that on both of my machines I had attempted
to install [ninja-the-build system](ninja-build) (`apt-get install ninja-build`)
and instead installed ninja-the-monitoring-daemon (`apt-get install ninja`).

Moral of the story: check out unknown packages using `apt-cache show` before you install them!

[systemd-logs]: http://unix.stackexchange.com/questions/159221/how-display-log-messages-from-previous-boots-under-centos-7
[askUbuntu]: https://askubuntu.com/questions/786596/random-stop-jobs-on-shutdown-bootup
[ninja-daemon]: http://blog.bodhizazen.net/linux/how-to-ninja/
[ninja-build]: https://ninja-build.org/
