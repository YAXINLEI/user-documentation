#!/bin/bash
set -e

echo "** Installing ElasticBeanstalk CLI..."
export PYTHONPATH="$(mktemp -d)"
pip install \
  "--target=${PYTHONPATH}" \
  "--install-option=--install-scripts=${PYTHONPATH}/bin" \
  awsebcli
export PATH="${PYTHONPATH}/bin:${PATH}"

echo "** Logging in to dockerhub..."
echo "${DOCKERHUB_PASSWORD}" | docker login -u "${DOCKERHUB_USER}" \
  --password-stdin
echo "** Setting up ElasticBeanstalk..."
# Select an application to use: 1) hhvm-hack-docs
# Select the default environment: 1) ... doesn't matter, managed by script
# Do you want to continue with CodeCommit? n
echo -e "1\n1\nn\n" | eb init -r us-west-2
echo "** Launching deploy script..."
bin/deploy-to-staging.sh
# deploy-to-staging ends with running the unit tests remotely
echo "** Swapping prod and staging..."
eb swap
