include "calculator_iface.iol"
include "console.iol"
include "registry.iol"

execution { concurrent }

inputPort CalcInput {
Location: "socket://localhost:8002/"
Protocol: sodep
Interfaces: CalculatorIface
}

init
{
  r.serviceType = "Calculator";
  r.binding << global.inputPorts.CalcInput;
  register@Registry( r )()
}

define printServed
{
  synchronized( ServedCount ) {
    println@Console(
      "Requests served so far " +
      ++global.served
    )()
  }
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
