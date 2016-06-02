type PollList:void {
	.href*:string
}

type GetPoll:void {
	.id:string
}

type Vote:void {
	.name:string
	.choice:string
}

type Poll:void {
	.options*:string
	.votes:void {
		.href:string
		.vote*:Vote
	}
}

type GetVoteList:void {
	.id:string
}

type VoteList:void {
	.vote*:Vote
}

interface AppIface {
RequestResponse:
	poll_index(void)(PollList),
	poll_show(GetPoll)(Poll),
	vote_index(GetVoteList)(VoteList),
	poll_create
}

outputPort App {
Location: "local://App"
Interfaces: AppIface
}
