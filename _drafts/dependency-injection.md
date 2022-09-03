---
layout: post
title: "Dependency injection should be a language feature"
date:   2022-09-03
---

Dependency injection (and the whole ecosystem of patterns that go with it like
service, repository and factory objects) is often necessary for writing simple
tests of code that interacts with external or stateful services. There are
alternative techniques, but they all have their own disadvantages (see
[here](#Bonus content: alternatives to DI)).

Unfortunately dependency injection and service objects can be quite confusing
and requires a lot of boilerplate! I think a lot of the problem is that they
reuse parts of OOP with meanings that are different to the usual meanings. Here
by "usual meanings" I mean the dog-is-an-animal kind of examples that are used
to teach OOP, or e.g. DDD's domain models for a more advanced example.

In particular:

* For DI-able objects the meaning of constructor arguments changes from "data or
  parameters for your class" to "a declaration of which other code your class
  wants to call". Engineers unused to DI mix up these two things which,
  depending on the implementation details, can lead to inscrutable errors
  (Angular I'm looking at you), unexpected behaviour (e.g. changing these
  arguments in one place affects other users of the service ), or just bad code
  (e.g. needing to construct a new instance of a service to call a function with
  different arguments).
  
  
* But also languages already have ways of expressing the notion that your code
  depends on something else: import statements. So DI adds another layer of
  dependency, meaning more boilerplate and more confusion. And to make it worse
  DI frameworks sometimes have a concept call "modules" which is not related to
  the language's concept of modules! 
  
* If you want to use a member function of a DI-able object from somewhere that
  DI isn't available (e.g. free functions, objects that are set up for you by a
  framework) then things get more complicated.

* DI quickly pollutes the entire codebase: if your code, or any code it calls,
  ever needs access to a DI-able object then your code must be DI-able too. This
  forces everything to be an object even when there's really no need, which
  means extra boilerplate. 
  
* There's another footgun waiting here for junior (or just tired) engineers:
  member variables in service objects also change their meaning from "data
  stored by the class" to "dependencies, and maybe some globally-shared data".
  If you forget this then you'll cause weird non-local bugs for other users of
  the code.
 
I think that these problems are independent of whether you write your injection
code manually or use a framework like Dagger to generate it, and also mostly
independent of whether you use constructor or member injection.


But, there's one framework where I've seen most of these issues handled well:
angularjs[3]. To start with here's a quick example of declaring a service
object[2] in angular js:

[^2] Technically in angular terminology this is a factory not a service, and a
service is the same thing except using a `new`'d object, but I'm sticking with
the service terminology for this article.

[^3] I don't want to romanticise angularjs here: the lack of a type system
sucked and viewmodels-plus-html-bindings seems like a clearly inferior way to
build UIs since react came along.

  ```
  angular.module("foo").factory("myService", function(otherService) {
      return {
          myFunction: function(x) {
              return x.cost + otherService(x).cost
          }
          otherFunction: // etc
      }
  })
  ```
  
Let's see how this holds up to the problems listed above.

* It doesn't use actual classes, so there's no existing "meaning" of constructor
  arguments to contend with.
  
* If you follow this pattern then you are literally unable to pass non-DI
  arguments to the outer lambda function because it's not accessible except to
  angular itself.

* This was pre-ES6 so the DI module system was the only module system (in
  old-school javascript the build system would concatenate the entire
  application into a single js file). So no duplication of the notions of
  dependency or modules.

* There are no memeber variables to accidentally use, again because there are no
  classes involved. (Technically you could cause the same state-leaking bug by
  capturing a variable in multiple closures, but you are unlikely to
  accidentally do that because you would have to explicitly declare a variable.)
   
Unfortunately the advent of ES6 (with modules and classes) and the angular
developers deciding to rewrite everything ruined this, Angular 2+'s dependency
injection has all the problems that I've listed above.

This is borne out by my experiences as well: I had no trouble learning to use
angularjs's DI system despite having zero javascript or DI experience and not a
lot of programming experience at all. In contrast when Angular 2 came along I
found myself spending a lot of time reading their DI docs even though by then I
had years of experience with javascript and with using angularjs' DI. The same
thing seemed to hold true for my coworkers: I don't think I ever had to
*explain* angularjs's DI (people just got it), whereas I had to explain Angular
2's DI over and over. Similarly mistakes were almost non-existant with
angularjs's DI but common with Angular's.

So why did this work out so well? Essentially I think it's because in pre-ES6
javascript the features that interact badly with DI were not there (or [were so
weird that they were almost never
used](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Inheritance_and_the_prototype_chain)).
But this seems like a solvable problem: we could have languages where the only
notion of modules and dependency are those used for DI, and DI doesn't force the
use of classes in ways that overlap weirdly with their other uses. This would
get us all the lovely testing benefits of DI without the boilerplate and
confusion that is currently required.


  
### Bonus content: alternatives to DI

Unfortunately the reason people use DI is because there is no silver bullet
replacement for getting stateful object instances (e.g. the database or the
frontend cache) into the rest of the codebase in way which is testable. But
there are some alternatives each with their own downsides:


* Pass the database as an argument to any functions that need it.

  This is kind of like dependency injection but stripped down to the barest
  minimum in a way that resolves the complexity problems.
  
  The downside of this is that it still pollutes the entire codebase: you need
  this additional function argument everywhere, and god help you if you find
  that you need a second kind of database!
  
  I've used this approach in a medium-sized C++ codebase and it was pretty much
  fine.


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
