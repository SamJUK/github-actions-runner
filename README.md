# Github Actions Runner

This project handles dockerizing the Github Action Runner with registration and cleanup logic.

Adding the ability for simple manual and autoscaling via Docker / Docker Swarm

A sibling project with the same approach for Bitbucket Pipeline Runners can be found at https://github.com/SamJUK/bitbucket-pipeline-runner

Based from https://testdriven.io/blog/github-actions-docker/

## Usage

The container requires two environment variables to be set. 

VAR | Purpose | Example
--- | --- | ---
`ORGANIZATION` | GH Organization name to deploy the runners within | `acme`
`ACCESS_TOKEN` | Github PAT Token with `repo` and `org:repo` scopes | `ghp_xxxxxxx`


### Docker run
```sh
docker run -e ORGANIZATION=acme -e ACCESS_TOKEN=ghp_xxxxxxx samjuk/github-actions-runner:latest
```

### Docker Compose
```yaml
services:
  runner:
    image: samjuk/github-action/runner:latest
    environment:
      ORGANIZATION: acme
      ACCESS_TOKEN: ghp_xxxxx
```

### K8s
```yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: gha-runner
  namespace: default
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: runner
          image: samjuk/github-action-runner:latest
          imagePullPolicy: IfNotPresent
          env:
            - name: ORGANIZATION
              value: acme
            - name: ACCESS_TOKEN
              value: ghp_xxxx
```