# build
FROM golang:alpine3.16 AS build

RUN apk add git
RUN mkdir -p /go/src/github.com/vuonglequoc
COPY ./ /go/src/github.com/vuonglequoc/protoplex
RUN cd /go/src/github.com/vuonglequoc/protoplex/ \
 && go install cmd

# deploy
FROM alpine:3.16.3
COPY --from=build /go/src/github.com/vuonglequoc/protoplex/protoplex /protoplex

USER 999

EXPOSE 443/tcp

STOPSIGNAL SIGINT

ENTRYPOINT ["/protoplex"]
