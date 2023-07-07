# SampleGoAppWithTerraform

Currently running at https://properly-unique-beagle.waypoint.run/

## About this app
This app runs a built from scratch Docker container that executes a Go binary. The Go binary runs a simple static website that can be hosted anywhere.

## Infrastructure Tooling
* [**Terraform**](https://terraform.io) - used to deploy the AWS infrastructure.
* [**Waypoint**](https://waypointproject.io) - used to build and deploy the app.


### Terraform
There are two Terraform projects: [platform](terraform/platform/) and [webservers](terraform/webservers/). The platform contains infrastructure definitions for the vpc, subnets, and various gateways for internet connectivity. The webservers project contains the infrastructure definition for the web servers. For cost reasons, the webservers run only on ec2 instances without a load balancer or autoscaling group. This is fine for development purposes; however, in production we would to implement an autoscaling group in conjunction with a suitable scaling policy all fronted by a load balancer.

### Waypoint
The Waypoint server is currently installed on the webserver ec2 instance. It is configured via the [waypoint.hcl](waypoint.hcl) to poll this GitHub repo for changes and automatically build and deploy those changes. This is also a suitable flow for development, but may not be suitable for all production environments. Production may require user approval or input, and production may be running in a different set of infrastructure altogether. Waypoint would need a new runner configured to communicate and interface with this new infrastructure.



##### Go website source code obtained from https://github.com/hashicorp/waypoint-examples/kubernetes/go