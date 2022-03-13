
A colleague recently asked me why I prefer to avoid object-oriented-programming where possible, and what "where possible" means.

These are opinions I've had for a long time.

They seem to be widely shared: both of the 2 commercial codebases I've worked on
used this object-oriented-only-if-you-must style.

(and of the two research codebases, one was heavily object-oriented for the good
reason that used a *lot* of polymorphism. The other was heavily object-oriented
for the bad reason that it was written in Java and that's what you do in Java.
It was easily the worst codebase I've interacted with, at least partly because
of the unecessary use of objects.)

Rust and modern C++ seem to have settled on these same ideas, see e.g.
https://stevedonovan.github.io/rust-gentle-intro/object-orientation.html

# What exactly is OOP anyway?

In some sense OOP is when you have classes and member functions, but this
definition seems overly broad: almost all languages support something like this
these days.

I think that a better understanding of OOP as a programming style is that it
uses classes to get a few important features.

## Encapsulation

Encapsulation is the most commonly stated goal of OOP. The idea is that you can
hide away your state inside an object and only allow access to it in controlled
ways. This is useful in a few ways.

### Hiding how some data is stored/computed

Often we want to be able to change the details of how one thing is implemented
without needing to make changes to other parts of our code. Encapsulation allows
us to do this.

For example: think of a list for which we want to be able to get the length.
Without encapsulation we could either store the length openly or we could have a
function which computes the length. But we couldn't switch between the two
without breaking existing programs.

With encapsulation we can expose a getter function for the length of the list,
and internally we can implement this however we like without affecting callers.

### Maintaining invariants

Let's look at the list example again. If we stored the length of the list as a
publicly available property (e.g. in a C struct or similar) then any part of our
program could accidentally *modify* the length! This could be catastrophic, e.g.
if we rely on the length being correct to avoid segfaults.

Encapsulation can prevent this kind of problem as well by restricting access to
the few carefully-written functions within the class.

Encapsulation for maintaining invariants works best when objects are very small.
Often just a single piece of data and the functions needed to safely modify it.
The more functions that the class has, the code has the ability to accidentally
modify the code incorrectly.

### Encapsulation without objects

Interestingly you can implement almost the exact same thing without classes in
most languages using closures (i.e. functions which have access to the variables
which were in scope when they were created). Here's a canonical Javascript
example:

```
function Person(name, age) {
  // The code here has access to the name and age variables
  return {
    firstName: function() { return name.split(" ")[0] },
    surname: function() { return name.split(" ")[1] },
    age: function() { return age },
    setOneYearOlder: function() { 
        // We can even mutate the local variables
        age = age + 1 
    },
  }
}

alice = Person("Alice A", 23)
bob = Person("Bob B", 18)

alice.firstName() // Returns 'Alice'
alice.age() // Returns 23
alice.setOneYearOlder()
alice.age() // Returns 24

alice.age = 45 // Javascript doesn't have types so this is allowed
alice.age() // But now this crashes
```

"Structure and Interpretation of Computer Programs" has a nice description of
how to implement this sort of thing in lisp:
https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-20.html#%_idx_2850


## Polymorphism and interfaces

Another common use of OOP is to enable code which works with a bunch of slightly
different things in the same way.

The slightly different things are objects implementing the same interface.

The non-polymorphic way of doing this is something like:

```
x = mystery_object()
if isinstance(x, Foo):
    fooPrint(x) 
elif isinstance(x, Bar):
    barPrint(x)
elif isinstance(x, Baz):
    bazPrint(x)
```

and using polymorphism:

```
class Foo(Printable):
    def print():
        ...

class Bar(Printable):
    def print():
        ...

class Baz(Printable):
    def print():
        ...
        
x = mystery_object()
print(x) 
```

The big advantage of polymorphism is that you don't need to modify all of your
functions that use Printable types every time you add a new type. This is
obviously good in one way: it makes it less work to add new types. It is also
good in another (perhaps more important) way: it means that code can
automatically handle any type with the same interface, even if it is written
years later by people on the other side of the planet.

The polymorphic version is also sometimes more type-safe: most languages have a
way to detect missing `print` implementation on a `Printable` type at compile
time, but not all of them can detect if you forget to add an `elif` branch when
you add a new type.

I used to think that algebraic data types (i.e. tagged union types) were a
replacement for this, but now I understand that implementing an interface is
more flexible b/c it allows you to reuse your existing code for new
implementations *without changes* to the existing code (e.g. even to add a new
type). This is important for mocking! You don't want to have the types for mock
objects in your real code.

It's possible for a language to have support for polymorphism and interfaces
without supporting the rest of OOP. For example [Rust's trait
system](https://stevedonovan.github.io/rust-gentle-intro/object-orientation.html)
which allows you to define an "interface" and implement it for anything, not
just objects/classes.


But, sometimes people assume that this will work better than it actually does.
e.g. assuming that you can drop in a new database by implement a new interface
is probably not going to go well, database is much too tightly coupled to your
code in other implicit ways (e.g transactions, constraints)

## Inheritance for code sharing

The third key part of OOP (to me) is inheritance. This is similar to interfaces
except that there is a default implementation for the derived functions.

This is widely agreed to be bad idea.

One of the main reasons we want objects is so that we can restrict state access
to a few special functions. Inheritance shares the ability to access this state
with anything which derives from your class! (in some languages you can negate
this with `private`, but if you aren't accessing private members you might as
well just wrap the object??)

It also tightly couples the two objects:

IT allows access to data in ways which are not explicitly defined. If you call a
free function you can clearly see the input arguments and the outputs (or for a
member function of a class with no inheritence you can see the member
variables). In comparison calling an inherited member function could
access/modify data from classes any distance up the inheritance hierarchy.

It encourages you to call back and forth up/down the inheritance hierarchy. If
this happens then to fully understand (or to change) any one class in a
hierarchy you may need to understand all of the classes which inherit from it,
otherwise you might break them.
  


## object.foo() syntax

This is probably less important than the previous three, and less often
discussed, but the syntax `person.age()` has some advantages over `age(person)`.

Firsly you can write `person.` and use autocomplete to get the full list of
things that can be done to with that kind of object.

Secondly, imagine you have a person type and an animal type, and each of them
have an `age` function with a different implementation. Now `alice.age()` and
`kitty.age()` automatically pick the correct function for the type, but in some
weakly typed languages if you have imported `age` for animals then `age(alice)`
would incorrectly call the animal code! The solution to this is normally more
verbose namespacing, e.g. `animalAge(kitty)` and `personAge(alice)`, so here the
object oriented version is less verbose.

Continuing the trend from previous sections: in some languages you can get this
feature without actually needing to write methods on the object, see e.g.
[Kotlin extension
functions](<https://kotlinlang.org/docs/extensions.html#note-on-visibility>) and
[Uniform function call
syntax](https://en.wikipedia.org/wiki/Uniform_Function_Call_Syntax). This is
nicer if you are using objects for encapsulation because it reduces the number
of functions which have access to internal state.


## Dependency injection?


# What are the problems with it

## Shared state

Implicit mutable input shared state (the this object) make it harder to track
what affects what.

These become much bigger problems when combined with inheritance for code
sharing (code from other files can access/modify your "encapsulated" state) and
[large objects](https://sourcemaking.com/antipatterns/the-blob) (code from other
unrelated features can access/modify your state).


 the proposed solution is to keep classes very small. This pretty much never happens in reality (or when it does, you end with a large morass of classes). Also the limit of small classes is just 

Overly large classes seem to become the norm in long-lived OOP codebases,
probably because it's so much easier to add a function to an existing class than
to carefully redesign the class structure so that your change fits in cleanly.
In procedural codebases it doesn't matter as much if you add one more function
to a module because there (typically) isn't any module level state sharing.

Antoher proposed solution: use classes with no state only function. But then you
might as well just have namespaces/modules/etc. Except that in many languages
you have to opt in to all of OO to get interface.


## "Everything must be a class"

Some languages and frameworks encourage or require you to make everything a
class. But many things just don't have any data associated with them! We
shouldn't make these things classes - simpler is better.

One particular argument against this is dependency injection...


# Summary

Encapsulation is importand and you should use it whenever needed, Polymorphism
is a good tool to have available. Often these are implemented using
object-oriented techniques but not always.

Inheritance for code sharing is usually a mistake.

Classes should be as small as possible to improve encapsulation. The smallest
possible "class" is a pure, free function (i.e. a function not associated with
any class and which doesn't mutate any state), so most of the time you should
use functions!

