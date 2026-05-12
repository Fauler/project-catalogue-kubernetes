# project-catalogue-kubernetes

Helm charts for deploying project-catalogue services into Kubernetes.

Cluster setup and platform components live in `project-catalogue-infra`.

## Structure

```
auth-service/                  # port 8083, no database
  Chart.yaml
  values-dev.yaml
  values-prod.yaml
  templates/
    configmap.yaml
    deployment.yaml
    secret.yaml
    service-account.yaml
    service-monitor.yaml
    service.yaml

user-service/                  # port 8081, PostgreSQL (dev_user_db / prod_user_db)
  ...same structure...

project-service/               # port 8082, PostgreSQL (dev_project_db / prod_project_db)
  ...same structure...
```

Each chart has per-environment values files. No shared `values.yaml` — each file is self-contained.

## Build and load images

Images are built locally and loaded into the Kind cluster — no registry involved.

```bash
cd /path/to/project-catalogue

docker build -t project-catalogue-auth-service:latest -f infrastructure/docker/auth-service/Dockerfile .
docker build -t project-catalogue-user-service:latest -f infrastructure/docker/user-service/Dockerfile .
docker build -t project-catalogue-project-service:latest -f infrastructure/docker/project-service/Dockerfile .

kind load docker-image project-catalogue-auth-service:latest --name project-catalogue-cluster
kind load docker-image project-catalogue-user-service:latest --name project-catalogue-cluster
kind load docker-image project-catalogue-project-service:latest --name project-catalogue-cluster
```

After changing application code, rebuild the image and load it again:

```bash
docker build -t project-catalogue-user-service:latest -f infrastructure/docker/user-service/Dockerfile .
kind load docker-image project-catalogue-user-service:latest --name project-catalogue-cluster
kubectl rollout restart deployment user-service -n catalogue-dev
```

Recreating the cluster requires loading all images again (build step can be skipped if images still exist locally).
