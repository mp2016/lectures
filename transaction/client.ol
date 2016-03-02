include "broker.iol"
include "console.iol"

main
{
  scope( s ) {
    install( ProductNotFound =>
      println@Console( "Product not found: " + args[0] )()
    );
    getPrice@Broker( {
      .product = args[0],
      .seller = args[1]
    } )( price );
    println@Console( price )()
  }
}
