include "runtime.iol"
include "file.iol"
include "cloud_server_iface.iol"
include "console.iol"
include "time.iol"
include "exec.iol"

constants {
  TIMEOUT = 2000
}

inputPort LocalInput {
Location: "local"
Interfaces: CloudServerIface
}

inputPort CloudServer {
Location: "socket://localhost:8000/"
Protocol: sodep
Interfaces: CloudServerIface
}

execution { sequential }

init
{
  deleteDir@File( "tmp" )();
  mkdir@File( "tmp" )()
}

main
{
  [ run( request )( output ) {
    filename = "tmp/" + new;
    if ( request.type == "Jolie" ) {
      filename += ".ol";
      cmd = "jolie"
    } else if ( request.type == "JavaScript" ) {
      filename += ".js";
      cmd = "jjs"
    };
    writeFile@File( {
      .content = request.program,
      .filename = filename
    } )();
    install( RuntimeException =>
      println@Console( main.RuntimeException.stackTrace )()
    );
    exec@Exec( cmd {
      .args[0] = filename,
      .waitFor = 1,
      .stdOutConsoleEnable = true
    } )( result );
    output = result
  } ]
}
