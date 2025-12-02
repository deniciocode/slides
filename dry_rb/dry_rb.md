---
marp: true
theme: default
paginate: true
---

# Embracing Clarity and Flexibility with `dry-rb`

### Ruby User Group Berlin

#### June 2025

Talk by `Dennis Hägler`

---

# Why `dry-rb`?

- Ruby is expressive and can get messy in large apps
- `dry-rb` promotes:

  - Immutability
  - Explicitness
  - Separation of concerns

- Useful in service-oriented or **domain-driven** design

---

# Overview of Key Gems

- `dry-struct`
- `dry-validation`
- `dry-transaction`

---

# `dry-struct`

### Typed Value Objects

- Replaces ad-hoc data hashes with well-defined objects
- Helps catch bugs early via type safety

---

# `dry-struct`

### Example

```ruby
class User < Dry::Struct
  attribute :name, Types::String.optional
  attribute :age, Types::Coercible::Integer
end

user = User.new(name: nil, age: '21')

user.name # nil
user.age  # 21
```

---

# `dry-struct` Benefits

- Type-safe input handling
- Immutable data
- Value-based equality
- Clear contracts between components

---

# `dry-validation`

### Using `Dry::Validation::Contract`

- Use custom rules and detailed validation logic
- Separation of concerns from models and services

---

# `dry-validation`

### Example

```ruby
class SignupContract < Dry::Validation::Contract
  params do
    required(:email).filled(:string)
    required(:age).filled(:integer, gt?: 18)
  end

  rule(:email) do
    key.failure('must be a company email') unless value.end_with?('@example.com')
  end
end

contract = SignupContract.new
result = contract.call(email: 'user@example.com', age: 20)
```

---

# `dry-validation` Benefits

- Composable validation rules
- Reusable contracts
- Clear error reporting

---

# `dry-validation`

### When to Use in Rails Apps

- Use **ActiveRecord validations** for basic, single-record checks (e.g., presence, format, uniqueness)
- Use **dry-validation** for more complex validations:

  - Validations involving multiple records or external data
  - API input validation

---

# `dry-transaction`

### Business Logic as Steps

- Each step does one thing
- Failure stops the chain

---

# `dry-transaction`

```ruby
class CreateSomething
  include Dry::Transaction

  step :prepare_talk
  step :notify_rug_b

  def prepare_talk(ctx)
    # return Failure(ctx) or Success(ctx)
    Success(ctx.merge(prepared: true))
  end

  def notify_rug_b(ctx)
    # ...
    Success(ctx.merge(notified: true))
  end
end

result = CreateSomething.new.call(title: "Dry.rb Talk")
puts result.success? # true
puts result.value!   # {:title=>"Dry.rb Talk", :prepared=>true, :notified=>true}
```

---

# `dry-transaction` Benefits

- Clean separation of logic steps
- Linear flow of execution
- Better testability and error handling

---

# When to use `dry-transaction`

- Replacing service objects
- Cleaning up model callbacks
- Making business logic explicit

---

# When to Use `dry-rb`

- Complex domain logic
- API input processing
- Service-oriented Rails apps

---

# Final Thoughts

- `dry-rb` helps write maintainable, explicit Ruby code
- Think beyond Rails conventions
- Try it in one isolated feature first

---

# Thank You

- Questions?
- GitHub: `deniciocode`
