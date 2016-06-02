include "app.iol"
include "uri_templates.iol"
include "console.iol"
include "router_embed.iol"

execution { concurrent }

inputPort AppIn {
Location: "local://App"
Interfaces: AppIface
}

init
{
	config.host = "localhost:8080";
	/* config.routes[0] << {
		.method = "get",
		.template = "/poll",
		.operation = "getPollList"
	};
	config.routes[1] << {
		.method = "get",
		.template = "/poll/{id}",
		.operation = "getPoll"
	};
	config.routes[2] << {
		.method = "get",
		.template = "/poll/{id}/votes",
		.operation = "getVoteList"
	};
	config.routes[3] << {
		.method = "post",
		.template = "/poll",
		.operation = "createPoll"
	}; */
	config.resources[0] << {
		.name = "poll",
		.id = "id",
		.template = "/poll"
	};
	config.resources[1] << {
		.name = "vote",
		.id = "vid",
		.template = "/poll/{id}/vote"
	};
	config@Router( config )();

	global.polls.("1") << {
		.options[0] = "A",
		.options[1] = "B",
		.options[2] = "C",
		.vote[0].name = "John",
		.vote[0].choice = "A",
		.vote[1].name = "Jane",
		.vote[1].choice = "B"
	};
	global.polls.("2") << {
		.options[0] = "D",
		.options[1] = "E",
		.options[2] = "F",
		.vote[0].name = "John",
		.vote[0].choice = "F",
		.vote[1].name = "Jane",
		.vote[1].choice = "E"
	}
}

define findPoll
{
	if( !is_defined( global.polls.(request.id) ) ) {
		throw( NotFound )
	};
	poll -> global.polls.(request.id)
}

main
{
	[ poll_index()( response ) {
		foreach( id : global.polls ) {
			makeLink@Router( {
				.operation = "poll_show",
				.params.id = id
			} )( response.href[i++] )
		}
	} ]

	[ poll_show( request )( response ) {
		findPoll;
		response.options << poll.options;
		makeLink@Router( {
			.operation = "vote_index",
			.params.id = request.id
		} )( response.votes.href );
		for( i = 0, i < #poll.vote, i++ ) {
			response.votes.vote[i] << poll.vote[i]
		}
	} ]

	[ vote_index( request )( response ) {
		findPoll;
		response.vote -> poll.vote
	} ]

	[ poll_create( request )( response ) {
		id = new;
		global.polls.(id).options << request.options
	} ]

	/*[ postPoll( request )( response ) {
		id = new;
		global.polls.(id).options << request.data.options;
		statusCode = 201; // 201 Created
		response.link = "http://localhost:8080/poll/" + id
	} ]

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
	/*	}
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

	[ delete( request )( response ) ]*/
}