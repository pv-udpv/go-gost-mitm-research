#!/bin/bash
set -e

echo "🔧 Setting up GOST MITM Research environment..."

# Check prerequisites
command -v git >/dev/null 2>&1 || { echo "❌ git is required"; exit 1; }
command -v go >/dev/null 2>&1 || { echo "❌ Go 1.21+ is required"; exit 1; }
command -v make >/dev/null 2>&1 || { echo "❌ make is required"; exit 1; }

GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
GO_MAJOR=$(echo $GO_VERSION | cut -d. -f1)
GO_MINOR=$(echo $GO_VERSION | cut -d. -f2)

if [ "$GO_MAJOR" -lt 1 ] || ([ "$GO_MAJOR" -eq 1 ] && [ "$GO_MINOR" -lt 21 ]); then
    echo "❌ Go 1.21 or later is required (found $GO_VERSION)"
    exit 1
fi

echo "✅ Prerequisites check passed"

echo "📦 Initializing git submodules..."
make init-submodules

echo "📁 Creating directory structure..."
mkdir -p bin certs/ca logs profiles/custom-profiles research/results
touch certs/.gitkeep logs/.gitkeep

echo "📥 Installing Go dependencies..."
make deps

echo "🔐 Setting permissions..."
chmod +x scripts/*.sh 2>/dev/null || true
chmod +x tests/*.sh 2>/dev/null || true

if [ ! -f configs/production.yml ]; then
    cp configs/production.yml.example configs/production.yml
    echo "📝 Created configs/production.yml from example"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "  1. Generate certificates:  ./scripts/generate-certs.sh"
echo "  2. Build GOST:            make build"
echo "  3. Run MITM proxy:        make run-chrome"
echo ""