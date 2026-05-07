package directivecommentsexample

// Requester is an interface that defines a method for making HTTP requests.
//
//mockery:generate: true
type Requester interface {
	Get(path string) (string, error)
}

type Interface1 interface {
	Get(path string) (string, error)
}
