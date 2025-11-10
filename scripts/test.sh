#!/usr/bin/env bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

test_pass() {
    ((TESTS_PASSED++))
    ((TESTS_RUN++))
    echo -e "${GREEN}✓${NC} $1"
}

test_fail() {
    ((TESTS_FAILED++))
    ((TESTS_RUN++))
    echo -e "${RED}✗${NC} $1"
}

# Test functions
test_helm_lint() {
    log_info "Running Helm lint..."
    if helm lint . --quiet; then
        test_pass "Helm lint passed"
    else
        test_fail "Helm lint failed"
        return 1
    fi
}

test_helm_template() {
    log_info "Running Helm template..."
    if helm template test . > /dev/null 2>&1; then
        test_pass "Helm template (default values) passed"
    else
        test_fail "Helm template (default values) failed"
        return 1
    fi
}

test_helm_template_ci() {
    log_info "Running Helm template with CI values..."
    if helm template test . -f ci/ci-values.yaml > /dev/null 2>&1; then
        test_pass "Helm template (CI values) passed"
    else
        test_fail "Helm template (CI values) failed"
        return 1
    fi
}

test_chart_yaml() {
    log_info "Validating Chart.yaml..."
    if [[ -f "Chart.yaml" ]]; then
        if grep -q "^version:" Chart.yaml && grep -q "^name:" Chart.yaml; then
            test_pass "Chart.yaml is valid"
        else
            test_fail "Chart.yaml is missing required fields"
            return 1
        fi
    else
        test_fail "Chart.yaml not found"
        return 1
    fi
}

test_values_yaml() {
    log_info "Validating values.yaml..."
    if [[ -f "values.yaml" ]]; then
        test_pass "values.yaml exists"
    else
        test_fail "values.yaml not found"
        return 1
    fi
}

test_templates_exist() {
    log_info "Checking templates directory..."
    if [[ -d "templates" ]]; then
        local template_count=$(find templates -name "*.yaml" | wc -l)
        if [[ $template_count -gt 0 ]]; then
            test_pass "Found $template_count template files"
        else
            test_warn "No template files found"
        fi
    else
        test_fail "templates directory not found"
        return 1
    fi
}

# Main test execution
main() {
    log_info "Starting tests for argocd-root-chart..."
    echo ""

    # Run all tests
    test_chart_yaml || true
    test_values_yaml || true
    test_templates_exist || true
    test_helm_lint || true
    test_helm_template || true
    test_helm_template_ci || true

    # Summary
    echo ""
    echo "========================================="
    echo "Test Summary:"
    echo "  Total:  $TESTS_RUN"
    echo "  Passed: $TESTS_PASSED"
    echo "  Failed: $TESTS_FAILED"
    echo "========================================="

    if [[ $TESTS_FAILED -gt 0 ]]; then
        log_error "Some tests failed!"
        exit 1
    else
        log_info "All tests passed!"
        exit 0
    fi
}

main "$@"
