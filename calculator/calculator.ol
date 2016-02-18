include "calculator_iface.iol"
include "console.iol"

execution { concurrent }

inputPort CalcInput {
Location: "socket://localhost:8001/"
Protocol: sodep
Interfaces: CalculatorIface
}

define printServed
{
  println@Console( "Requests served so far " + ++global.served )()
}

main
{
  [ sum( request )( total ) {
    for( i = 0, i < #request.number, i++ ) {
      total += request.number[i]
    }
  } ] {
    printServed
  }

  [ subtract( request )( result ) {
    result = request.x - request.y
  } ] {
    printServed
  }
}
