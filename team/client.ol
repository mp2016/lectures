include "console.iol"
include "common.iol"

outputPort HelloSrv {
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: HelloIface
}

main
{
  team.sponsor = "Hummel";
  team.person[0].name = "John";
  team.person[0].age = 20;
  team.person[1].name = "Joan";
  team.person[1].age = 22;
  hello@HelloSrv( team )( reply );
  println@Console( reply )()
}
