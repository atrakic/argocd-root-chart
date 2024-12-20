MAKEFLAGS += --silent
VALUES ?= values.debug.yaml
APP := $(notdir $(CURDIR))

template: lint
	helm template -f $(VALUES) .

lint:
	helm lint --quiet .

helm-install: lint ## Install
	helm upgrade --install $(APP) -f $(VALUES) .
	helm list -A --all

helm-uninstall: # Uninstall helm
	helm uninstall $(APP)

status:
	kubectl get Application -n argocd

-include include.mk
