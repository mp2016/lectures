include "calculator_iface.iol"
include "console.iol"
include "registry.iol"
include "time.iol"

execution { concurrent }

constants {
  SESSION_TIMEOUT = 1000
}

inputPort CalcInput {
Location: Location_Calculator
Protocol: sodep
Interfaces: CalculatorIface
}

inputPort LocalInput {
Location: "local"
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

cset {
sid:  SumRequest.sid SubRequest.sid Logout.sid
}

main
{
  login( secret )( csets.sid ) {
    if ( secret != "secret" ) {
      // Insert decent authentication code here!
      throw( InvalidSecret )
    };
    csets.sid = new;
    println@Console( "Starting up " + csets.sid )()
  };
  setNextTimeout@Time( SESSION_TIMEOUT {
    .operation = "logout",
    .message.sid = csets.sid
  } );

  provide
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
  until
    [ logout()() {
      println@Console( "Shutting down " + csets.sid )()
    } ]
}
