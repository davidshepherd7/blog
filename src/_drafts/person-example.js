function Person(name, age) {
  return {
    firstName: function() { return name.split(" ")[0] },
    surname: function() { return name.split(" ")[1] },
    age: function() { return age },
    setOneYearOlder: function() { age = age + 1 },
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
