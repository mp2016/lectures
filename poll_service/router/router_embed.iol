include "router.iol"

outputPort Router {
Interfaces: RouterIface
}

embedded {
Jolie:
	"router.ol" in Router
}
