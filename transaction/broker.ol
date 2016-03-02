include "seller.iol"
include "broker.iol"

execution { sequential }

inputPort BrokerInput {
Location: Location_Broker
Protocol: sodep
Interfaces: BrokerIface
}

main
{
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
}
