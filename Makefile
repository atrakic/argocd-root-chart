MAKEFLAGS += --silent
VALUES ?= values.yaml
APP := $(notdir $(CURDIR))

template:
	helm template -f $(VALUES) .

lint:
	helm lint .

install: lint ## Install
	helm upgrade --install $(APP) -f $(VALUES) .
	helm list -A --all

uninstall: # Uninstall helm
	helm uninstall $(APP)

status:
	kubectl get Application -n argocd

-include include.mk
