include "registry_iface.iol"
include "console.iol"
include "calculator_iface.iol"
include "runtime.iol"
include "load_balancer_iface.iol"

execution { concurrent }

define selectCalculator
{
  synchronized( Mutex ) {
    if ( #global.services.Calculator == 0 ) {
      throw( IOException )
    };
    Calculator << global.services.Calculator[global.calcCounter];
    global.calcCounter = ( global.calcCounter + 1 ) % #global.services.Calculator;
    println@Console( "Contacting: " + Calculator.location )()
  }
}

inputPort RegistryInput {
Location: Location_Registry
Protocol: sodep
Interfaces: RegistryIface
}

outputPort Calculator {
Protocol: sodep
Interfaces: CalculatorIface
}

inputPort LoadBalancerInput {
Location: Location_LoadBalancer
Protocol: sodep
Aggregates: Calculator
}

courier LoadBalancerInput {
  [ interface CalculatorIface( request )( response ) ] {
    selectCalculator;
    forward Calculator( request )( response )
  }
}

/*
[ sum( request )( response ) {
  selectCalculator;
  sum@Calculator( request )( response )
} ]

[ subtract( request )( response ) {
  selectCalculator;
  subtract@Calculator( request )( response )
} ]
*/

init
{
  global.calcCounter = 0
}

main
{
  [ register( request )( response ) {
    synchronized( Mutex ) {
      if ( is_defined( global.locations.(request) ) ) {
        throw( AlreadyRegistered )
      } else {
        global.locations.(request.binding.location) = true;
        global.services.(request.serviceType)[
          #global.services.(request.serviceType)
        ] << request.binding;
        println@Console( "Registered " + request )()
      }
    }
  } ] {
    dumpState@Runtime()( s );
    println@Console( s )()
  }

  [ getServices( serviceType )( response ) {
    synchronized( Mutex ) {
      response.service -> global.services.(serviceType)
    }
  } ]
}
