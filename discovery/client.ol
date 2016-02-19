include "calculator_iface.iol"
include "console.iol"
include "ui/swing_ui.iol"
include "registry.iol"

outputPort Calculator {
Protocol: sodep
Interfaces: CalculatorIface
}

main
{
  mesg = "What do you want?";
  getServices@Registry( "Calculator" )( list );
  for( i = 0, i < #list.service, i++ ) {
    mesg += "\n" + list.service[i].location
  };
  showInputDialog@SwingUI
    ( mesg )
    ( index );
  // For simplicity, we do not care about array out of bounds errors
  Calculator << list.service[int(index)];
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
