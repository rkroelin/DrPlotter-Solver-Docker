# DrPlotter-Solver-Docker

This is a fairly straight forward Dockerfile that builds off of Foxypool's DrPlotter image, specifically the v 1.0.4 solver (<https://github.com/foxypool/drplotter/pkgs/container/drplotter/236900692?tag=1.0.4-solver>).  The goal is remote deployable DrSolvers which connect back home via tailscale.  It works great on vast.ai

It expands on the base image by adding in Tailscale and proxychains to faciliate connectivity to a remote DrServer instance. proxychains is used to faciliciate the tailscale's userspace networking required in a docker container.

Below is a link to the built image.  I've also included the raw dockerfile for anyone who wants to modify.
<https://hub.docker.com/r/rmkr/drsolver_node/>

rmkr/drsolver_node:latest

You'll need to configure the following environmental variables:

 "TAILSCALE_AUTHKEY": Auth key to access your tailnet.  Highly suggest using tags and or the tailscale ACL to limit connectivity to just your DrServer node on port 8080.
 
  "DRSERVER_IP_ADDRESS": The tailscale IP address of your DrServer.  It won't work with the FQDN.
  
  "DRPLOTTER_CLIENT_TOKEN": your DrPlotter Client Token.

The dockerfile includes some basic health checks for when the image boots.
