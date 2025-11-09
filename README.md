# 🔬 GOST MITM Research

Research repository for GOST proxy with JA3/JA4 TLS fingerprinting and browser profile injection.

## 🎯 Project Focus

- MITM proxy with custom TLS fingerprints
- Browser profile injection (Chrome, Firefox, Safari, Edge)
- JA3/JA4 fingerprint analysis and bypass techniques
- Proxy chain configurations for various use cases
- Performance benchmarking and optimization

##  Known issues
- TLS 1.3<->1.2 changing меняет отпечаток, а у нас это не учтено
## ⚡ Quick Start

```bash
# Clone with submodules
git clone --recurse-submodules https://github.com/pv-udpv/go-gost-mitm-research.git
cd go-gost-mitm-research

# Run setup
./scripts/setup.sh

# Generate certificates
./scripts/generate-certs.sh

# Build GOST
make build

# Run basic MITM proxy with Chrome profile
./bin/gost -C configs/mitm-chrome-profile.yml

# Test fingerprint
./scripts/test-fingerprint.sh
```

## 📚 Documentation

- [Quickstart Guide](docs/QUICKSTART.md)
- [Architecture Overview](docs/ARCHITECTURE.md)
- [JA3/JA4 Guide](docs/JA3_JA4_GUIDE.md)
- [MITM Setup](docs/MITM_SETUP.md)
- [Research Notes](docs/RESEARCH_NOTES.md)

## 🔧 Configuration Example

```yaml
# MITM with Chrome TLS fingerprint
services:
  - name: mitm-chrome
    addr: :8080
    handler:
      type: http
      chain: chain-0
      metadata:
        mitm.certFile: certs/ca.crt
        mitm.keyFile: certs/ca.key
    listener:
      type: tcp

chains:
  - name: chain-0
    hops:
      - name: hop-0
        nodes:
          - name: upstream
            addr: example.com:443
            connector:
              type: http
            dialer:
              type: tls
              metadata:
                browserProfile: chrome_modern
```

## 🧪 Research Areas

### 1. TLS Fingerprinting
- JA3 string generation and parsing
- JA4 fingerprint implementation
- Comparison with real browser fingerprints
- Detection bypass techniques

### 2. MITM Techniques
- Certificate generation and management
- TLS interception with custom profiles
- HTTP/2 and HTTP/3 (QUIC) support
- SNI routing and filtering

### 3. Performance
- Connection pooling optimization
- Memory usage profiling
- Latency benchmarks
- Concurrent connection handling

## 📊 Test Results

| Profile | JA3 Match | JA4 Match | Latency | Status |
|---------|-----------|-----------|---------|--------|
| Chrome Modern | ✅ 100% | ✅ 100% | 45ms | Production |
| Firefox Latest | ✅ 100% | ✅ 100% | 42ms | Production |
| Safari macOS | ✅ 98% | ✅ 100% | 50ms | Testing |
| Edge Windows | ✅ 100% | ✅ 100% | 43ms | Production |

## 🛠️ Development

```bash
# Install dependencies
make deps

# Build for current platform
make build

# Build for all platforms
make all

# Run tests
make test

# Run with debug logging
make debug

# Generate configuration
make generate-config
```

## 🔗 References

- [pv-udpv/go-gost-proxy](https://github.com/pv-udpv/go-gost-proxy) - Upstream repository
- [go-gost/gost](https://github.com/go-gost/gost) - GOST core
- [GOST Documentation](https://gost.run/)
- [JA3 Specification](https://github.com/salesforce/ja3)
- [JA4 Specification](https://github.com/FoxIO-LLC/ja4)
- [TLS Fingerprint Database](https://tls.peet.ws/)

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.
