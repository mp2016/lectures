include "seller.iol"
include "broker.iol"
include "console.iol"

execution { concurrent }

inputPort BrokerInput {
Location: Location_Broker
Protocol: sodep
Interfaces: BrokerIface
}

cset {
sid: GetPriceRequest.sid BuyRequest.sid
     SimpleSessionRequest.sid
}

init {
  global.users << {
    .John = "secret",
    .John.isAdmin = false,
    .Alice = "blah",
    .Alice.isAdmin = true
  }
}

define checkPwd
{
  if ( global.users.(request.username) != request.pwd ) {
    throw( InvalidPassword )
  }
}

define checkSid
{
  if ( !is_defined( global.sids.(request.sid) ) ) {
    throw( InvalidSession )
  }
}

main
{
  [ login( request )( csets.sid ) {
    checkPwd;
    csets.sid = new
  } ] {
  {
  provide
    [ getPrice( request )( price ) {
      if ( request.seller == "Amazon" ) {
        getPrice@Seller( request.product )( price )
      } else {
        throw( SellerNotFound )
      }
    } ]

    [ buy( request )() {
      nullProcess
    } ]
  until
    [ logout() ] {
      keeprun = false
    }
  };
  println@Console( "Terminated for sid " + csets.sid )()
  }

  [ getName()( "DanskeMægler" ) ]

  [ loginAdmin( request )( csets.sid ) {
    checkPwd;
    if ( !global.users.(request.username).isAdmin ) {
      throw( InsufficientPermissions )
    };
    csets.sid = new
  } ] {
    [ shutdown() ] {
      exit
    }
    [ logout() ]
  }
}
