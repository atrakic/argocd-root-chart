# argocd-bootstrap

[![ci](https://github.com/atrakic/argocd-bootstrap/workflows/ci/badge.svg)](https://github.com/atrakic/argocd-bootstrap/actions)
[![license](https://img.shields.io/github/license/atrakic/argocd-bootstrap.svg)](https://github.com/atrakic/argocd-bootstrap/blob/main/LICENSE)

> This is an start up repository for ArgoCD.
> It contains a Helm chart using the [app-of-apps-pattern](https://argo-cd.readthedocs.io/en/stable/operator-manual/cluster-bootstrapping/#app-of-apps-pattern).
> The goal is to setup a production like set of workloads ( ingress, database, monitoring, etc ).

#### Prerequisites

- Kubernetes cluster
- Setup argoCD

```bash
# install ArgoCD in k8s
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# access ArgoCD UI
kubectl get svc -n argocd
kubectl port-forward svc/argocd-server 8080:443 -n argocd &

# login with admin user and below token (as in documentation):
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode && echo
```

### Usage
- Add this repository as a bootstrap cluster
```
kubectl apply -f https://raw.githubusercontent.com/atrakic/argocd-bootstrap/refs/heads/main/argocd/bootstrap.yaml
```
</br>


### Custom values
Check `values.yaml` and adjust as required

#### References

* Install ArgoCD: [https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd](https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd)
* Login to ArgoCD: [https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli](https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli)
* ArgoCD Configuration: [https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/)
