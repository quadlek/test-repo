#!/bin/bash
set -xe

# You have to set these ENV variables to your CI/CD:
# BATON_TOKEN - your github access token
# BATON_ORGS - your github organization(s) separated by comma
# AWS_ACCESS_KEY_ID - your AWS access key
# AWS_SECRET_ACCESS_KEY - your AWS secret access key
# AWS_REGION - your AWS bucket region
# AWS_BUCKET - your AWS bucket name

# Set the output filenames
now=$(date +"%Y%m%d%H%M%S")
s3bucket="s3://jirwin-sdk-test"
c1zFile="$s3bucket/scheduled-sync.c1z"
csvFile="$s3bucket/sync-github-$now.csv"
xlsxFile="$s3bucket/sync-github-$now.xlsx"

# Pull the containers to ensure we have access
docker pull ghcr.io/conductorone/baton:latest
docker pull ghcr.io/conductorone/baton-github:latest

# Run sync to produce c1z
docker run -e BATON_TOKEN -e BATON_ORGS -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_REGION -e AWS_BUCKET ghcr.io/conductorone/baton-github:latest -f "$c1zFile"

# Run a diff
docker run -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_REGION -e AWS_BUCKET  ghcr.io/conductorone/baton:latest -f "$c1zFile" diff