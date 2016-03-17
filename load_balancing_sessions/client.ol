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
  login@Calculator( args[2] )( sid );
  {
    sum@Calculator( {
      .number[0] = int( args[0] ),
      .number[1] = int( args[1] ),
      .sid = sid
    } )( total )
  |
    subtract@Calculator( {
      .x = 3, .y = 1,
      .sid = sid
    } )( result )
  };
  logout@Calculator( { .sid = sid } )();
  println@Console( total + result )()
}
