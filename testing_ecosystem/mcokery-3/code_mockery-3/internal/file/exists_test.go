package file

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestExistsDot(t *testing.T) {
	exists, err := Exists(".")
	assert.Error(t, err)
	assert.False(t, exists)
}

func TestExistsFile(t *testing.T) {
	exists, err := Exists("exists.go")
	assert.NoError(t, err)
	assert.True(t, exists)
}

func TestExistsJunk(t *testing.T) {
	exists, err := Exists("junk")
	assert.NoError(t, err)
	assert.False(t, exists)
}
