---
layout: post
title:  "Tearing out the Emacs windows manager"
categories: emacs xmonad tiling-windows-manager
---

There's an old joke: "Emacs is a great operating system, but it's a shame they didn't include a decent text editor". Obviously since I'm writing about Emacs I don't agree with the second part, but it's hard to argue that Emacs' feature list isn't a little over the top. This post will describe how to go a small way towards fixing that by replacing Emacs' built in [tiling window manager][] with something more general.


Before I talk about anything else I want to mention the [terminology that Emacs uses to describe windows][emacswindows]. The thing that most people would call a window is labelled a "frame" in Emacs language. The sub-sections of a single frame are (annoyingly) called "windows". By default almost everything in Emacs is handled by opening new "windows" inside a single frame. The layout of these windows is handled by a built-in tiling window manager.


So what's wrong with Emacs' tiling window manager?
---------

My main reason for disliking the built in windows manager is that it assumes everything you want to work with is inside Emacs. There's no support for tiling a chromium window or a terminal along with a few Emacs windows. This probably worked quite well when people did everything in a single terminal session but not so much anymore.

Secondly if your main windows manager is also tiling then the two will conflict with each other in annoying ways. For example opening a new terminal emulator will completely wreck your nicely laid out Emacs windows.

Finally it means you need two separate sets of keys to do almost the same thing inside or outside of Emacs. Pretty nasty and pointless!


Using frames instead of Emacs windows
-----

The easiest solution to these problems is (try) to never open multiple Emacs windows inside a single frame. One setting takes care of this in a lot of places:

{% highlight scm %}
    ;; Make new frames instead of new windows
    (set 'pop-up-frames 'graphic-only)
{% endhighlight %}

Unfortunately this doesn't so well work with the "grand-unified-debugger" mode (gud), which is used for running `gdb` etc. To try to control gud's window spam we can set:

{% highlight scm %}
(set 'gdb-use-separate-io-buffer nil)
(set 'gdb-many-windows nil)
{% endhighlight %}

It's not perfect but it should reduce the number of windows spawned.

Similarly for org mode we need to change some extra settings

{% highlight scm %}
(set 'org-agenda-window-setup 'other-frame)
(set 'org-src-window-setup 'other-frame)
{% endhighlight %}

Finally we need to modify some settings in the emacs window manager to prevent weird stuff happening when we follow links:
{% highlight scm %}
;; Focus follows mouse off to prevent crazy things happening when I click on
;; e.g. compilation error links.
(set 'mouse-autoselect-window nil)
(set 'focus-follows-mouse nil)
{% endhighlight %}

Dealing with temporary buffers
----------------

So now we have an Emacs that (mostly) spawns new frames instead of windows. This means it spawns a new frame every time it wants to show you, for example, a list of potential completions. Unfortunately by default these frames are left lying around after you are done with the temporary buffer, which gets very annoying!

Again one setting will deal with most cases of this problem (the difficulty is in finding the required setting):

{% highlight scm %}
;; kill frames when a buffer is buried, makes most things play nice with
;; frames
(set 'frame-auto-hide-function 'delete-frame)
{% endhighlight %}

Now whenever a buffer is buried (usually by pressing "q" in a temp buffer or by selecting a completion candidate) the containing frame will be killed as well.

Unfortunately this doesn't work with a few packages, in particular [RefTeX][]'s reference selection buffer has been a problem for me. Luckily there is a hook called when a buffer is killed that we can use to also close the frame.


{% highlight scm %}
(defvar kill-frame-when-buffer-killed-buffer-list
  '("*RefTeX Select*" "*Help*" "*Popup Help*")
  "Buffer names for which the containing frame should be
  killed when the buffer is killed.")

(defun kill-frame-if-current-buffer-matches ()
  "Kill frames as well when certain buffers are closed, helps stop some
  packages spamming frames."
 (interactive)
 (if (member (buffer-name) kill-frame-when-buffer-killed-buffer-list)
     (delete-frame)))

(add-hook 'kill-buffer-hook 'kill-frame-if-current-buffer-matches)
{% endhighlight %}



Integrating with the windows manager
------------

Half the point of a tiling window manager is to be able to launch and kill windows easily and quickly, but what if we accidentally kill the last Emacs frame? If we are running Emacs in the normal way it will save and close down, then next time we launch it all the start up code has to execute again.

A better way to handle this is to run Emacs in server (a.k.a. daemon) mode. This means you start an emacs server which stays running in the background and you spawn/kill instances of emacsclient as you work. As an additional benefit it means that all your emacs instances share the same buffers, history, settings, etc.

To run emacs in server mode simply add the following to your config files:
{% highlight scm %}
;; Start emacs as a server
(server-start)
{% endhighlight %}

easy!

Now we need to create some new commands for launching emacsclients instead of emacs itself. First a bash alias:
{% highlight bash %}
alias emacs='emacsclient -c -n -e'
{% endhighlight %}

The `-c` creates a new frame and the `-n` detaches the client from the bash console. Handily if you run this command when no server exists it will create one before launching the client.

Finally we want a command which we can bind to a button in the window manager to launch a new emacsclient. For this I use a slightly modified version of the alias above (I use [xmonad][] so this code actually just creates a haskell string which I later bind a key to execute as shell command):

{% highlight haskell %}
myEditor = "emacsclient -c -n -e '(switch-to-buffer nil)'"
{% endhighlight %}

You can see I've added an argument `-e '(switch-to-buffer nil)'`, this prevents the new client from opening the file named as an argument. Since we don't name any files for it to open the client would go to the scratch buffer by default, which is fairly useless. With this command it opens whichever buffer was most recently closed instead, much better!



Appendix: Dealing with auto-complete
--------

*I removed this section due to finding some new settings (the section on Dealing with temporary buffers) that allow easy closing of the frames spawned for temporary windows. Using ido was a work-around for the same problem for completion buffers only. I'm leaving this here anyway because ido is vastly superior to the default completion mechanisms (in my opinion at least).* 

The best way I've found to avoid problems with extra autocompletion buffer frames is to use the wonderful `ido` package, which displays completions inside the minibuffer instead. To make it work for everything you might want to auto-complete you'll also need the `ido-ubiquitous` and `smex` packages. Completion is now done with a handy menu looking something like this

![illustration of ido ]({{ site.url }}/assets/ido.png)

Well, actually to get it do show completions in a vertical list you need a little bit more configuration:

{% highlight scm %}
;; Display ido results vertically, rather than horizontally
(set 'ido-decorations '("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]"
                        " [Matched]" " [Not readable]" " [Too big]"
                        " [Confirm]"))
{% endhighlight %}

There are plenty of key bindings and settings to mess with in `ido`, but that would be an entire other blog post. [Emacswiki](http://www.emacswiki.org/emacs/InteractivelyDoThings#toc1) has plenty of stuff to play with as usual.


[tiling window manager]: https://en.wikipedia.org/wiki/Tiling_window_manager
[emacswindows]: http://blasphemousbits.wordpress.com/2007/05/04/learning-emacs-part-4-buffers-windows-and-frames/
[xmonad]: http://xmonad.org/
[RefTeX]: http://www.gnu.org/software/auctex/reftex.html



