package output_dir

type OutputDirWithDifferentPkgName interface {
	Foo() string
}

type OutputDirWithSamePkgNameAsSrc interface {
	Bar() string
}

type OutputDirWithinSrcPkg interface {
	Baz() string
}
