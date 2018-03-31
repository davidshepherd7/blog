---
layout: default
title: "Tracing macros in Emacs"
categories: emacs common-lisp debugging
---

I've been playing around in common lisp lately, and one feature I particularly
like is the trace macro. `trace` is a macro which lets you easily log the
arguments and result of all calls to a function. It's particularly handy for
visualising recursive function calls.

As you might expect Emacs has an equivalent macro. It's called `trace-function`
and is used like this:

```
(defun fact (n)
  (if (= n 0) 1
    (* n (fact (1- n)))))

(trace-function #'fact)

(fact 3)
```

which pops up a `*trace-output*` buffer containing

```
======================================================================
1 -> (fact 3)
| 2 -> (fact 2)
| | 3 -> (fact 1)
| | | 4 -> (fact 0)
| | | 4 <- fact: 1
| | 3 <- fact: 1
| 2 <- fact: 2
1 <- fact: 6
```

This is great if you're working interactively, but I want to use it for
debugging unit tests too. I run typically tests in batch mode using
[ert-runner](https://github.com/rejeep/ert-runner.el), so the challenge is to
get the trace macro to print to stdout instead of writing to a buffer.

Unfortunately Emacs doesn't have a simple way of redirecting a buffer to stdout.
My somewhat hacky solution is to add the following code to my ert-runner
`test-helper.el` file:

```
(defun log-trace-buffer (&rest _)
  (when (get-buffer trace-buffer)
    (with-current-buffer trace-buffer
      (message (buffer-substring-no-properties (point-min) (point-max))))))
(add-to-list 'ert-runner-reporter-run-ended-functions #'log-trace-buffer)
```

which just dumps the entire contents of the trace output buffer to stdout when
the tests finish. It's not perfect but it's enough for me to fix my tests!
