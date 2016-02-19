include "registry_iface.iol"
include "console.iol"
include "runtime.iol"

execution { sequential }

inputPort RegistryInput {
Location: Location_Registry
Protocol: sodep
Interfaces: RegistryIface
}

main
{
  [ register( request )( response ) {
    if ( is_defined( global.locations.(request) ) ) {
      throw( AlreadyRegistered )
    } else {
      global.locations.(request.binding.location) = true;
      global.services.(request.serviceType)[
        #global.services.(request.serviceType)
      ] << request.binding;
      println@Console( "Registered " + request )()
    }
  } ] {
    dumpState@Runtime()( s );
    println@Console( s )()
  }

  [ getServices( serviceType )( response ) {
    response.service -> global.services.(serviceType)
  } ]
}
