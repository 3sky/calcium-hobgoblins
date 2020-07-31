#!/bin/bash

set -e

TAG=$1
APP_NAME=$2

echo "change appVersion in Chart.yaml"

sed -i -E "s/^appVersion: (.*)/appVersion: $TAG/" ./helm-chart/$APP_NAME/Chart.yaml       

echo "upgrade release"

helm upgrade release-$APP_NAME ./helm-chart/$APP_NAME

echo "finish"
