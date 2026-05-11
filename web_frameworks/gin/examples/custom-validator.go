//go:build ignore

package main

import (
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
)

type Login struct {
	User     string `json:"user" binding:"required,startwithuser"`
	Password string `json:"password" binding:"required,min=6"`
}

func main() {
	r := gin.Default()
	if v, ok := binding.Validator.Engine().(*validator.Validate); ok {
		v.RegisterValidation("startwithuser", func(fl validator.FieldLevel) bool {
			return strings.HasPrefix(fl.Field().String(), "user")
		})
	}
	r.POST("/login", func(c *gin.Context) {
		var login Login
		if err := c.ShouldBind(&login); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})
	r.Run(":8080")
}
