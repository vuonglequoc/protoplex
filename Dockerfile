# build
FROM golang:1.20.0-alpine3.17 AS build

RUN mkdir -p /go/src/github.com/vuonglequoc
COPY ./ /go/src/github.com/vuonglequoc/protoplex
RUN cd /go/src/github.com/vuonglequoc/protoplex/ \
 && mkdir build \
 && cd build/ \
 && go install ../cmd/protoplex/

# deploy
FROM alpine:3.17.1
COPY --from=build /go/bin/protoplex /protoplex

USER 999

EXPOSE 443/tcp

STOPSIGNAL SIGINT

ENTRYPOINT ["/protoplex"]
