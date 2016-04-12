include "http://localhost:8080/getOutputPort"
include "console.iol"

main
{
  sum@Calculator( { .x = 2, .y = 5 } )( result );
  if ( result != 7 ) {
    throw( TestFailed )
  }
  println@Console( result )()
}
