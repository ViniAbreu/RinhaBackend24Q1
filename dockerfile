FROM ubuntu:jammy
COPY ./Linux64/Release/rinha_standalone ./rinha_standalone
ENTRYPOINT ./rinha_standalone