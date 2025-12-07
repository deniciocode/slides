---
class: lead
marp: true
paginate: true
theme: default
---

# Why `Array()` Works at the Top Level in Ruby

------------------------------------------------------------------------

## Kernel → Object

-   Ruby mixes the **Kernel** module into **Object**:

``` ruby
class Object
  include Kernel
end
```

-   Kernel defines global-ish methods:
    -   `puts`, `p`, `Array()`, `String()`, `Integer()`, ...
-   Since **every Ruby object inherits from `Object`**, all Kernel
    methods are available everywhere.

------------------------------------------------------------------------

## The Top-Level Context

### What is `self` at the top level?

``` ruby
self        # => main
self.class  # => Object
```

-   Ruby executes top-level code inside a special object called
    **`main`**.
-   `main` is an **instance of Object**, so it has all Kernel methods.

------------------------------------------------------------------------

## IRB Uses the Same Rules

``` ruby
irb> self
# => main

irb> self.private_methods.include?(:Array)
# => true
```

-   IRB evaluates everything in the context of the same top-level
    object.
-   Therefore `Array()` is available as a private Kernel method.

------------------------------------------------------------------------

## Important Detail: `Array()` Is a Method

`Array(…)` is **not** a constructor call.

It is **Kernel#Array**, a coercion method:

1.  Calls `obj.to_ary` if defined\
2.  Falls back to `obj.to_a`

Example:

``` ruby
class Foo
  def to_a
    [1, 2, 3]
  end
end

Array(Foo.new)
# => [1, 2, 3]
```

------------------------------------------------------------------------

## Summary

-   Kernel is mixed into Object → all objects get Kernel methods.
-   The top-level context (`main`) is an Object instance.
-   IRB uses the same top-level object.
-   `Array()` isn't a constructor --- it's a Kernel coercion helper.

------------------------------------------------------------------------

## End
