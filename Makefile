TERRAFORM='/usr/local/bin/terraform'

PATH='path=~/.gcp/creeping-hobgoblins.json'
CLUSTER_NAME='my-gke-cluster'
ZONE_NAME='europe-west3-a'


up:
	cd infra/DEV && $(TERRAFORM) apply -var=$(PATH)

auth:
	$(shell gcloud container clusters get-credentials $(CLUSTER_NAME) --zone $(ZONE_NAME))

down:
	cd infra/DEV && $(TERRAFORM) destroy -var=$(PATH)
