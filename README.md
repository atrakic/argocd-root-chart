# argocd-root-chart

[![ci](https://github.com/atrakic/argocd-root-chart/workflows/ci/badge.svg)](https://github.com/atrakic/argocd-root-chart/actions)
[![license](https://img.shields.io/github/license/atrakic/argocd-root-chart.svg)](https://github.com/atrakic/argocd-root-chart/blob/main/LICENSE)

#### Commands

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
</br>


## ArgoCD deployments

```
kubectl get Application -n argocd
NAME                         SYNC STATUS   HEALTH STATUS
bootstrap                    Synced        Healthy
cert-manager                 Synced        Healthy
infra                        Synced        Healthy
kube-prometheus-stack-crds   Synced        Healthy
monitoring                   Synced        Healthy
```

#### Links

* Install ArgoCD: [https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd](https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd)
* Login to ArgoCD: [https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli](https://argo-cd.readthedocs.io/en/stable/getting_started/#4-login-using-the-cli)
* ArgoCD Configuration: [https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/](https://argo-cd.readthedocs.io/en/stable/operator-manual/declarative-setup/)
