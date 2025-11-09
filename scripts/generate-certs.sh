#!/bin/bash
set -e

CERT_DIR="certs"
CA_KEY="$CERT_DIR/ca.key"
CA_CERT="$CERT_DIR/ca.crt"
VALIDITY_DAYS=3650

echo "🔑 Generating CA certificates..."

mkdir -p "$CERT_DIR"

if [ -f "$CA_KEY" ] && [ -f "$CA_CERT" ]; then
    echo "⚠️  CA certificates already exist!"
    read -p "Overwrite? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping certificate generation"
        exit 0
    fi
fi

echo "Generating CA private key..."
openssl genrsa -out "$CA_KEY" 4096

echo "Generating CA certificate..."
openssl req -new -x509 -days $VALIDITY_DAYS -key "$CA_KEY" -out "$CA_CERT" \
    -subj "/C=US/ST=State/L=City/O=GOST MITM Research/OU=Research/CN=GOST CA"

chmod 600 "$CA_KEY"
chmod 644 "$CA_CERT"

echo ""
echo "✅ CA certificates generated successfully!"
echo "  Key:  $CA_KEY"
echo "  Cert: $CA_CERT"
echo ""
echo "To trust this CA, import $CA_CERT into your browser/system."
echo ""