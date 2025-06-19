# helm-demo

```sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/jyasuu/helm-demo/refs/heads/main/install.sh | bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm search repo bitnami
helm install bitnami/mysql --generate-name
helm list
helm status mysql-1612624192
helm uninstall mysql-1612624192
```
---

## 📚 Resources

| Resource | Description |
|----------|-------------|
| [🎮 Kubernetes Playground](https://killercoda.com/playgrounds/scenario/kubernetes) | Interactive learning environment |

