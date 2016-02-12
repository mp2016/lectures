execution { concurrent }

type HelloRequest:void {
  .name:string
}

interface HelloIface {
RequestResponse:
  hello(HelloRequest)(string)
}

inputPort HelloInput {
Location: "socket://localhost:8000/"
Protocol: http
Interfaces: HelloIface
}

main
{
  hello( x )( "Hello " + x.name + "!" )
}
