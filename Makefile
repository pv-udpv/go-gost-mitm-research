.PHONY: help build test clean install

BINARY_NAME=gost
BUILD_DIR=bin
GOST_DIR=modules/gost
CERT_DIR=certs
CONFIG_DIR=configs

# Detect OS and architecture
GOOS=$(shell go env GOOS)
GOARCH=$(shell go env GOARCH)
BINARY_PATH=$(BUILD_DIR)/$(BINARY_NAME)-$(GOOS)-$(GOARCH)

help: ## Show this help
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \\033[36m%-20s\\033[0m %s\\n", $$1, $$2}'

deps: ## Install dependencies
	@echo "Installing Go dependencies..."
	cd $(GOST_DIR) && go mod download
	cd $(GOST_DIR) && go mod tidy

init-submodules: ## Initialize git submodules
	@echo "Initializing submodules..."
	git submodule init modules/gost modules/x
	git submodule update --init --remote modules/gost modules/x

build: init-submodules deps ## Build GOST for current platform
	@echo "Building GOST for $(GOOS)/$(GOARCH)..."
	@mkdir -p $(BUILD_DIR)
	cd $(GOST_DIR) && go build -o ../../$(BINARY_PATH) ./cmd/gost
	@echo "Binary created: $(BINARY_PATH)"

generate-certs: ## Generate CA certificates
	@echo "Generating certificates..."
	@./scripts/generate-certs.sh

test: build ## Run all tests
	@echo "Running tests..."
	@./tests/test-basic-proxy.sh

clean: ## Clean build artifacts
	@echo "Cleaning..."
	@rm -rf $(BUILD_DIR)
	@rm -rf $(CERT_DIR)/*.crt $(CERT_DIR)/*.key

run-chrome: build generate-certs ## Run MITM with Chrome profile
	@echo "Starting MITM proxy with Chrome profile..."
	@$(BINARY_PATH) -C $(CONFIG_DIR)/mitm-chrome-profile.yml

.DEFAULT_GOAL := help