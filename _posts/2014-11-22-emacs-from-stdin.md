---
layout: post
title:  "Reading from stdin to an emacs buffer"
categories: emacs unix stdin shell
---

Sometimes the way emacs utterly ignores standard unix conventions can be pretty annoying. In particular the fact that, unlike almost every other standard unix tool, you can't give it `-` instead of a filename and have it read from stdin has always annoyed me. So today I've final sat down and figured out how to hack around this limitation.[^1]

First of all I should note that there is an existing package called [`e-sink`](https://github.com/lewang/e-sink) to read from stdin. However the code seems unnecessarily complex (probably doesn't help that I don't know perl).

So, here's my solution:

{% highlight bash %}
# Intelligently run emacsclient, and run server if needed. This preserves
# all command line args, which doesn't happen if we allow emacsclient to
# create the server itself (by setting -a '').
function emacs_client_or_server
{
    emacsclient -c -n "$@" -a 'false' || \
        (\emacs --daemon && emacsclient -c -n "$@")
}

# Emacsclient with ability to read from piped stdin.
function e
{
    # If the argument is - then write stdin to a tempfile and open the
    # tempfile. Otherwise just run emacsclient. -c and -n are just my
    # preferred options.
    if [[ $1 == - ]]; then
        tempfile=$(mktemp emacs-stdin-$USER.XXXXXXX --tmpdir)
        cat - > $tempfile
        emacs_client_or_server -e "(progn (find-file \"$tempfile\")
                                                    (set-visited-file-name nil)
                                                    (rename-buffer \"*stdin*\" t))
                                             " 2>&1 > /dev/null
    else
        emacs_client_or_server "$@"
    fi
}
{% endhighlight %}


The function is called as

{% highlight bash %}
echo "hello world" | e -
{% endhighlight %}

or

{% highlight bash %}
e hello_world.txt
{% endhighlight %}


It's actually slightly more complex than is strictly required because I like to run emacs in server mode and spawn clients at will. So the helper function `emacs_client_or_server` also handles the creation of a server when required. If you prefer to use a standalone emacs just replace `emacs_client_or_server -c -n` with `emacs`.

One more note: each time you read from stdin a temporary file in `/tmp` is created, these are typically cleared on reboot which is good enough for me. If you need them to be gone immediately you could add `rm $tempfile` inside the `if` statement.


As always the code is [on github](https://github.com/davidshepherd7/emacs-read-stdin).

[^1]: Yes, I know emacs came from lisp machines not unix, but it's been used on unix machines since [before I was born](http://en.wikipedia.org/wiki/GNU_Emacs#History).

