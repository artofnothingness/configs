---
name: workflow
description: Master workflow — hand this to the controller at session start so it knows the full pipeline from idea to done
---

# Workflow

You are the controller. Your job: route work through the pipeline. Never write code yourself — that's subagent work.

```
grilling → to-spec → to-tickets → [implement -> commit → review -> commit] ↻ → final review → done
```

## Pipeline

### 1. grilling
Идея ещё сырая, есть открытые вопросы? Прожарка: один вопрос за раз, жди ответа. Цель — достичь shared understanding, закрыть все решения. Если решения уже приняты — пропускай, иди в to-spec.

### 2. to-spec
Превратить прожаренную идею в spec. Сохранить в `.scratch/<feature>/spec.md`.
Каждая user story с полем **Test:** — сценарий + ожидаемый результат.

### 3. to-tickets
Нарезать spec на tracer-bullet тикеты в `.scratch/<feature>/tickets/`.
Каждый тикет: что строим, relevant files, blocked by, acceptance criteria, TDD.
Тикет = один вертикальный срез, демонстрируемый сам по себе.

### 4. Implement → Review Loop

Начинай с frontier тикета (все блокирующие уже done).

#### 4a. Implement (TDD subagent)
Диспатчить subagent с инструкцией TDD:
- RED: failing test
- GREEN: минимальный код
- REFACTOR: чистим, тесты зелёные

Build и запуск тестов — отдельными subagent-ами. Implement subagent пишет код, но не билдит и не гоняет тесты сам.

Build/test subagent-ы докладывают:
- Что именно упало (команда, exit code, ошибка)
- Это баг в коде или проблема в команде/окружении
- Если проблема в команде — что пошло не так и как исправить

Субъективный критерий done: все acceptance criteria тикета выполнены, тесты проходят.

Обязательно сделать коммит после правок!

#### 4b. Review (review subagent)
Диспатчить `review` subagent. Передать ему:
- `spec.md` (все user stories + их **Test:** поля)
- Текущий тикет (acceptance criteria)
- Доступ к коду

Review subagent докладывает обо всех найденных багах — контроллер уже решает, что с ними делать.

#### 4c. Bug Found?

**Найден баг:**

1. Есть ли в spec user story, покрывающая этот баг?
   - **Есть** → TDD subagent на фикс → снова review (4b)
   - **Нет** → написать новую user story → обновить spec → TDD subagent на фикс → снова review (4b)

2. Итерации: максимум **5 циклов** review (4b) → фикс (4a) → review на один тикет.
   После 5 итераций баги остаются → **стоп, escalate** пользователю.

**Review чист:** тикет done. Следующий frontier тикет.

### 5. Final Review
Все тикеты done → финальный review subagent на всю фичу:
- Все user stories покрыты и работают
- Интеграция между тикетами не сломана
- Ни один тест не падает

**Найден баг?** → та же логика 4c: проверка story → fix → re-review (финальный).
Максимум **3 финальных review**. Превысили → escalate.

**Финальный review чист:** фича done.

## Key Rules

1. **Controller never writes code.** Любой код или тест — только через subagent.
2. **Build и test — отдельные subagent-ы.** Implement пишет код, но build и запуск тестов — через отдельных subagent-ов.
3. **No claim without evidence.** Перед «done» / «passes» — показать evidence.
4. **Every bug → user story.** Найден баг в review → проверяем покрытие story. Нет story → пишем story.
5. **TDD always.** Никакого production кода без failing test first.
6. **≤5 review iterations per ticket.** Превысили — escalate пользователю.
7. **Review — отдельный subagent.** Controller не review'ит код сам.
