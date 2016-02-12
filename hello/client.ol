include "console.iol"

interface HelloIface {
RequestResponse:
  hello(string)(string)
}

outputPort HelloSrv {
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: HelloIface
}

main
{
  hello@HelloSrv( args[0] )( reply );
  println@Console( reply )()
}
