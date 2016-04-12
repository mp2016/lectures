# Project Ideas

### External links

- [https://github.com/jolie-projects/open_projects/tree/master/ide](https://github.com/jolie-projects/open_projects/tree/master/ide)
- [http://cs.unibo.it/~sgiallor/ideas/](http://cs.unibo.it/~sgiallor/ideas/)
- [http://fabriziomontesi.com/files/fmontesi-thesis-proposals.pdf](http://fabriziomontesi.com/files/fmontesi-thesis-proposals.pdf)

### Choreographies

Use choreographies to compile safe implementations, e.g., see [http://arxiv.org/pdf/1602.08863v1.pdf](http://arxiv.org/pdf/1602.08863v1.pdf).

Or, use choreographies to generate monitors that check whether a system is following some specifications, e.g., a client should always get a receipt after buying something.

### Benchmarking suite

Make a benchmarking suite for evaluating the performance of a microservice system.

### Testing

Implement a testing suite for Jolie, which can handle the creation of fake mockup contexts for simulating the dependencies that a service has.

### Message Tracking

See "Sodep+ for better logging and flow tracking" at [http://cs.unibo.it/~sgiallor/ideas/](http://cs.unibo.it/~sgiallor/ideas/).

### JPM

Extend [https://github.com/jolie/jpm](https://github.com/jolie/jpm) to support installation from Git repositories.

### Namespaces and Remote interfaces

Explore how to export interfaces to remote clients, such that we do not need to share interface files explicitly anymore.

Something like `include "http://localhost:8080/getIface"` is already possible, so there is a base to start form already.

### Virtualisation

When we use embedding in Jolie, we do not get a monolith from an architectural point of view, because software artifacts remain distinct (no coupling). But, the lifecycles of the supervisor (the embedder) and the embedded services get linked. A downside of this is that they share the same Java VM (JVM), so if one service makes the JVM crash, then also all the other services crash.
Another downside is that all services share the same filesystem and security access. So it is difficult to program a cloud server that loads sub-services, since these may be malicious.

Explore how to integrate Jolie with the possibility of embedding and controlling services in an external JVM. For example, make it possible to run sub-services in a separate JVM, which is dynamically started when needed.

Another interesting aspect could be exploring how to integrate Jolie with Docker, to govern the resources used by sub-services.

### Microservice for checking Jolie code

Make a service that receives Jolie code and
returns a list of errors about it.
