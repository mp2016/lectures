type MakeLinkRequest:void {
	.operation:string
	.params:undefined
	.method?:string // default: get
}

type Route:void {
	.method:string
	.template:string
	.operation:string
}

type Resource:void {
	.name:string
	.id:string
	.template:string
}

type Config:void {
	.host:string
	.routes*:Route
	.resources*:Resource
}

interface RouterIface {
RequestResponse:
	config(Config)(void),
	makeLink(MakeLinkRequest)(string) throws BindingNotFound(void)
}

