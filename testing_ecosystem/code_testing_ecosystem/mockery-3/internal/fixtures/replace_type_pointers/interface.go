package replace_type_pointers

type (
	Foo int
	Bar int
)

type InterfaceWithPointers interface {
	FooFunc(*Foo) *Foo
	BarFunc(Bar) Bar
}
