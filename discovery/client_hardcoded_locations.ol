include "calculator_iface.iol"
include "console.iol"
include "ui/swing_ui.iol"

outputPort Calculator {
Protocol: sodep
Interfaces: CalculatorIface
}

main
{
  showInputDialog@SwingUI
    ( "What do you want?
    socket://localhost:8001/
    socket://localhost:8002/
    socket://localhost:8003/
    " )
    ( Calculator.location );
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
