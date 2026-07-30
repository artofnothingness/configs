---
name: workflow
description: Pipeline from idea to done — grilling → spec → tickets → implement → review loop → final review
---

# Workflow

```
grilling → to-spec → to-tickets → [implement → commit → review] ↻ → final review → done
```

## Bug Reports

Если пользователь сообщает о баге (вне основного пайплайна):

1. Диспатчить `@general` c навыками `tdd` и `shared-context` — найти причину бага, написать failing test, исправить.
2. Диспатчить `@general` для коммита.
3. Диспатчить `@general` c навыком `review`.

**Найден баг?** → та же логика 4c: проверка user story → fix → re-review. Те же лимиты итераций.

## Shared Context

Файл `.scratch/<feature>/shared-context.md`. См. навык `shared-context` за полными правилами.
- После `to-spec` — убедись, что создан.
- Агент дополнил — оркестратор должен передать обновлённый файл при следующих диспатчах.

## Pipeline

### 1. grilling
Идея ещё сырая, есть открытые вопросы? Загрузи навык `grilling` и проведи интервью сам. Цель — достичь shared understanding, закрыть все решения. Если решения уже приняты — пропускай, иди в to-spec.

### 2. to-spec
Диспатчить `@general` c навыком `to-spec`. Результат: `spec.md`, `shared-context.md`.

### 3. to-tickets
Диспатчить `@general` c навыком `to-tickets`. Результат: тикеты в `.scratch/<feature>/tickets/`.

### 4. Implement → Review Loop

Начинай с frontier тикета (все блокирующие уже done).

#### 4a. Implement
Диспатчить `@general` c навыками `tdd` и `shared-context`. Диспатчить `@general` для коммита.

#### 4b. Review
Диспатчить `@general` c навыком `review`.

#### 4c. Bug Found?

**Найден баг:**

1. Есть ли в spec user story, покрывающая этот баг?
   - **Есть** → повторить 4a → снова review (4b)
   - **Нет** → диспатчить `@general` c навыком `to-spec` дописать user story и обновить spec → повторить 4a → снова review (4b)

2. Итерации: максимум **5 циклов** `review` (4b) → fix (4a) → `review` на один тикет.
   После 5 итераций баги остаются → **стоп, escalate** пользователю.

**Review чист:** тикет done. Следующий frontier тикет.

### 5. Final Review
Все тикеты done → диспатчить `@general` c навыком `review` на всю фичу:
- Все user stories покрыты и работают
- Интеграция между тикетами не сломана
- Ни один тест не падает

**Найден баг?** → та же логика 4c: проверка story → fix → re-review (финальный).
Максимум **3 финальных `review`**. Превысили → escalate.

**Финальный review чист:** фича done.
