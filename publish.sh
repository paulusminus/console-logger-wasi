#!/bin/sh

METADATA=$(cargo metadata --format-version 1 --no-deps | jq -c '.packages[0]')
DESCRIPTION=$(echo $METADATA | jq -r '.description')
LICENSE=$(echo $METADATA | jq -r '.license')
NAME=$(echo $METADATA | jq -r '.name')
SOURCE=$(echo $METADATA | jq -r '.repository')
VERSION=$(echo $METADATA | jq -r '.version')

OCI_REGISTRY=$(echo $METADATA | jq -r '.metadata.oci.registry')
OCI_NAME=$(echo $METADATA | jq -r '.metadata.oci.name')
OCI_NAMESPACE=$(echo $METADATA | jq -r '.metadata.oci.namespace')
IMAGE=$OCI_REGISTRY/$OCI_NAMESPACE/$OCI_NAME:$VERSION

echo "Pushing $IMAGE"
echo "Name: $NAME"
echo "Version: $VERSION"

wkg oci push \
  -a "Paul Min" \
  --annotation org.opencontainers.image.description="$DESCRIPTION" \
  --annotation org.opencontainers.image.licenses="$LICENSE" \
  --annotation org.opencontainers.image.source="$SOURCE" \
  --annotation org.opencontainers.image.version="$VERSION" \
  $IMAGE \
  target/wasm32-wasip2/release/$NAME.wasm
