type GetPriceRequest: void {
  .product:string
  .seller:string
  .sid:string
}

type BuyRequest: void {
  .product:string
  .seller:string
  .sid:string
}

type LoginRequest:void {
  .username:string
  .pwd:string
}

type LogoutRequest:void {
  .sid:string
}

interface BrokerIface {
OneWay:
  logout(LogoutRequest)

RequestResponse:
  // Logs the client in
  login(LoginRequest)(string)
    throws InvalidPassword(void),

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
