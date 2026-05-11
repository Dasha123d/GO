//go:build ignore

package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type LoginForm struct {
	User     string `form:"user" binding:"required"`
	Password string `form:"password" binding:"required"`
}

func main() {
	r := gin.Default()
	r.POST("/login", func(c *gin.Context) {
		var form LoginForm
		if err := c.ShouldBind(&form); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"user": form.User})
	})
	r.Run(":8080")
}
