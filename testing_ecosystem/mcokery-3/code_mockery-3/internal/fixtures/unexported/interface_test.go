package unexported

import (
	"os"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestUnexportedConstructorName(t *testing.T) {
	mockFile := "./mocks_testify_unexported_test.go"
	b, err := os.ReadFile(mockFile)
	require.NoError(t, err)
	assert.True(t, strings.Contains(string(b), "func newMockfoo("))
}
