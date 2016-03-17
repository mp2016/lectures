include "types/Binding.iol"

constants {
  Location_Registry = "socket://localhost:9000/"
}

type ListOfServices:void {
  .service*:Binding
}

type RegisterRequest:void {
  .serviceType:string
  .binding:Binding
}

interface RegistryIface {
RequestResponse:
  register(RegisterRequest)(void) throws AlreadyRegistered(void),
  getServices(string)(ListOfServices)
}
