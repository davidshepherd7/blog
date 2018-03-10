---
layout: default
title: "Polish nonsense phrase generator"
categories: polish grammar nlp
custom_excerpt: "A program to generate grammatically correct Polish phrases."
---

## Polish nonesense phrase generator

<div class="jumbotron" style="margin-top: 1em">
<div id="output" class="lead text-center"></div>

<div style="height: 2em">
    <div id="translation" class="text-muted text-center"> </div>
</div>
</div>

<button class="btn btn-primary" style="margin-top: 1em;" type="button" onclick="ctrl.generate()" >
    Generate some nonsense
</button> 
<button class="btn btn-default" style="margin-top: 1em;" type="button" onclick="ctrl.toggleTranslation()" >
    Toggle translation
</button>

<script src="http://cdn.rawgit.com/davidshepherd7/polish-generator/v1/bundle.js"></script>




### What??

This attempts to generate grammatically valid but semantically meaningless
Polish sentences. At the moment it's very simple and can only generate sentences
of the form "Noun Verb" (e.g. the boy runs, the dog eats, etc), with the
occasional adjective thrown in. There are probably mistakes, I'm still learning!


### But why?

I'm learning Polish (slowly) and I recently came across an English sentence
generator in [Paradigms of AI Programming](https://github.com/norvig/paip-lisp/), 
so I thought it might be fun to put the two together.


### Technology

I started out using common lisp (following the examples in PAIP), but then
decided I wanted to show the results in a webpage so I switched to typescript
(because type safety makes life much much easier).

I prototyped the generator as a console application in node, then once I was
happy with the logic I used [browserify](http://browserify.org/) to bundle the
compiled javascript with the dependencies in way that browsers can handle. I'm
really impressed with how easy it was to use compared to gulp or webpack: just
run `browserify index.js -o bundle.js` (where `index.js` is a node application)
and then serve `bundle.js`.

I used a bit of a hack to expose the necessary functions to the html. In
`index.ts` I put:

```
(window as any).ctrl = {
    generate,
    toggleTranslation,
    /* etc */
}
```

which seems to work nicely.

The source code is [on github](https://github.com/davidshepherd7/polish-generator).
