include "common.iol"

execution { concurrent }

inputPort HelloInput {
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: HelloIface
}

main
{
  hello( team )( response ) {
    for( i = 0, i < #team.person, i++ ) {
      age += team.person[i].age
    };
    response = "The total age of the team is " + age
  }
}
