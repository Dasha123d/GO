# CLI с Cobra и флагами

`spf13/cobra` — основной фреймворк для создания CLI в Go. Позволяет определять команды, подкоманды, флаги, генерировать автодополнение и man-страницы.

## Базовая структура

```go
var rootCmd = &cobra.Command{
    Use:   "myapp",
    Short: "A brief description",
    Run: func(cmd *cobra.Command, args []string) {
        // основная логика
    },
}
func main() {
    if err := rootCmd.Execute(); err != nil {
        os.Exit(1)
    }
}
```

## Флаги
Локальные и постоянные флаги:
```go
var port int
rootCmd.Flags().IntVarP(&port, "port", "p", 8080, "server port")
```
Можно связать флаги с Viper:
```go
viper.BindPFlag("port", rootCmd.Flags().Lookup("port"))
```

## Команды и подкоманды
```go
var serveCmd = &cobra.Command{
    Use:   "serve",
    Short: "Start server",
    Run:   func(cmd *cobra.Command, args []string) { ... },
}
rootCmd.AddCommand(serveCmd)
```

## Автодополнение и генерация
```go
rootCmd.AddCommand(cobra.Command{Use: "completion"})
```
Пример использования — `examples/cobra-cli.go`.

## Альтернативы
* Стандартный `flag` — для простых CLI.
* `urfave/cli` — другой стиль, более декларативный.

Cobra интегрируется с Viper, поэтому они образуют мощную связку.