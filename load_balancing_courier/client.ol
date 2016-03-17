include "calculator_iface.iol"
include "console.iol"
include "ui/swing_ui.iol"
include "load_balancer_iface.iol"

outputPort Calculator {
Location: Location_LoadBalancer
Protocol: sodep
Interfaces: CalculatorIface
}

main
{
  {
    sum@Calculator( {
      .number[0] = int( args[0] ),
      .number[1] = int( args[1] )
    } )( total )
  |
    subtract@Calculator( { .x = 3, .y = 1 } )( result )
  };
  println@Console( total + result )()
}
