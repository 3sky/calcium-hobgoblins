TERRAFORM='/usr/local/bin/terraform'
PATH='path=~/.gcp/creeping-hobgoblins.json'
CLUSTER_NAME='my-gke-cluster'
ZONE_NAME='europe-west3-a'

GOBIN=/usr/bin/go
GOTEST=$(GOBIN) test 
GORUN=$(GOBIN) run 

DOCKER=/usr/bin/docker

up:
	cd infra/DEV && $(TERRAFORM) apply -var=$(PATH)

auth:
	$(shell gcloud container clusters get-credentials $(CLUSTER_NAME) --zone $(ZONE_NAME))

down:
	cd infra/DEV && $(TERRAFORM) destroy -var=$(PATH)

test:
	cd app && $(GOTEST) -v ./...

run:
	cd app && $(GORUN) ./...

build:
	$(DOCKER) build -f app/Dockerfile app
