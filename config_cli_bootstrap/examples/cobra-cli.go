// cobra-cli.go – пример CLI на Cobra
package main

import (
	"fmt"
	"os"

	"github.com/spf13/cobra"
)

var (
	port   int
	config string
)

var rootCmd = &cobra.Command{
	Use:   "myapp",
	Short: "Демонстрационное приложение на Cobra",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Printf("Запуск с портом %d и конфигом %s\n", port, config)
	},
}

func init() {
	rootCmd.Flags().IntVarP(&port, "port", "p", 8080, "порт сервера")
	rootCmd.Flags().StringVarP(&config, "config", "c", "config.yaml", "путь к файлу конфигурации")
}

func main() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(1)
	}
}