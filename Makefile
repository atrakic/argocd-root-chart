MAKEFLAGS += --silent
VALUES ?= values.yaml
APP := $(notdir $(CURDIR))

.PHONY: help
help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-20s %s\n", $$1, $$2}'

.PHONY: lint
lint: ## Run Helm lint
	helm lint --quiet .

.PHONY: template
template: lint ## Generate Helm templates
	helm template -f $(VALUES) .

.PHONY: test
test: lint ## Run local tests with CI values
	@echo "Testing with CI values..."
	helm template -f ci/ci-values.yaml . > /dev/null
	@echo "✓ Template generation successful"

.PHONY: test-all
test-all: ## Run comprehensive test suite
	./scripts/test.sh

.PHONY: helm-install
helm-install: lint ## Install the chart
	helm upgrade --install $(APP) -f $(VALUES) .
	helm list -A --all

.PHONY: helm-uninstall
helm-uninstall: ## Uninstall the chart
	helm uninstall $(APP)

.PHONY: status
status: ## Show ArgoCD application status
	kubectl get Application -n argocd

-include include.mk
