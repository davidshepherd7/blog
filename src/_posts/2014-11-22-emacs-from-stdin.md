---
layout: post
title:  "Reading from stdin to an emacs buffer"
categories: emacs unix stdin shell
---

Sometimes the way emacs utterly ignores standard unix conventions can be pretty annoying. In particular the fact that, unlike almost every other standard unix tool, you can't give it `-` instead of a filename and have it read from stdin has always annoyed me (yes, I know emacs came from lisp machines not unix, but it's been used on unix machines since [before I was born](http://en.wikipedia.org/wiki/GNU_Emacs#History)). So today I've final sat down and figured out how to hack around this limitation.

First of all I should note that there is an existing package called [`e-sink`](https://github.com/lewang/e-sink) to read from stdin. However the code seems unnecessarily complex (probably doesn't help that I don't know perl).

So, here's my solution:

{% highlight bash %}
# The emacs or emacsclient to use
function _emacsfun
{
    # Replace with `emacs` to not run as server/client
    emacsclient -c -n $@
}


# An emacs 'alias' with the ability to read from stdin
function e
{
    # If the argument is - then write stdin to a tempfile and open the
    # tempfile.
    if [[ $1 == - ]]; then
        tempfile=$(mktemp emacs-stdin-$USER.XXXXXXX --tmpdir)
        cat - > $tempfile
        _emacsfun -e "(progn (find-file \"$tempfile\")
                             (set-visited-file-name nil)
                             (rename-buffer \"*stdin*\" t))
                 " 2>&1 > /dev/null
    else
        _emacsfun "$@"
    fi
}
{% endhighlight %}


If you prefer to use a standalone emacs just replace `emacsclient -c -n` in `_emacsfun` with `emacs`.

The function is called as

{% highlight bash %}
echo "hello world" | e -
{% endhighlight %}

or

{% highlight bash %}
e hello_world.txt
{% endhighlight %}

One more note: each time you read from stdin a temporary file in `/tmp` is created, these are typically cleared on reboot which is good enough for me. If you need them to be gone immediately you could add `rm $tempfile` inside the `if` statement.


As always the code is [on github](https://github.com/davidshepherd7/emacs-read-stdin).
