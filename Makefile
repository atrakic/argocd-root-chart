MAKEFLAGS += --silent
VALUES ?= values.yaml
APP := $(notdir $(CURDIR))

template: lint
	helm template -f $(VALUES) .

lint:
	helm lint --quiet .

install:
	kubectl apply -f bootstrap.yaml --force

helm-install: lint ## Install
	helm upgrade --install $(APP) -f $(VALUES) .
	helm list -A --all

helm-uninstall: # Uninstall helm
	helm uninstall $(APP)

status:
	kubectl get applicationsets --namespace argocd
	kubectl get applications --namespace argocd

-include include.mk
