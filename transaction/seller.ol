include "seller.iol"

execution { sequential }

inputPort SellerInput {
Location: Location_Seller
Protocol: sodep
Interfaces: SellerIface
}

init
{
  global.products << {
    .water.price = 2,
    .water.qty = 5,
    .beer.price = 1,
    .beer.qty = 500
  }
}

main
{
  [ getPrice( product )( price ) {
    if ( !is_defined( global.products.(product) ) ) {
      throw( ProductNotFound )
    };
    price = global.products.(product).price
  } ]

  [ buy( product )() {
    if ( !is_defined( global.products.(product) ) ) {
      throw( ProductNotFound )
    };
    prod -> global.products.(product);
    if ( prod.qty > 0 ) {
      prod.qty--
    } else {
      throw( OutOfStock )
    }
  } ]
}
