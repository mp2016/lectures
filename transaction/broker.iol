type GetPriceRequest: void {
  .product:string
  .seller:string
}

type BuyRequest: void {
  .product:string
  .seller:string
}

interface BrokerIface {
RequestResponse:
  // Gets the price of a product
  getPrice(GetPriceRequest)(int)
    throws ProductNotFound(void)
           SellerNotFound(void),

  // Buy a product
  buy(BuyRequest)(void)
    throws
      SellerNotFound(void)
      ProductNotFound(void)
      OutOfStock(void)
      OutOfMoney(void)
}

constants {
  Location_Broker = "socket://localhost:8002"
}

outputPort Broker {
Location: Location_Broker
Protocol: sodep
Interfaces: BrokerIface
}
