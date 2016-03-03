include "broker.iol"
include "console.iol"

main
{
  scope( s ) {
    install( ProductNotFound =>
      println@Console( "Product not found: " + args[0] )()
    );
    login@Broker( {
      .username = args[2],
      .pwd = args[3]
    } )( sid );
    getPrice@Broker( {
      .product = args[0],
      .seller = args[1],
      .sid = sid
    } )( price );
    println@Console( price )();
    getPrice@Broker( {
      .product = args[0],
      .seller = args[1],
      .sid = sid
    } )( price );
    println@Console( price )();
    logout@Broker( { .sid = sid } )
  }
}
