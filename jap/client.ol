// include "jap:file:calc.jap!/calculator_iface.iol"
include "jap:http://www.fabriziomontesi.com/calc.jap!/calculator_iface.iol"
include "console.iol"

outputPort Calculator {
Location: "socket://localhost:8001/"
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
