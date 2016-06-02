include "uri_templates.iol"
include "console.iol"

execution { concurrent }

interface HTTPIface {
RequestResponse:
	get(undefined)(undefined),
	post(undefined)(undefined),
	put(undefined)(undefined),
	delete(undefined)(undefined)
}

inputPort PollInput {
Location: "socket://localhost:8080"
Protocol: http {
	.debug = .debug.showContent = true;
	.default.get = "get";
	.default.post = "post";
	.default.put = "put";
	.default.delete = "delete";
	.statusCode -> statusCode;
	.format = "json"
}
Interfaces: HTTPIface
}

main
{
	[ get( request )( response ) {
		match@UriTemplates( {
			.uri = request.requestUri,
			.template = "poll"
		} )( m );
		if ( m ) { // GET /poll
			i = 0;
			foreach( id : global.polls ) {
				response.link[i++] = "http://localhost:8080/poll/" + id
			}
		} else {
			match@UriTemplates( {
				.uri = request.requestUri,
				.template = "poll/{id}"
			} )( m );
			if ( m ) { // GET /poll/{id}
				response << global.polls.(m.id)
			}/*  else {
				match@UriTemplates( {
					.uri = request.requestUri,
					.template = "poll/{id}/vote"
				} )( m );
				if ( m ) { // GET /poll/{id}/vote
					for( i = 0, i < #global.polls.(m.id).votes, i++ ) {
						response.votes[i] = "http://localhost:8080/poll"
					}
				}
			} */
		}
	} ]

	[ post( request )( response ) {
		match@UriTemplates( {
			.uri = request.requestUri,
			.template = "poll"
		} )( m );
		if ( m ) { // POST /polls
			id = new;
			global.polls.(id).options << request.data.options;
			statusCode = 201; // 201 Created
			response.link = "http://localhost:8080/poll/" + id
		}
	} ]

	[ put( request )( response ) ]

	[ delete( request )( response ) ]
}