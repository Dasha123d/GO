package inpackage

type InternalStringType string

type Foo interface {
	Bar() InternalStringType
}
