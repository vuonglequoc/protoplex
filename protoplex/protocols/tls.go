package protocols

// TLS_HANDSHAKE_CONTENT_TYPE = 0x16
// TLS_VERSION_MAJOR = 0x03
// TLS_VERSION_MINOR = 0x01

// NewTLSProtocol initializes a Protocol with a TLS signature.
func NewTLSProtocol(targetAddress string) *Protocol {
	return &Protocol{
		Name:            "TLS",
		Target:          targetAddress,
		MatchStartBytes: [][]byte{{0x16, 0x03, 0x01}},
	}
}
