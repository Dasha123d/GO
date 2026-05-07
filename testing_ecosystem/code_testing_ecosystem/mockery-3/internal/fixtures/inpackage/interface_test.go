package inpackage

import (
	"os"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestInPackageOverride(t *testing.T) {
	mockFile := "./subpkg/mocks_testify_inpackage_test.go"
	contents, err := os.ReadFile(mockFile)
	require.NoError(t, err)

	// The `inpackage` parameter overrides the auto-detection logic
	// for whether or not a mock is in the original package. Thus, the types
	// from the original package should be unqualified. Technically, the
	// generated mock file in this case will be invalid code because
	// it uses the unqualified InternalStringType from outside of the `inpackage` package.
	// We're just testing that the override logic is working correctly.
	assert.True(t, strings.Contains(string(contents), "Bar() InternalStringType"))
}
