package output_dir_test

import (
	"os"
	"strings"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestOutputSourceImport(t *testing.T) {
	const expectedImport = "github.com/vektra/mockery/v3/internal/fixtures/output_dir"

	tests := []struct {
		name     string
		filepath string
		expected bool
	}{
		{
			name:     "Different package name -outside source package",
			filepath: "./mock/mocks_matryer_output_dir_test.go",
			expected: true,
		},
		{
			name:     "Same package name -outside source package",
			filepath: "./output_dir/mocks_matryer_output_dir_test.go",
			expected: true,
		},
		{
			name:     "Same package name -within source package",
			filepath: "./mocks_matryer_output_dir_test.go",
			expected: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			b, err := os.ReadFile(tt.filepath)
			require.NoError(t, err)
			assert.Equal(t, tt.expected, strings.Contains(string(b), expectedImport))
		})
	}
}

func TestOutputEnsureCheck(t *testing.T) {
	tests := []struct {
		name     string
		filepath string
		expected string
	}{
		{
			name:     "Different package name -outside source package",
			filepath: "./mock/mocks_matryer_output_dir_test.go",
			expected: "var _ output_dir.OutputDirWithDifferentPkgName = &MoqOutputDirWithDifferentPkgName{}",
		},
		{
			name:     "Same package name -outside source package",
			filepath: "./output_dir/mocks_matryer_output_dir_test.go",
			expected: "var _ output_dir.OutputDirWithSamePkgNameAsSrc = &MoqOutputDirWithSamePkgNameAsSrc{}",
		},
		{
			name:     "Same package name -within source package",
			filepath: "./mocks_matryer_output_dir_test.go",
			expected: "var _ OutputDirWithinSrcPkg = &MoqOutputDirWithinSrcPkg{}",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			b, err := os.ReadFile(tt.filepath)
			require.NoError(t, err)
			assert.Contains(t, string(b), tt.expected)
		})
	}
}
