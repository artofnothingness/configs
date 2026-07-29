---
name: shared-context
description: Shared knowledge file — structure, rules for orchestrator, and guidance for subagents. Every subagent reads it before work; orchestrator passes it on every dispatch and maintains it.
---

# Shared Context

Файл `.scratch/<feature>/shared-context.md` — единый источник знаний о проекте для всех subagent-ов. Формируется один раз на этапе `to-spec` и дополняется по мере обнаружения нового.

## Template

```
## Project & tech stack
- Language, runtime version, frameworks
- Build system, package manager
- Test runner, linter, type checker

## Codebase map
- Each key module: its responsibility + paths to key files and interfaces

## Build & test commands
- Exact commands for: build, test, lint, typecheck

## Code conventions
- Import patterns, naming, file structure
- Error handling style, logging
- Libraries already in use

## Shared types & utilities
- Existing interfaces, types, helpers that new code should reuse

## Constraints & gotchas
- Environment quirks, version pins, known issues
```

## Rules for orchestrator

- After `to-spec` — убедись, что `shared-context.md` создан
- При dispatch **любого** subagent-а — укажи загрузить `shared-context`
- Subagent сообщил об обновлении `shared-context.md` — оркестратор должен передать обновлённый файл при следующих диспатчах

## Rules for subagents

- **Перед началом работы** — прочитай `shared-context.md`. Используй описанные conventions, переиспользуй существующие типы/утилиты, следуй build/test командам
- **Обнаружил новое** (утилита, convention, gotcha, не отражённые в файле) — дополни `shared-context.md` сам и сообщи оркестратору
- **Не дублируй** — если утилита или тип уже описаны в shared context, используй их вместо создания новых
