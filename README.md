# protoplex

*An application protocol multiplexer*

[![Build Status](https://jenkins.kinguda.com/buildStatus/icon?job=protoplex)](https://jenkins.kinguda.com/buildStatus/icon?job=protoplex)
[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fvuonglequoc%2Fprotoplex.svg?type=shield)](https://app.fossa.com/projects/git%2Bgithub.com%2Fvuonglequoc%2Fprotoplex?ref=badge_shield)

## What is this?

In a nutshell, this application lets you run multiple kinds of applications
on a single port. This is useful for, for instance, running an OpenVPN server
and a TLS/HTTPS server on port 443, which in turn is useful for evading
firewalls that block all other outbound ports.

```bash
                                        |--> SSH 22/TCP
Client --> Single Port --> Validator /  |--> TLS (/ HTTPS) 8443/TCP
               443         Multiplexer  |--> OpenVPN 1194/TCP
                                        |--> SOCKS 1080/TCP
```

## Running

### Native

Requirements:
* [golang 1.19.2](https://hub.docker.com/_/golang)

Assuming you have a properly configured Go setup, get and compile the multiplexer with

```bash
go install github.com/vuonglequoc/protoplex/cmd/protoplex@latest
```

and then run it with (for example, to run SSH and HTTPS)

```bash
protoplex --ssh your_ssh_host:22 --tls your_webserver:8443
```

Protoplex is now running on port `443` and ready to accept connections.

For more extensive configuration, please see the output of `--help`.

### Docker

[A docker image may be used](https://hub.docker.com/r/vuonglequoc/protoplex)
for ease of use and deployment.

Build docker image by yourself:

```bash
docker build -t vuonglequoc/protoplex .
```

## Goals

The concepts for this multiplexer were as follows:

- Resource usage about on par with [sslh](https://github.com/yrutschle/sslh)
- Easily extensible
- Highly dynamic

To this end, protoplex supports multiple matching methods for protocols:

- Bytestring comparison
- Regex matching

These can both be implemented for a protocol, with bytestrings taking
priority (due to efficiency). In addition, protocols support matching limits,
reducing the amount of protocols evaluated for a given handshake.

## Protocol support

Currently supported protocols are:

| Protocol        | Bytestring comparison | Regex matching           |
| --------------- | --------------------- | ------------------------ |
| SSH             | {'S', 'S', 'H', '-'}  |                          |
| HTTP            |                       | "^[A-Z]+ .+ HTTP/"       |
| TLS (/ HTTPS)   | {0x16, 0x03, 0x01}    |                          |
| OpenVPN         |                       | \`^\x00[\x0d-\xff]\x38\`<br />\`^\x00[\x0d-\xff]$\` |
| SOCKS4 / SOCKS5 | {0x04} / {0x05}       |                          |

Feel free to [file an issue](https://github.com/vuonglequoc/protoplex/issues/new)
on the GitHub repository if you want a protocol to be supported. Please include
steps to accurately reproduce your client setup.

Alternatively, you may submit a pull request.

## License

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fvuonglequoc%2Fprotoplex.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fvuonglequoc%2Fprotoplex?ref=badge_large)
