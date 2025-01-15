#!/bin/bash

docker build -t conduit-cypress -f ./angular-conduit-signals/cypress/Dockerfile.cypress angular-conduit-signals
