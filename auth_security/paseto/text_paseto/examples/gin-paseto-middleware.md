# Пример: Paseto middleware для Gin

(Код полностью повторяет раздел `paseto-gin-middleware.md`.)

Проверка:
```bash
curl -X POST http://localhost:8080/login
curl -H "Authorization: Bearer <token>" http://localhost:8080/api/profile
```