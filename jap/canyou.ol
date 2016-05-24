include "console.iol"
include "time.iol"

embedded {
Jolie: "calc.jap"
}

interface MyIface {
OneWay: timeout
}

inputPort Nice {
Location: "local"
Interfaces: MyIface
}

main
{
  println@Console("Woohoo!")();
  timeout()
}
