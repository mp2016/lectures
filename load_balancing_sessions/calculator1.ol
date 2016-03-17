include "calculator_iface.iol"
include "console.iol"
include "registry.iol"

execution { concurrent }

inputPort CalcInput {
Location: "socket://localhost:8001/"
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
    csets.sid = new
  };

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
    [ logout()() ]
}
