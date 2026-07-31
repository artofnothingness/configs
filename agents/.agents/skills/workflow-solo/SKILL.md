---
name: workflow-solo
description: Solo pipeline from idea to done — the main agent does every step itself (only explore subagent allowed)
---

# Workflow Solo

```
grilling → to-spec → to-tickets → [implement+commit → self-review] ↻ → final review → done
```

Каждый шаг выполняет сам основной агент. Единственный разрешённый субагент — `explore` (для разведки кодовой базы); остальные (`general` и др.) запрещены.

**Grilling всегда делает основной агент** — грилл не делегируется субагентам.

## Bug Reports

Если пользователь сообщает о баге (вне основного пайплайна):

1. Загрузи навыки `tdd` и `shared-context` — найди причину бага, напиши failing test, исправь, закоммить.
2. Загрузи навык `review` — проверь фикс.

**Найден баг?** → та же логика 4c: проверка user story → fix → re-review. Те же лимиты итераций.

**Перед началом работы** проверь, есть ли уже `spec.md` и `shared-context.md` в `.scratch/<feature>/`. Если есть — пропускай grilling и to-spec.

**Статусы тикетов:** обновляй по мере работы (`ready` → `in_progress` → `done`).

## Pipeline

### 1. grilling
Загрузи навык `grilling` и проведи интервью сам, один вопрос за раз. Цель — shared understanding, закрыть все решения. Если решения уже приняты — пропускай, иди в to-spec.

Итоговые решения на шаге `to-spec` попадут в `spec.md` (секция **Implementation Decisions**).

### 2. to-spec
Загрузи навык `to-spec`. Результат: `spec.md`, `shared-context.md` в `.scratch/<feature>/`.

### 3. to-tickets
Загрузи навык `to-tickets`. Результат: тикеты в `.scratch/<feature>/tickets/`.

### 4. Implement → Self-Review Loop

Начинай с frontier тикета (все блокирующие уже done).

#### 4a. Implement
Загрузи навыки `tdd` и `shared-context`. Пиши failing test первым, затем минимальный код. Закоммить сам — отдельный «шаг коммита» не нужен.

#### 4b. Self-review
Загрузи навык `review` и проверь свою работу сам: код, acceptance criteria тикета, user stories из spec.

#### 4c. Bug Found?

**Найден баг:**

1. Есть ли в spec user story, покрывающая этот баг?
   - **Есть** → повторить 4a → снова self-review (4b)
   - **Нет** → загрузи навык `to-spec` и допиши user story в spec → повторить 4a → снова self-review (4b)

2. Итерации: максимум **5 циклов** `self-review` (4b) → fix (4a) → `self-review` на один тикет.
   После 5 итераций баги остаются → **стоп, escalate** пользователю.

**Self-review чист:** тикет done. Следующий frontier тикет.

### 5. Final Review
Все тикеты done → загрузи навык `review` на всю фичу:
- Все user stories покрыты и работают
- Интеграция между тикетами не сломана
- Ни один тест не падает

**Найден баг?** → та же логика 4c: проверка story → fix → re-review (финальный).
Максимум **3 финальных `review`**. Превысили → escalate.

**Финальный review чист:** фича done.
