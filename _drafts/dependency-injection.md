
First some terminology: I'll use "injectable" to mean an object that takes part
in dependency injection, i.e. it has some dependencies that need to be injected
and/or it can be injected as a dependency of other injectables.

I'm also using DI here as shorthand for the whole ecosystem of Repository
pattern + put-all-of-your-functions-in-service-objects + DI. The alternative to
this is plain old free functions with one of the alternative ways of getting
hold of stateful objects listed below. If you are already using the Java-esque
"all functions live in service objects" style of programming then actual DI is a
no-brainer because otherwise all of your services need to construct each other.
This is the situation that most "advantages of DI" articles are covering.

I'm also sometimes mixing "DI" with "DI using a framework" because most people
seem to end up using a framework eventually. I vaguely think that frameworkless
DI is probably better in cases where your fellow engineers are not expected to
all be DI experts, otherwise a framework is better (but this is weakly held).


# The benefits of DI

The main real benefit of using DI (over e.g. constructing objects inline or
pulling them from a shared context) is that you can *easily* mock out
dependencies where needed to allow you to write unit tests that e.g. don't do
actual HTTP calls to a remote server.

People
[sometimes](https://www.quora.com/What-is-dependency-injection-and-what-are-advantages)
claim another benefit that I have never seen actually matter: you can configure
your production dependencies at runtime/in a config file. In practice I've never
seen a case where you could just swap out e.g. your database for a different one
and not cause subtle bugs all over your codebase. It's possible that this is
useful in domains other than webapps?


# What goes wrong

* DI reuses parts of the language's syntax for objects to represent dependencies
  between stateful things, i.e. it typically takes over ownership of constructor
  arguments, using them to mean declaring a dependency instead of their usual
  meaning as actual arguments.

  So then people get confused about what kinds of arguments go where with
  injectables. I've seen both non-injectables passed into constructors and
  injectables passed as arguments to functions. If you are using a framework the
  first mistake will usually cause some kind of error (often something
  completely inscrutable), the second kind of mistake seems hard to
  automatically detect.
  
* Languages already have ways of expressing the notion that something depends on
  something else: when a (language-level) module depends on another module we
  write an import statement, when functions depend on other functions this is
  handled automatically. This works fine until you have long-lived state, and
  then you need dependencies between object *instances* which is where DI
  usually comes in.
  
  DI frameworks typically add a second kind of module, which is not necessarily
  related to language modules (confusing!), and a whole new syntax for declaring
  dependencies between object instances.

* DI quickly pollutes the entire codebase: at least in the kind of codebases
  I've worked on state management is a major concern, so much of the codebase
  needs access to at least one injectable (e.g. the database). This one issue
  forces most functions to be put into injectables, meaning large amounts of
  additional error-prone boilerplate are needed.
  
  
# Alternatives

Unfortunately the reason people use DI is because there is no silver bullet
replacement for getting a small number of stateful object instances (e.g. the
database or the frontend cache) into the rest of the codebase. But there are
some alternatives with their own downsides:


* Pass the database as an argument to any functions that need it.

  This is kind of like dependency injection but stripped down to the barest
  minimum in a way that resolves the complexity problems.
  
  The downside of this is that it still pollutes the entire codebase: you need
  this additional function argument everywhere, and god help you if you find
  that you need a second kind of database!
  
  I've used this approach in C++ and it was pretty much fine.


* Pass a context object to any functions that need it.

  This is a generalised version of the first option. It solves the problem of
  what to do when you add additional databases (etc), but at the cost of making
  it much harder to track what code actually requires what database.
  
  Also this still pollutes the entire codebase.
  
  This is the default in nodejs and shows up in some places in Android (mostly
  where the Android framework constructs your objects).


* Use a global context object.

  This is goes even further than the second option and makes the context object
  available everywhere.
  
  But, obvious global variables have their own problems: it's even harder to
  track what is interacting with what.
  
  Also, this is hard to make compatible with many concurrency models. For
  example if you have multiple threads then you need a thread-local context
  (which is fine). If you have green threads (i.e. asyncio, nodejs, boost:asio)
  then you need to deal with database requests from different green threads
  being interleaved, making transactions bascially unusable.
  
  This is common in python (e.g. flask), and actually seems to be mostly fine as
  long as your concurrency model is process-based and you don't need a lot of
  control over what can access the database and when. 
  
  Wave uses the approach currently, but we're concerned that in the future it
  might prevent us from sharding our database by business domain because this
  pattern encourages the use of a single transaction even for complex operations
  that span multiple domains. But, more things in a single transaction is a good
  thing unless/until you need to shard your database by domain. So we don't
  regret having done this.
   

### My experiences

I've worked on two large C++ codebases without dependency injection, they were mostly
fine without it although once (in ~4 years) I had to do some unatural things
with templates to be able to test something.

I worked on one large angularjs project which used the builtin dependency
injection. This went well: things were very testable even if they relied on
things like timeouts or the window object because angular automatically mocked
those for you. Most of the pain points didn't happen because this was pre-ES6 so
the DI module system was the only module system (in old-school javascript we
used to concatenate the entire application into a single js file, this was by
default about as bad as you might expect for namespace collision problems etc).

I then workend on a node/Angular2 project where we used the Angular2 DI
framework in node as well. This was terrible and is the source of most of my
concerns about DI. In fairness it was easily testable though.

Next I worked on a large python monolith (Wave) with no DI. This has been by far
the most pleasant-to-work-with system that I've ever worked on, I think largely
because of constant concious attention being paid to this aspect (and e.g.
prioritising this over people indulging their interests in shiny new
technology). But back on topic: there's no DI and there's no need for DI,
pythons builtin mock library is able to mock anything just fine.

Finally, recently I've been looking at Wave's Android (Kotlin) codebase. This in
theory uses manual (i.e. frameworkless) DI. Unfortunately DI in Android is
complicated becuase the frame constructs so many of your objects (preventing
constructor injection). So in practice we've ended up with an ad-hoc
unprincipled mixture of manual DI, using the app object as a service locator,
and just constructing objects inline. This has the expected negative
consequences for testing and is something that we'll be working on fixing soon.

