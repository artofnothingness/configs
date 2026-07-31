---
name: shared-context
description: Shared knowledge file — structure, rules for the main agent, and guidance for agents. Every agent reads it before work; the main agent maintains it.
---

# Shared Context

Файл `.scratch/<feature>/shared-context.md` — единый источник знаний о проекте для всех агентов. Формируется один раз на этапе `to-spec` и дополняется по мере обнаружения нового.

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

## Rules for the main agent

- После `to-spec` — убедись, что `shared-context.md` создан
- При dispatch субагента — укажи только **путь** к `shared-context.md` (`.scratch/<feature>/shared-context.md`). Содержимое файла НЕ передавать — субагент прочитает его сам
- Читай файл напрямую перед каждым этапом
- Агент сообщил об обновлении `shared-context.md` — не дублируй изменения в промптах, файл уже на диске

## Rules for subagents

- **Перед началом работы** — прочитай `shared-context.md` с диска. Используй описанные conventions, переиспользуй существующие типы/утилиты, следуй build/test командам
- **Обнаружил новое** (утилита, convention, gotcha, не отражённые в файле) — дополни `shared-context.md` сам и упомяни в отчёте одним предложением
- **Не дублируй** — если утилита или тип уже описаны в shared context, используй их вместо создания новых
- **Отчёт** — кратко: статус, изменённые файлы, дополнения к shared-context. Содержимое файлов в отчёт не копировать
