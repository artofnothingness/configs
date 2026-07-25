# Restructuring for composability

How to restructure coupled code safely. Uses the principles in [SKILL.md](SKILL.md).

## Dependency categories

When assessing a candidate for restructuring, classify its dependencies. The category determines how the module is tested.

### 1. In-process

Pure computation, in-memory state, no I/O. No abstraction needed — just a function or class with clear inputs and outputs. Test through the public interface directly.

### 2. Local-substitutable

Dependencies that have local test stand-ins (SQLite for Postgres, in-memory filesystem). Inject the dependency; test with the stand-in.

### 3. Remote but owned

Your own services across a network boundary (microservices, internal APIs). Inject the transport as an implementation behind an interface. Tests use an in-memory implementation. Production uses the real one.

### 4. True external (Mock)

Third-party services you don't control. Test with a mock implementation behind an interface.

## When to introduce an interface

- Don't introduce an abstraction unless at least two implementations are justified (typically production + test). A single-implementation interface is just indirection.
- A module can have internal structures (private to its implementation, used by its own tests) as well as the external interface. Don't expose internal details through the public interface just because tests use them.

## Testing strategy: test the interface, not the internals

- Old unit tests become waste once tests at the restructured module's interface exist — delete them.
- Write new tests at the module's interface. The **interface is the test surface**.
- Tests assert on observable outcomes through the interface, not internal state.
- Tests should survive internal refactors — they describe behaviour, not implementation. If a test has to change when the implementation changes, it's testing past the interface.
