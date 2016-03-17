include "registry_iface.iol"
include "console.iol"
include "calculator_iface.iol"
include "runtime.iol"
include "load_balancer_iface.iol"

execution { concurrent }

inputPort RegistryInput {
Location: Location_Registry
Protocol: sodep
Interfaces: RegistryIface
}

inputPort LoadBalancerInput {
Location: Location_LoadBalancer
Protocol: sodep
Interfaces: CalculatorIface
}

outputPort Calculator {
Protocol: sodep
Interfaces: CalculatorIface
}

init
{
  global.calcCounter = 0
}

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

  [ sum( request )( response ) {
    selectCalculator;
    sum@Calculator( request )( response )
  } ]

  [ subtract( request )( response ) {
    selectCalculator;
    subtract@Calculator( request )( response )
  } ]
}
