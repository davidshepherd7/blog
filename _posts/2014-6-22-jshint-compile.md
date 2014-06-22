---
layout: post
title:  "jshint and emacs' compile command"
date:   2014-06-22
categories: emacs javascript jshint
---

[`jshint`](http://www.jshint.com/about/) is a helpful static code checker for finding potentially problematic code in javascript. This post explains how to run jshint from emacs and easily jump to the errors using emacs' `compile` command. The setup required is not especially complex but could be mildly tricky to figure out for people new to emacs.


The code
======

The additional emacs lisp code needed is simply:

    ;; Add parsing of jshint output in compilation mode
    (add-to-list 'compilation-error-regexp-alist-alist '(jshint "^\\(.*\\): line \\([0-9]+\\), col \\([0-9]+\\), " 1 2 3))
    (add-to-list 'compilation-error-regexp-alist 'jshint)

(Add this code to a config file that is loaded by emacs, typically `.emacs` or `.emacs.d/init.el`.)

To "compile" with `jshint` run the emacs command `compile` in a buffer in your javascript directory with the compilation command:

    jshint *.js
    
(or use an alternative shell glob to select the files you want to check). The compilation buffer should appear and should allow you to step through errors just like using a real compiler.


Explanation
==============

Compilation mode extracts error location information using a simple parser consisting of a regular expression and a few other bits of information. In the commands above we added a parser for the error messages from `jshint`. 

New parsers are defined by a list as specified in the documentation for `compilation-error-regexp-alist`. Our `jshint` parser is as follows:
    
    (jshint "^\\(.*\\): line \\([0-9]+\\), col \\([0-9]+\\), " 1 2 3)
    
The first element is the name of the parser. The second argument is a string containing the regex itself. The final arguments are the numbers of the matches (the first match is numbered 1) which specify the file, the line number and the column number respectively.

In fact emacs stores the parser information in a slightly more complex way. There are two lists: a list of available parsers (`compilation-error-regexp-alist-alist`) and a list of which parsers to use (`compilation-error-regexp-alist`). In the code above the first line defines the parser and adds it to the list of available parsers. The second line adds our new parser to the list of parsers to use.

Related tips/gotchas
=======

* The command to step through errors is `next-error`, you should bind it to a key in both javascript mode and compiliation mode.

* Also bind the commands `compile` and `recompile` to easy to press keys for best effect.

* If you're installing `jshint` on a Debian-based system via `npm` you may need the additional package `nodejs-legacy` to deal with name clashes (there are multiple Debian packages with binaries named `node`. So the node binary installed by the standard nodejs package is called `nodejs` instead. Not many `npm` packages  handle this correctly. The `nodejs-legacy` package adds a binary named `node`.).
