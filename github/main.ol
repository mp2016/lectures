include "string_utils.iol"
include "console.iol"

interface GitHubIface {
RequestResponse:
  listUserRepositories(undefined)(undefined),
  listLanguages(undefined)(undefined)
}

outputPort GitHub {
Location: "socket://api.github.com:443/"
Protocol: https {
  .osc.listUserRepositories.method =
    .osc.listLanguages.method = "get";
  .addHeader.header << "User-Agent" { .value = "Jolie" };
  // .debug = .debug.showContent = true;
  .osc
    .listUserRepositories
      .alias = "users/%{username}/repos";
  .osc
    .listLanguages
      .alias = "repos/%{owner}/%{repo}/languages";
  .format = "json"
}
Interfaces: GitHubIface
}

main
{
  listUserRepositories@GitHub( {
    .username = "fmontesi"
  } )( response );
  valueToPrettyString@StringUtils( response )( s );
  println@Console( s )()
}
