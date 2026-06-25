# Пример: Базовый CRUD

Файл: `examples/basic-crud.md`

Описание структуры проекта и кода для CRUD.

**schema.sql:**
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL
);
```