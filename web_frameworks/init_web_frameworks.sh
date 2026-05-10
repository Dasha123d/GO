#!/usr/bin/env bash
set -euo pipefail

ROOT="web_frameworks"
echo "🌐 Инициализация структуры $ROOT/ ..."

# 1. Создаём всю иерархию папок
mkdir -p "$ROOT"/{00_stdlib_net_http/{examples},01_gin/{examples,assets},02_echo/{examples},03_chi/{examples},04_fiber/{examples},05_comparison_benchmarks,99_common_patterns/{examples},_tools}

# 2. Корневые файлы
cat > "$ROOT/README.md" << 'EOF'
# 🌐 Web Frameworks in Go

## 📖 Назначение
Коллекция материалов по веб-фреймворкам Go, подготовленная для автоматического извлечения текста, чанкования и загрузки в векторную БД.

## 🗂️ Структура
| Папка | Содержание |
|-------|------------|
| `00_stdlib_net_http` | База: `net/http`, хендлеры, middleware, таймауты |
| `01_gin` | Gin: маршрутизация, binding, валидация, тесты, production-паттерны |
| `02_echo` | Echo: минимализм, роутинг, data binding, кастомные middleware |
| `03_chi` | Chi: idiomatic router, subrouters, контекст |
| `04_fiber` | Fiber: fasthttp, Express-like API, WebSocket, rate-limit |
| `05_comparison_benchmarks` | Сравнение производительности, гайд по выбору |
| `99_common_patterns` | Архитектура, обработка ошибок, graceful shutdown, логирование |
| `_tools` | Утилиты валидации, чанкования, генерации метаданных |

## ✅ Принципы
- Каждый `.go`-пример сопровождается `.md` с пояснением
- Все файлы содержат ссылки на официальные источники
- `metadata.json` присутствует в каждой папке
- Формат: чистый Markdown + Go (готов к парсингу)
EOF

cat > "$ROOT/metadata.json" << 'EOF'
{
  "collection": "web_frameworks",
  "description": "Материалы по веб-фреймворкам Go: stdlib, Gin, Echo, Chi, Fiber, паттерны",
  "format": "markdown",
  "language": "ru/en",
  "vector_db_ready": true,
  "chunk_strategy": "section-based",
  "max_chunk_tokens": 512,
  "overlap_tokens": 50,
  "last_updated": "2026-05-09",
  "license": "MIT / Apache-2.0 / Go License"
}
EOF

# 3. Функция для быстрой генерации metadata.json
gen_meta() {
  local dir="$1" title="$2" topics="$3" level="$4"
  cat > "$dir/metadata.json" << METAEOF
{
  "title": "$title",
  "source_url": "https://go.dev/",
  "format": "markdown",
  "topics": [$topics],
  "level": "$level",
  "has_code_examples": true,
  "extractable": true,
  "text_layer_verified": true,
  "last_updated": "2026-05-09",
  "chunk_strategy": {"method": "section-based", "max_size": 1024, "overlap": 50}
}
METAEOF
}

# 4. 00_stdlib_net_http
gen_meta "$ROOT/00_stdlib_net_http" "net/http стандартная библиотека" "\"stdlib\",\"http\",\"server\",\"middleware\"" "beginner"
cat > "$ROOT/00_stdlib_net_http/net-http-guide.md" << 'EOF'
# net/http: Базовое руководство

## Источник
- [pkg.go.dev/net/http](https://pkg.go.dev/net/http)
- [Go by Example: HTTP Servers](https://gobyexample.com/http-servers)

## Концепция
`net/http` — ядро веб-разработки в Go. Все фреймворки строятся поверх его интерфейсов:
- `http.Handler` — основной контракт для обработки запросов
- `http.ServeMux` — стандартный мультиплексор маршрутов
- `http.ResponseWriter` + `*http.Request` — сигнатура хендлера

## Минимальный сервер
```go
package main
import "net/http"

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        w.Write([]byte("Hello from stdlib"))
    })
    http.ListenAndServe(":8080", nil)
}