# Пример: Suite с фикстурами

Файл: `examples/suite-example_test.go`

```go
package example_test

import (
    "testing"
    "github.com/stretchr/testify/suite"
)

type ExampleSuite struct {
    suite.Suite
    counter int
}

func (s *ExampleSuite) SetupTest() {
    s.counter = 0
}

func (s *ExampleSuite) TestIncrement() {
    s.counter++
    s.Assert().Equal(1, s.counter)
}

func (s *ExampleSuite) TestDecrement() {
    s.counter--
    s.Assert().Equal(-1, s.counter)
}

func TestExampleSuite(t *testing.T) {
    suite.Run(t, new(ExampleSuite))
}
```
