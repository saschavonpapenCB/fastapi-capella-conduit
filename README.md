# ![RealWorld Example App](logo.png)

> ### [FastAPI](https://github.com/tiangolo/fastapi) + Couchbase Capella codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld) spec and API.


### [Demo](https://demo.realworld.io/)&nbsp;&nbsp;&nbsp;&nbsp;[RealWorld](https://github.com/gothinkster/realworld)


This codebase was created to demonstrate a fully fledged fullstack application built with [FastAPI](https://github.com/tiangolo/fastapi) + Couchbase Capella including CRUD operations, authentication, routing, pagination, and more.

The [frontend] (https://github.com/AndyT2503/angular-conduit-signals), developed by another contributor, has been imported as a submodule to illustrate interactions and modularity between the frontend and backend.

For more information on how to this works with other frontends/backends, head over to the [RealWorld](https://github.com/gothinkster/realworld) repository.

---

# Conduit API with FastAPI and Couchbase Capella

## Table of Contents
- [Introduction to RealWorld](#introduction-to-realworld)
- [Introduction to Capella](#introductionCapella)
- [Project Outline](#projectoutline)
- [Stage 1: Developing Conduit API with FastAPI and Capella](#stageone)
- [Stage 2: Integrating Frontend for Full-stack Conduit with Cypress E2E Testing Suite](#stagetwo)
- [Stage 3: Containerizing Conduit with Docker](#stagethree)
- [Stage 4: Infrastructure Automation with Terraform and Conduit Deployment to AWS](#stagefour)
- [Summary](#summary)

## Introduction to RealWorld
[RealWorld](https://realworld-docs.netlify.app/) is an open-source project that acts as a [Rosetta Stone](https://en.wikipedia.org/wiki/Rosetta_Stone) of web-framework implementations of an app named Conduit (click here for [demo](https://demo.realworld.io/#/)). Conduit is a clone of the blogging platform medium.com and is a simple yet robust web app that includes:
- Querying and persisting data to a database
- An authentication system
- Session management
- Full CRUD for resources
- Relational features like following, liking and commenting.

Conduit is divided into three subprojects: an API, a frontend, and a mobile app. This separation streamlines management and scaling, enabling teams to develop each part independently without overlapping. RealWorld supports this by offering [specs and testing resources](https://realworld-docs.netlify.app/docs/intro), allowing for Test-Driven Development (TDD) to ensure all components meet the required standards.

The modular nature of Conduit allows for easy swapping of [different implementations](https://codebase.show/projects/realworld), regardless of the web framework used, providing developers the flexibility to experiment with various technologies while maintaining functionality.

## Introduction to Capella
[Capella](https://www.couchbase.com/products/capella/) is Couchbase's cloud database-as-a-service (DBaaS) offering. It combines the flexibility and performance of Couchbase’s NoSQL database with the ease of a fully managed cloud service. Capella simplifies database management by automating tasks such as scaling, backups, and maintenance, allowing developers to focus on building and optimizing their applications. With Capella, Conduit benefits from high performance and scalability, supporting its features and operations effortlessly.

## Project Outline
This project was developed over four stages:

### Stage 1: Developing Conduit API with FastAPI and Capella
In Stage 1, a functional REST API for Conduit was developed using the Python web framework [FastAPI](https://fastapi.tiangolo.com/) and Capella. The API was built adhering to TDD principles within a development environment. A Continuous Integration (CI) pipeline was set up using GitHub Actions and run locally with [Act](https://github.com/nektos/act) to test the API against various testing suites, primarily focusing on RealWorld's backend specifications from a [Postman collection](https://github.com/gothinkster/realworld/tree/main/api).

### Stage 2: Integrating Frontend for Full-Stack Conduit with Cypress E2E Testing Suite
Stage 2 involved selecting an existing Conduit frontend from the [open-source codebase](https://codebase.show/projects/realworld) and integrating it with the API in the development environment. This integration resulted in a functional full-stack application. An end-to-end (E2E) testing suite was then built using [Cypress](https://www.cypress.io/) and incorporated into the now expanded CI pipeline.

### Stage 3: Containerizing Conduit with Docker
In Stage 3, the API, frontend, and testing suite were containerized using [Docker](https://www.docker.com/). These containers were then orchestrated within a [Docker Compose](https://www.docker.com/) setup. This smaller stage is in preparation for stage 4.

### Stage 4: Infrastructure Automation with Terraform and Conduit Deployment to AWS
Stage 4 automates infrastructure setup and deployment of the Conduit application to AWS, establishing Staging and Production environments with two new locally-run workflows:
- The Continuous Deployment (CD) pipeline for automatic updates.
- The Teardown (TD) pipeline for efficient resource cleanup.
The Staging environment serves as a deployment testing ground, using the CD pipeline to deploy the application and run CI tests. Once validated, the Production environment follows the same process to deploy the application for end users. The CD pipeline, using [Terraform](https://www.terraform.io/) and [Couchbase Shell](https://couchbase.sh/), provisions necessary AWS and Capella resources. Docker builds, tags, and pushes Conduit images to [Amazon Elastic Container Registry (ECR)](https://aws.amazon.com/ecr/), which [Amazon Elastic Container Service (ECS)](https://aws.amazon.com/ecs/) then pulls to update running containers, keeping deployments current. Finally, the TD pipeline dismantles infrastructure when deployments are ended, deprovisioning AWS and Capella resources efficiently.

## Prerequisites

To run this prebuilt project, you will need:

- [Couchbase Capella](https://www.couchbase.com/products/capella/) cluster with a bucket and scope loaded.
- [Python](https://www.python.org/downloads/) 3.9 or higher installed
  - Ensure that the Python version is [compatible](https://docs.couchbase.com/python-sdk/current/project-docs/compatibility.html#python-version-compat) with the Couchbase SDK.
- Clone the repository.
```
git clone https://github.com/couchbase-examples/python-quickstart-fastapi.git
```

This project can be deployed locally, containerised locally or containerised remotely (AWS):

# Local Deployment

### Install Dependencies

The dependencies for the application are specified in the `requirements.txt` file in the root folder. Dependencies can be installed through `pip` the default package manager for Python.
```
sh ./scripts/install-dependencies.sh
```
> Note: If your Python is not symbolically linked to python3, you need to run all commands using `python3` instead of `python`.

### Manual Database Configuration Setup

To know more about connecting to your Capella cluster, please follow the [instructions](https://docs.couchbase.com/cloud/get-started/connect.html).

Specifically, you need to do the following:

- Create the [database credentials](https://docs.couchbase.com/cloud/clusters/manage-database-users.html) to access the travel-sample bucket (Read and Write) used in the application.
- [Allow access](https://docs.couchbase.com/cloud/clusters/allow-ip-address.html) to the Cluster from the IP on which the application is running.

All configuration for communication with the database is read from the environment variables. We have provided a convenience feature to read the environment variables from a local file, `.env` in the source folder.

Create a copy of `.env.example` in the app folder & rename it to `.env` add the values for the Couchbase connection.

> Note: Files starting with `.` could be hidden in the file manager in your Unix based systems including GNU/Linux and Mac OS.

```sh
DB_CONN_STR=<connection_string>
DB_USERNAME=<user_with_read_write_permission_to_travel-sample_bucket>
DB_PASSWORD=<password_for_user>
DB_BUCKET_NAME=<bucket_name>
DB_SCOPE_NAME=<scope_name>
```

> Note: The connection string expects the `couchbases://` or `couchbase://` part.

### Setup JWT Token Configureation

Create a random secret key that will be used to sign the JWT tokens.

To generate a secure random secret key use the command:

```
./scripts/generate-secret-key.sh
```

And copy the output to the JWT_SECRET environment variable in the .env file.

> Note: The CORS_ALLOWED_ORIGINS, CORS_ALLOWED_METHODS and CORS_ALLOWED_HEADERS environment variables can be left blank unless specific CORS options are required.


## Running The API

### Directly on Machine

At this point, we have installed the dependencies, setup the cluster and configured the API with the credentials. The API is now ready and you can run it.

```
./scripts/start-api.sh
```

### Using Docker

- Build the Docker image

```sh
./scripts/build-container.sh
```

- Run the Docker image

```sh
./scripts/run-container.sh
```

> Note: The `.env` file has the connection information to connect to your Capella cluster. These will be part of the environment variables in the Docker container.


## Running Tests

To run RealWorld API tests, use the following command:

```
./scripts/realworld-test.sh
```

To run tests, use the following command:

```
./scripts/pytest-test.sh
```
