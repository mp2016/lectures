include "app.iol"
include "uri_templates.iol"
include "reflection.iol"
include "console.iol"
include "router.iol"

execution { concurrent }

interface WebIface {
RequestResponse:
	get, post, put, delete
}

inputPort WebInput {
Location: "socket://localhost:8080"
Protocol: http {
	.default.get = "get";
	.default.post = "post";
	.default.put = "put";
	.default.delete = "delete";
	.method -> method;
	.statusCode -> statusCode;
	.format = "json"
}
Interfaces: WebIface
}

inputPort RouterIn {
Location: "local"
Interfaces: RouterIface
}

define addResourceRoutes
{
	routes[#routes] << {
		.method = "get",
		.template = resource.template,
		.operation = resource.name + "_index"
	};
	routes[#routes] << {
		.method = "get",
		.template = resource.template + "/{" + resource.id + "}",
		.operation = resource.name + "_show"
	};
	routes[#routes] << {
		.method = "post",
		.template = resource.template,
		.operation = resource.name + "_create"
	};
	routes[#routes] << {
		.method = "put",
		.template = resource.template + "/{" + resource.id + "}",
		.operation = resource.name + "_update"
	};
	routes[#routes] << {
		.method = "delete",
		.template = resource.template + "/{" + resource.id + "}",
		.operation = resource.name + "_destroy"
	}
}

init
{
	config( config )() {
		routes -> config.routes;
		resource -> config.resources[i];
		for( i = 0, i < #config.resources, i++ ) {
			addResourceRoutes
		}
	}
}

define findRoute
{
	for( i = 0, i < #routes && !found, i++ ) {
		if ( routes[i].method == method ) {
			match@UriTemplates( {
				.uri = request.requestUri,
				.template = routes[i].template
			} )( found );
			op = routes[i].operation
		}
	}
}

define route
{
	findRoute;
	if ( !found ) {
		statusCode = 404
	} else {
		statusCode = 200;
		with( invokeReq ) {
			.operation = op;
			.outputPort = "App"
		};
		foreach( n : found ) {
			invokeReq.data.(n) << found.(n)
		};
		foreach( n : request.data ) {
			invokeReq.data.(n) << request.data.(n)
		};
		invoke@Reflection( invokeReq )( response )
	}
}

define makeLink
{
	for( i = 0, i < #routes && !found, i++ ) {
		if ( routes[i].method == request.method && routes[i].operation == request.operation ) {
			with( expand ) {
				.template = routes[i].template;
				.params -> request.params
			};
			expand@UriTemplates( expand )( response );
			response = "http://" + config.host + response
		}
	}
}

main
{
	[ get( request )( response ) {
		method = "get";
		route
	} ]

	[ post( request )( response ) {
		method = "post";
		route
	} ]

	[ put( request )( response ) {
		method = "post";
		route
	} ]

	[ delete( request )( response ) {
		method = "delete";
		route
	} ]

	[ makeLink( request )( response ) {
		if ( !is_defined( request.method ) ) {
			request.method = "get"
		};
		makeLink
	} ]

	/* [ setRoute()() ]
	[ setResource()() {
		// see http://guides.rubyonrails.org/routing.html
	} ] */
}

