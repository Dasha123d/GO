package file

import (
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestGoMod(t *testing.T) {
	path, content, err := FindInHierarchy(".", []string{"go.mod"})
	require.NoError(t, err)
	assert.NotEmpty(t, path)
	assert.NotEmpty(t, content)
}

func TestNotFound(t *testing.T) {
	_, _, err := FindInHierarchy(".", []string{"no.such.file"})
	require.Error(t, err)
}
