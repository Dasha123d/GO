//go:build ignore

package main

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type Login struct {
	User     string `json:"user" binding:"required"`
	Password string `json:"password" binding:"required"`
}

func main() {
	r := gin.Default()
	r.POST("/loginJSON", func(c *gin.Context) {
		var json Login
		if err := c.ShouldBindJSON(&json); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, gin.H{"status": "ok", "user": json.User})
	})
	r.Run(":8080")
}
