---
marp: true
theme: default
paginate: true
---

# Effective Ruby

### Ruby User Group Berlin

#### Dezember 2025

Talk by `Dennis Hägler`

---

# Content of the book

- Basics
- Classes, Objects and Modules
- Collections
- Exceptions
- Metaprogramming
- Testing
- Tools and Libraries
- Memory Management and Performance

---

# Content of the talk

- Basics
- Classes, Objects and Modules
- Collections
- Exceptions
- ~~Metaprogramming~~
- ~~Testing~~
- Tools and Libraries - skipping Bundler and Gem Dependencies
- ~~Memory Management and Performance~~

---

# Basics

## What is True in Ruby?

- everything besides `false` and `nil`

---

# Basics

## Consider what is True in Ruby?

```ruby
true == 1 # => false
1 == true # => false
```

---

# Basics

## Consider what is True in Ruby?

```ruby
if 0
  puts("I am true")
end
```

---

# Basics

## Treat All Objects as If they Could be `nil`

- any object can be `nil`
- use `nil?`
- use conversion methods (`to_s`, `to_i`)
- use `Array#compact`

---

# Basics

## Treat All Objects as If they Could be `nil`

- any object can be `nil`

```ruby
person.save if person
person.save unless person.nil?
```

---

# Basics

## Treat All Objects as If they Could be `nil`

- any object can be `nil`

```ruby
person.save if person
person.save unless person.nil?
```

```ruby
person&.save # since 2.3.0
```

---

# Basics

## Treat All Objects as If they Could be `nil`

- use `nil?`
  - `nil.nil? # => true`
- use conversion methods (`to_s`, `to_i`)
  - `nil.to_s # => ""`
  - `nil.to_i # => 0`
  - `nil.to_f #=> 0.0`
- use `Array#compact`
  - `[9, 0, nil].compact # => [9, 0]`

---

# Basics

## Avoid cryptic Perlisms

---

# Basics

## Avoid cryptic Perlisms

- Ruby uses special global vars `$`

---

# Basics

## Avoid cryptic Perlisms

- `$~ ($LAST_MATCH_INFO)`The information about the last match in the current scope (thread-local and frame-local).
- `$& ($MATCH)` The string matched by the last successful match.
- `$' ($POSTMATCH)` The string to the right of the last successful match.
- `$+ ($LAST_PAREN_MATCH)` The highest group matched by the last successful match.

---

# Basics

## Avoid cryptic Perlisms

```ruby
"Hello World!" =~ /e(llo) (\w+)rl/

puts $~ # => #<MatchData "ello Worl" 1:"llo" 2:"Wo"> (the match and each group)
puts $& # => "ello Worl" (the match)
puts $` # => "H" (the string to the left of the match)
puts $' # => "d!" (the string to the right of the match)
puts $+ # => "Wo" (the last group)
puts $1 # => "llo"
puts $2 # => "Wo
puts $3 # => nil
```

---

# Basics

## Avoid cryptic Perlisms

- use `String#match`

```ruby
m = 'Hello World!'.match(/e(llo) (\w+)rl/)
puts m[1] # => llo
```

---

# Basics

## Constants Are Mutable

---

# Basics

## Constants Are Mutable

- Constants are actually identifiers
- class names are identifiers and so constants

---

# Basics

## Constants Are Mutable

```ruby
class Testing
  CONSTANT = ['123', 'abc']
end

puts Testing::CONSTANT # => ['123', 'abc']

Testing::CONSTANT.delete_if {|test| test.to_i.zero?}

puts Testing::CONSTANT# => ['123']
```

---

# Basics

## Constants Are Mutable

```ruby
class Testing
  CONSTANT = ['123', 'abc'].freese
end

Testing::CONSTANT.delete_if {|test| test.to_i.zero?}
```

`'Array#delete_if': can't modify frozen Array: ["123", "abc"] (FrozenError)`

---

# Basics

## Constants Are Mutable

```ruby
class Testing
  CONSTANT = %w[123 abc].freeze
end


Testing::CONSTANT = 'ja moin'
puts Testing::CONSTANT # => 'ja moin'
```

---

# Basics

## Constants Are Mutable

```ruby
class Testing
  CONSTANT = %w[123 abc].freeze
end

Testing.freeze

Testing::CONSTANT = 'ja moin'
```

`can't modify frozen #<Class:Testing>: Testing (FrozenError)`

---

# Basics

## Pay Attention to Run-Time Warning

```ruby
class Testing
  CONSTANT = %w[123 abc].freeze
end

Testing::CONSTANT = 'ja moin'
```

---

# Basics

## Pay Attention to Run-Time Warning

```ruby
class Testing
  CONSTANT = %w[123 abc].freeze
end

Testing::CONSTANT = 'ja moin'
```

`testing.rb:5: warning: already initialized constant Testing::CONSTANT`
`testing.rb:2: warning: previous definition of CONSTANT was here`

---

# Classes, Objects and Modules

---

# Classes, Objects and Modules

- everything in ruby is an object
- classes are also objects
- subclasses not intializing their subclasses automatically

---

# Classes, Objects and Modules

## Know how Ruby Builds Inheritance Hierachies

- ruby interpreter internally builds the instance hierachy
  - consistent and straightforward

---

# Classes, Objects and Modules

## Know how Ruby Builds Inheritance Hierachies

- object is a Container of Variables
  - Referred as instance variables
  - Represent a state of an object
- has a special internal variable that connects to the one class
  - to say instance of this class

---

# Classes, Objects and Modules

## Know how Ruby Builds Inheritance Hierachies

- a class is a container of methods and constants
  - referred as instance methods
  - represent the behavior of the object

---

# Classes, Objects and Modules

## Know how Ruby Builds Inheritance Hierachies

- classes are also objects with variables and methods
  - class method
  - class variable
- a class is an object(instance) of the class `Class`

```ruby
class MyClass
end

MyClass.class # => Class
```

---

# Classes, Objects and Modules

## Know how Ruby Builds Inheritance Hierachies

- Modules identical to classes
  - classes are instances of `Class`
  - modules are instances of `Module`
- same data structure as class
- limited in usage through class methods (no `new`)
- can be mixed into classes with `include`
