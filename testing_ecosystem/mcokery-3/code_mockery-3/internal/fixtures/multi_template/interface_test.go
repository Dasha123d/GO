package multitemplate

import (
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestFoo(t *testing.T) {
	testifyMock := NewMockTestifyFoo(t)
	testifyMock.EXPECT().Bar().Return("bar")
	assert.Equal(t, "bar", testifyMock.Bar())

	matryerMock := MockMatryerFoo{
		BarFunc: func() string {
			return "bar"
		},
	}
	assert.Equal(t, "bar", matryerMock.Bar())
}
