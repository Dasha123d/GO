package type_alias

import "github.com/vektra/mockery/v3/internal/fixtures/type_alias/subpkg"

type (
	Type              = int
	S                 = subpkg.S
	AliasToInterface3 = subpkg.Interface3
)

type Interface1 interface {
	Foo() Type
}

type Interface2 interface {
	F(Type, S, subpkg.S)
}
