package replace_type

import (
	"os"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestReplaceType(t *testing.T) {
	mockFile := "./mocks_testify_replace_type_test.go"
	b, err := os.ReadFile(mockFile)
	require.NoError(t, err)
	// .mockery.yml replaced github.com/vektra/mockery/v3/internal/fixtures/example_project/replace_type/rti/rt1
	// with github.com/vektra/mockery/v3/internal/fixtures/example_project/replace_type/rti/rt2
	assert.True(t, strings.Contains(string(b), "*RTypeReplaced1) Replace1(f rt2.RType2) {"))
	// This should contain no replaced type.
	assert.True(t, strings.Contains(string(b), "*MockRType) Replace1(f rt1.RType1) {"))
}
