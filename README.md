# ![RealWorld Example App](logo.png)

> ### [FastAPI](https://github.com/tiangolo/fastapi) + Couchbase Capella codebase containing real world examples (CRUD, auth, advanced patterns, etc) that adheres to the [RealWorld](https://github.com/gothinkster/realworld) spec and API.


### [Demo](https://demo.realworld.io/)&nbsp;&nbsp;&nbsp;&nbsp;[RealWorld](https://github.com/gothinkster/realworld)


This codebase was created to demonstrate a fully fledged fullstack application built with [FastAPI](https://github.com/tiangolo/fastapi) + Couchbase Capella including CRUD operations, authentication, routing, pagination, and more.

The frontend ([AndyT2503/angular-conduit-signals](https://github.com/AndyT2503/angular-conduit-signals)), developed by another contributor, has been imported as a submodule to illustrate interactions and modularity between the frontend and backend.

For more information on how to this works with other frontends/backends, head over to the [RealWorld](https://github.com/gothinkster/realworld) repository.
---

# Conduit API with FastAPI and Couchbase Capella

## Table of Contents
- [Introduction to RealWorld](#introduction-to-realworld)
- [Introduction to Capella](#introduction-to-capella)
- [Project Outline](#project-outline)
- [Stage 1: Developing Conduit API with FastAPI and Capella](#stage-1)
- [Stage 2: Integrating Frontend for Full-stack Conduit with Cypress E2E Testing Suite](#stage-2)
- [Stage 3: Containerizing Conduit with Docker](#stage-3)
- [Stage 4: Infrastructure Automation with Terraform and Conduit Deployment to AWS](#stage-4)
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
---
# Stage 1
## Developing Conduit API with FastAPI and Capella
### Preparation
To prepare for this stage, follow these steps:
1. Clone the codebase to a local repo.
2. Install a version of Python [compatible with the Couchbase Python SDK](https://docs.couchbase.com/python-sdk/current/project-docs/compatibility.html#python-version-compat).
3. Create a new Python virtual environment Refer to resources like the [official Python docs](https://docs.python.org/3/library/venv.html#creating-virtual-environments) for guidance.
4. Install Python dependencies. This can be achieved by running this command:
  ```sh
  ./scripts/local/install-api-deps.sh
  ```
5. Create a remote origin repo in GitHub. This will be for executing the CI workflow.
  - Create a remote repo in GitHub and as the local repo’s origin.
  - In `Environments` under `Settings`, create an environment called `development` and leave all of the configurations as default (repository and environment variables and secrets will be added in coming steps).
6. Set up .env file. There are two `.env.example` files in the project, one in the root directory one in the `/api` directory. The one in the root directory is used by the infrastructure described in Stage 4 (wait until then to implement). The one in the `/api` directory is used by the Conduit API and needs to be implemented in this step. The `.env.example` file is an example layout for a `.env` file, which will contain all of the environment variables. This file will be ignored by the `.gitignore` file and keep the `env` variables local, when the API is run in the CI workflow on GitHub, it will use the environment variables defined there (also implemented in later steps).
  - Change the root directory `.env` file name from `.env.example` to `.env`.
  - Leave the CORS variables as is. The remaining variables will be added in coming steps.
7. Configure JWT settings.
  - Create a random secret key that will be used to sign the JWT tokens. To do this open a terminal and run this command:
    ```sh
    ./scripts/local/generate-secret-key.sh
    ```
  - Copy the resulting string into the remote GitHub repo by setting it as a development environment secret called `JWT_SECRET`.
  - Also copy the resulting string into the local `.env` file by setting it as the environment variable also called `JWT_SECRET`.
8. Create a [Capella account](https://cloud.couchbase.com/sign-up).
  - Couchbase offer a free tier version of Capella. If you want to explore Capella, check out it’s [offical docs](https://docs.couchbase.com/cloud/get-started/intro.html).
9. Create and configure a Capella cluster.
  - Under `Operational`, create a new cluster.
  - Select Free Cluster, give it a name, select your CSP preferences and hit `Create Cluster`.
  - Once the Cluster is deployed, go into it. Under `Data Tools` you will find an example data bucket called `travel-sample`. Delete it.
10.	Create and configure a bucket (This will be automated in stage 4).
  - We’re going to create a new bucket. Hit Create and create a new bucket called `conduit_bucket`. You can leave the Memory Quota at 100 MiB. Select `Use system generated _default for scope and collection`. Capella requires these for a bucket to be linkable to App Services.
  - In the remote repo, set `conduit_bucket` as a repository variable called `DB_BUCKET_NAME`.
  - Also in the local .env file, set `conduit_bucket` as the environment variable also called `DB_BUCKET_NAME`.
11.	Create and configure a scope (This will be automated in stage 4).
  - Using the `Create` button, create a scope, `development`, inside `conduit_bucket` and two collections, `article`, `comment` and `user`*, inside of `development`.\
    *Couchbase has a list keywords that are reserved words. `user` is a reserved keyword, this can be escaped by encasing the name in backticks (`).
  - For indexing, open `Query` under `Data Tools`. Run the following queries in the query box: 
    ```sh
    CREATE PRIMARY INDEX ON `default`:`conduit_bucket`.`development`.`article`;
    CREATE PRIMARY INDEX ON `default`:`conduit_bucket`.`development`.`user`;
    CREATE PRIMARY INDEX ON `default`:`conduit_bucket`.`development`.`comment`;
    ```
  - In the remote repo, set `development` as a development environment variable called `DB_SCOPE_NAME`.
  - Also in the local `.env` file, set `development` as the environment variable also called `DB_SCOPE_NAME`.
12. Configure cluster connection.
  - Open `SDKs` under `Connect`.
  - Copy the public connection string to the remote repo, into a repository var `DB_CONN_STR`.
  - Copy the public connection string and add it as `DB_CONN_STR` in the local `.env` file.
  - Follow the `Allowed IP Addresses` link and add an allowed IP. Select `Allow Access From Anywhere`, this whitelists IP `0.0.0.0/0`*.\
    *(We do this to allow the GitHub runners, which work on varying IPs, to access the cluster when running the CI workflow. In Stage 4, we will run the CD workflow on a local runner, allowing for a more fine-tuned whitelist.)
  - Follow the `Database Access` link and create database access credentials.
  - Copy the Database Access Name and Password to the remote repo. Set the Database Access Name as a repository variable called `DB_USERNAME` and the Password as a repository secret called `DB_PASSWORD`.
  - Also copy the Database Access Name and Password to the local .env file. Set the Database Access Name as the environment variable `DB_USERNAME` and the Password as the environment variable `DB_PASSWORD`.
  - The remaining steps shown aren’t necessary for preparing this stage but are worth exploring.
13.	Double check local and remote environment variables:

    |       Local Repo Configuration      |
    |-------------------------------------|
    | **`.env` file:**<br>`DB_CONN_STR` = &lt;capella connection string&gt;<br>`DB_PASSWORD` = &lt;database access password&gt;<br>`DB_USERNAME` = &lt;database access username&gt;<br>`DB_BUCKET_NAME` = `conduit_bucket`<br>`DB_SCOPE_NAME` = `dev`<br>`JWT_SECRET` = &lt;jwt secret string&gt;<br>`CORS_ALLOWED_ORIGINS` = `http://127.0.0.1`,`http://localhost:4200`<br>`CORS_ALLOWED_METHODS` = `GET`,`POST`,`PUT`,`DELETE`,`OPTIONS`<br>`CORS_ALLOWED_HEADERS` = `Content-Type`,`Authorization` | 

    |      GitHub Repo Configuration      |
    |-------------------------------------|
    | **Repository variables:**<br>`DB_CONN_STR` = &lt;capella connection string&gt;<br>`DB_USERNAME` = &lt;database access username&gt;<br>`DB_BUCKET_NAME` = `conduit_bucket`<br> |
    | **Repository secrets:**<br>`DB_PASSWORD` = &lt;database access password&gt;<br> |
    | **Dev environment variables:**<br>`DB_SCOPE_NAME` = `dev` |
    | **Dev environment secrets:**<br>`JWT_SECRET` = &lt;jwt secret string&gt; |

14. [Optional] Set up Couchbase code editor extension.
  - Download the Couchbase extension in VS Code or IntelliJ IDEA.
  - Log in using details.
  -  This integrates access to the cluster directly from the code editor.
15. Test run.
Run the following command and the API should connect itself to the Capella cluster and start up on `http://127.0.0.1:8000`:
    ```sh
    ./scripts/local/api-run.sh
    ```
    Following the link should lead to a Swagger UI page titled FastAPI & Capella Conduit API (we will discuss this page further in this stage).

### Models and Schemas
Before starting the API, we need to understand how Conduit represents its data as objects. In Conduit, objects are distinct entities within the system, such as Users, Articles, and Comments.

| Object **models** act as blueprints that outline the attributes of these objects. For instance, a model might specify that an object, like a food item, has a flavor. **Schemas** then provide detailed descriptions of these attributes, such as stating that a particular food has a ‘sweet’ flavor. While **models** establish the overall structure of the objects, **schemas** provide the specific details about each attribute. |

A model can **embed** or **refer** to another model as one of its attributes. This establishes a relationship between objects. Conduit has the following examples of this:

**An article object:**
1. Embeds a User object in its `author` attribute.
2. Can refer to multiple User objects in its `favoritedUserIds` attribute.
3. Can refer to multiple Comment objects in its `commentIds` attribute.\
**A comment object:**
1. Embeds a User object in its `author` attribute.\
**A user object:**
1. Can refer to multiple User objects in its `followingIds`.

These relationships define the object relational structure illustrated in Figure 1:
<div align="center">
  <img src="./images/Figure1.png" alt="Figure 1: Object relational structure" width="500">
  <p><em>Figure 1: Object relational structure</em></p>
</div>

### API Start Up

### API Database

### API Endpoints

### Security

### Local Testing

### CI Pipeline
---
# Stage 2
## Integrating Frontend for Full-stack Conduit with Cypress E2E Testing Suite
### Preparation

### Selecting and Integrating a Frontend

### Full-Stack Conduit

### Cypress E2E Testing

### Integrating E2E Testing into CI Workflow
---
# Stage 3
## Containerizing Conduit with Docker
### Containerizing the API

### Containerizing the Frontend

### Containerizing the E2E Testing

### Composing Containers
---
# Stage 4
## Infrastructure Automation with Terraform and Conduit Deployment to AWS
### Preparation

### Deployment to AWS with ECR and ECS

### Introduction to Terraform

### Capella Instance Provisioning

### Using CBShell for Capella Management

### CD Pipeline

### TD Pipeline
---
# Summary

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
