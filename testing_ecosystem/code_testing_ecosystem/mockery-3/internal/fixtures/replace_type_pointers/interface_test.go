package replace_type_pointers

import (
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestReplaceTypePointers(t *testing.T) {
	// The config file has been written to replace all instances of the Foo type
	// with Bar. We check whether the function signatures indeed have *Foo
	// replaced with *Bar in both the argument and return value parameters.
	mockFile := "mocks_testify_replace_type_pointers_test.go"
	mockFileBytes, err := os.ReadFile(mockFile)
	require.NoError(t, err)
	assert.Contains(t, string(mockFileBytes), "FooFunc(foo *Bar) *Bar")
}
