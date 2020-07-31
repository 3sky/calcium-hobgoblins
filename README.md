# Go app on Kubernetes from Scrach

## Buiild the app

1. Create directory for app and infra part

    ```bash
    mkdir -pv app infra
    ```

1. Go to app directory and init app

    ```bash
    cd app
    $ cat <<EOF > main.go
    package main
    import "fmt"
    func main() {
       fmt.Println("vim-go")
    }
    EOF
    ```

1. Init go mod

    ```bash
    go mod init 3sky/k8s-app
    ```

1. Write code

I decided to use [Echo][1] framework, I like it, it's fast
and logger is easy to use. \

App has two endpoint:

- `/` - which return `Hello World!`
- '/status' - which retrun app status = `OK`

1. Download depedences

    ```bash
    go mod tidy
    ```

1. Run the code

    ```bash
    go run main.go
    ```

1. Add some basic tests and run tests

    ```bash
    go test ./...
    ```

## Containerization

1. Create Dockerfile

    ```bash
    touch Dockerfile
    ```

1. Build image

    ```bash
    docker build -t k8s-app .
    ```

1. Run image

    ```bash
    docker run -d -p 8080:1323 k8s-app:latest
    ```

1. Run basic `curl`'s test

    ```bash
    curl -s localhost:8080/status | jq .
    curl -s localhost:8080 | jq .
    ```

## Configure GCP

1. Auth into GCP

    ```bash
    gcloud auth login
    ```

1. Create new project

    ```bash
    gcloud projects create [PROJECT_ID] --enable-cloud-apis

    # --enable-cloud-apis
    # enable cloudapis.googleapis.com during creation
    # example
    # gcloud projects create creeping-hobgoblins --enable-cloud-apis
    ```

1. Check existing projects

    ```bash
    gcloud projects list
    PROJECT_ID               NAME                     PROJECT_NUMBER
    creeping-hobgoblins      creeping-hobgoblins      xxxx
    ```

1. Set `gcloud` project

    ```bash
    gcloud config set project creeping-hobgoblins
    ```

1. Create a service account and add necessary permission

    ```bash
    gcloud iam service-accounts create hobgoblins-service-user \
    --description "Service user for GKE and GitHub Action" \
    --display-name "hobgoblins-service-user"

    gcloud projects add-iam-policy-binding creeping-hobgoblins --member \
    serviceAccount:hobgoblins-service-user@creeping-hobgoblins.iam.gserviceaccount.com \
    --role roles/compute.admin

    gcloud projects add-iam-policy-binding creeping-hobgoblins --member \
    serviceAccount:hobgoblins-service-user@creeping-hobgoblins.iam.gserviceaccount.com \
    --role roles/storage.admin

    gcloud projects add-iam-policy-binding creeping-hobgoblins --member \
    serviceAccount:hobgoblins-service-user@creeping-hobgoblins.iam.gserviceaccount.com \
    --role roles/container.admin

    gcloud projects add-iam-policy-binding creeping-hobgoblins --member \
    serviceAccount:hobgoblins-service-user@creeping-hobgoblins.iam.gserviceaccount.com \
    --role roles/iam.serviceAccountUser
    ```

1. List permissioncreeping-hobgoblins

    ```bash
    gcloud projects get-iam-policy creeping-hobgoblins  \
    --flatten="bindings[].members" \
    --format='table(bindings.role)' \
    --filter="bindings.members:hobgoblins-service-user@creeping-hobgoblins.iam.gserviceaccount.com"
    ```

## Provide Kubernetes Cluster

1. Create `auth.json` file

    ```bash
    mkdir -pv ~/.gcp
    cloud iam service-accounts keys create ~/.gcp/creeping-hobgoblins.json \                                                                          
    --iam-account hobgoblins-service-user@creeping-hobgoblins.iam.gserviceaccount.com
    ```

1. Create basic directory structure

    ```bash
    cd ../infra
    mkdir -pv DEV Module/GKE
    ```

1. Put Terraform file

    Structure is fallowing:

    ```bash
    .
    ├── DEV
    │   ├── main.tf
    │   └── variables.tf
    └── Module
        └── GKE
            ├── main.tf
            └── variables.tf
    ```

1. Init Terrafrom

    ```bash
    cd DEV
    terraform init
    ```

1. Terraform apply

    ```bash
    terraform apply -var="path=~/.gcp/creeping-hobgoblins.json"
    ```

1. Config `kubectl`

    ```bash
    gcloud container clusters list
    gcloud container clusters get-credentials  my-gke-cluster --zone europe-west3-a
    kubectl get node
    ```

## Preper Helm release

1. Authenticate Docker

    ```bash
    gcloud auth configure-docker
    gcloud auth activate-service-account \
    hobgoblins-service-user@creeping-hobgoblins.iam.gserviceaccount.com \
    --key-file=/home/kuba/.gcp/creeping-hobgoblins.json

    gcloud auth print-access-token | docker login \
    -u oauth2accesstoken \
    --password-stdin https://gcr.io
    ```

1. Push image into gcr.io

    ```bash
    docker tag k8s-app:latest gcr.io/creeping-hobgoblins/k8s-app:0.0.1
    docker push gcr.io/creeping-hobgoblins/k8s-app:0.0.1
    ```

1. Create helm chart

    ```bash
    cd ../..
    mkdir helm-chart
    cd helm-chart
    helm create k8s-app
    ```

## Add GitHub Action Pipeline

1. Add two files

    ```bash
    mkdir -pv .github/workflows
    touch .github/workflows/no-release.yml
    touch .github/workflows/release.yml
    ```

1. Add content to `no-release` file

    This file will execute everytime when code will be pushed to repository.

1. Add content to `release` file

    This file will execute only when pushed code will be taged with `v*` expression.

[1]: https://github.com/labstack/echo

