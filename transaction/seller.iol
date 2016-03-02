interface SellerIface {
RequestResponse:
  // Gets the price of a product
  getPrice(string)(int)
    throws ProductNotFound(void),

  // Buy a product
  buy(string)(void)
    throws
      ProductNotFound(void)
      OutOfStock(void)
}

constants {
  Location_Seller = "socket://localhost:8001"
}

outputPort Seller {
Location: Location_Seller
Protocol: sodep
Interfaces: SellerIface
}
