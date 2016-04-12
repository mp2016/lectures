include "file.iol"
include "calculator.iol"

execution { concurrent }

inputPort CalculatorInput {
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: CalculatorIface
}

interface CalculatorHTTPIface {
RequestResponse:
  getOutputPort(void)(string)
}

inputPort CalculatorHTTPInput {
Location: "socket://localhost:8080/"
Protocol: http {
  .format = "html"
}
Interfaces: CalculatorHTTPIface
}

main
{
  [ sum( request )( request.x + request.y ) ]

  [ getOutputPort()( op ) {
    readFile@File( { .filename = "calculator.iol" } )( op );
    op += "
outputPort Calculator {
  Location: \"socket://localhost:8000/\"
  Protocol: sodep
  Interfaces: CalculatorIface
}
"
  } ]
}
