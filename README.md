# helm-demo

This project provides a Helm chart for a full stack of applications, including NGINX, whoami, PostgreSQL, PostgREST, and pgAdmin.

## Prerequisites

- A running Kubernetes cluster.
- `kubectl` configured to connect to your cluster.

### Cluster Prerequisites

Before deploying the application, your cluster must have the following components installed:

1.  **ArgoCD:** The GitOps engine that manages the deployment.
2.  **An Ingress Controller:** To expose the web applications to the outside world.

The `install.sh` script will automatically install both ArgoCD and the NGINX Ingress Controller on your cluster.

You can use the main `install.sh` script to install the other required tools (like Helm and the ArgoCD CLI).

```sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/jyasuu/helm-demo/refs/heads/main/install.sh | bash
```

## Helm Chart

The Helm chart is located in the `helm-demo-stack` directory. It deploys the following applications:

- **my-app:** A simple NGINX application.
- **whoami:** A simple service that returns container information.
- **postgresql:** A PostgreSQL database.
- **postgrest:** A REST API for PostgreSQL.
- **pgadmin:** A web-based administration tool for PostgreSQL.

### Usage

To install the chart, run the following command:

```sh
helm install my-stack ./helm-demo-stack
```

To uninstall the chart, run the following command:

```sh
helm uninstall my-stack
```

## ArgoCD Integration (GitOps Workflow)

This project is designed to be deployed and managed using ArgoCD following GitOps principles. The Git repository is the single source of truth.

### How It Works

1.  **Commit to Git:** All of your application definitions (the `helm-demo-stack` Helm chart) and the ArgoCD application manifest (`argocd-application.yaml`) live in this Git repository.
2.  **Apply the Manifest:** You apply the `argocd-application.yaml` manifest to your cluster once. This tells ArgoCD to start watching your repository.
3.  **ArgoCD Syncs:** ArgoCD automatically deploys your Helm chart.
4.  **Update via Git:** To make any change (e.g., update an application's version, change a config), you simply modify the files in your repository (like `values.yaml`) and push the commit. ArgoCD will detect the change and automatically update your cluster.

### Usage

1.  **Push to Your Repository:** Ensure all the project files are committed and pushed to your own Git repository (e.g., on GitHub).

2.  **Update the Repository URL:** **Crucially, you must edit `argocd-application.yaml`** and change the `repoURL` to point to your Git repository.

3.  **Apply the Application Manifest:**
    ```sh
    kubectl apply -f argocd-application.yaml
    ```

4.  **Verify in ArgoCD:** You can now view and manage the application from the ArgoCD UI or CLI.
    ```sh
    # Check status from the CLI
    argocd app get helm-demo-stack
    ```


## 📚 Resources

| Resource | Description |
|----------|-------------|
| [🎮 Kubernetes Playground](https://killercoda.com/playgrounds/scenario/kubernetes) | Interactive learning environment |

