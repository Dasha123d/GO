# Совместимость с encoding/json

## Полная совместимость по API

Sonic реализует тот же API, что и стандартный `encoding/json`:
- `sonic.Marshal` / `sonic.Unmarshal`
- `sonic.MarshalIndent`
- `sonic.NewEncoder` / `sonic.NewDecoder`
- Поддержка тегов `json:"name,omitempty,string"`
- Работа с `interface{}`, `map[string]interface{}`, `json.RawMessage`

**Замена производится простым импортом.**

## Отличия и особенности

1. **Производительность:** В 2–5 раз быстрее стандартного пакета на amd64 с AVX2.
2. **Fallback:** На платформах без AVX2 или не-amd64 автоматически используется pure Go-код (sonic-standalone), который всё равно быстрее `encoding/json`.
3. **AST:** Предоставляет продвинутый ast-пакет, не имеющий аналога в стандартной библиотеке.
4. **Pretouch:** Необходим для разблокировки максимальной скорости, но не требуется для работы.

## Ограничения

- Некоторые краевые случаи `json.Unmarshaler` с нестандартным поведением могут обрабатываться немного иначе (сообщите об issue).
- Не рекомендуется использовать sonic в CGO-окружениях без тщательного тестирования.
- Платформы, где нет поддержки AVX2 (старые x86_64, 32-bit, ARMv7), работают в режиме эмуляции, чуть медленнее, но быстрее стандартного.

## Как перейти с encoding/json

Просто замените `encoding/json` на `github.com/bytedance/sonic` и добавьте в `init()` `Pretouch` для критических структур. Остальной код трогать не нужно.

```go
import "github.com/bytedance/sonic"

var json = sonic.ConfigDefault.Froze() // или свой config
```