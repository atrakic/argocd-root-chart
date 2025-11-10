# Testing Guide

This document describes how to test the argocd-root-chart locally and in CI.

## Prerequisites

- Helm 3.12+
- kubectl (for integration tests)
- kind (for local Kubernetes cluster testing)

## Local Testing

### Quick Tests

Run basic linting and template validation:

```bash
# Run Helm lint
make lint

# Generate templates with default values
make template

# Run quick tests with CI values
make test
```

### Comprehensive Testing

Run the full test suite:

```bash
# Run all tests
make test-all
```

This will execute:
- Chart.yaml validation
- values.yaml validation
- Template file checks
- Helm lint
- Template generation with default values
- Template generation with CI values

### Manual Testing

You can also run individual Helm commands:

```bash
# Lint the chart
helm lint .

# Generate templates
helm template test .

# Generate templates with CI values
helm template test . -f ci/ci-values.yaml

# Dry-run installation
helm install test . --dry-run --debug
```

## CI Testing

The CI pipeline runs automatically on every push and pull request. It consists of two jobs:

### 1. Lint Job

- Checks out the code
- Sets up Helm and Python
- Runs Helm lint
- Uses chart-testing to validate changed charts

### 2. Test Job

- Creates a kind cluster
- Installs ArgoCD
- Runs chart-testing install
- Deploys the root chart with CI values
- Verifies ArgoCD applications are created
- Validates application health status

### CI Configuration

CI behavior is controlled by:
- `.github/workflows/ci.yaml` - GitHub Actions workflow
- `ct.yaml` - chart-testing configuration
- `ci/ci-values.yaml` - Test values for CI

### Testing Locally with Kind

To replicate the CI environment locally:

```bash
# Create a kind cluster
kind create cluster --name argocd-test

# Install ArgoCD
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
kubectl create namespace argocd
helm install argocd argo/argo-cd \
  --namespace argocd \
  --set global.domain=argocd.local \
  --set server.service.type=ClusterIP \
  --set dex.enabled=false \
  --set notifications.enabled=false \
  --set applicationSet.enabled=false \
  --set server.extraArgs[0]="--insecure" \
  --wait --timeout=10m

# Install the root chart
helm install test-argocd-root . \
  --namespace argocd \
  --values ci/ci-values.yaml \
  --wait --timeout=5m

# Verify applications
kubectl get applications -n argocd

# Cleanup
kind delete cluster --name argocd-test
```

## Test Configuration

### CI Values

The `ci/ci-values.yaml` file contains minimal configuration for CI testing:
- Only enables `ingress-nginx` for faster testing
- Disables heavy components like monitoring stack
- Uses stable chart versions
- Disables admission webhooks to simplify testing

### Chart Testing Config

The `ct.yaml` file configures chart-testing behavior:
- Increases timeout to 800s for complex charts
- Skips version increment checks (handled by Renovate)
- Validates chart schema and YAML syntax

## Troubleshooting

### Common Issues

1. **Timeout errors**: Increase timeout values in `ct.yaml` or workflow
2. **ArgoCD not ready**: Check pod status with `kubectl get pods -n argocd`
3. **Application not created**: Verify values in `ci/ci-values.yaml`

### Debug Mode

Enable debug output in CI by modifying the workflow:

```yaml
- name: Run chart-testing install
  run: ct install --config ct.yaml --debug
```

### Viewing Logs

If tests fail, check the "Debug on failure" step in the CI workflow output for:
- ArgoCD pod status
- Application details
- Server logs
- Controller logs
