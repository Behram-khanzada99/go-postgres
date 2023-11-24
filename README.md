# go-postgres
1. The "main.go" is running the CRUD operations on indefinite Goroutines which are concurrent safe. <br />
2. CRUD operations are called in main.go file by entering a specific number for each function from the menu.<br />

Here are the benchmarks and stress-test results. <br /><br />
**Benchmarks:** <br /><br />
- When inserting 100,000 rows, it takes 2,844,964 microseconds on average, equivalent to 2.844964 seconds.
- To insert 1,000,000 (1 million) rows in the database, the insert operation takes 30,937,478.482 (30.93 million) microseconds on average, equivalent to 30.937478482 seconds.
- To insert 2,000,000 (2 million) rows in the database, the insert operation takes 61,816,881.154 (61.81 million) microseconds on average, equivalent to 1 minute 1.816881155 seconds.


**Stress-test:** <br /><br />
+ Performing concurrent CRUD operations seamlessly without encountering any errors. <br />
- The IDE and system work fine inserting upto 5,000,000 rows (7 million).
- The indefinite CRUD operations run fine when inserting up to 7 million rows.

## Dockerfile

This Dockerfile starts from the official Golang image, sets the working directory, copies the current directory into the container, builds the Go application, exposes port 8080, and specifies the command to run the application.

## docker-compose.yml

This docker-compose.yml file defines two services: 'postgres' and 'app'. The 'postgres' service uses the official postgres image and exposes port postgres. The 'app' service builds the Go application using the Dockerfile in the current directory, exposes port 8080, and depends on the redis service. This ensures that the Redis service is started before the Go application.

## deployment.yaml

The Go application is deployed with one replicas, and it listens on port 8080.
Redis is deployed with a single replica, and it listens on port postgres.

## service.yaml

The Go application service is exposed on port 80 and forwards traffic to port 8080 on the pods labeled app: go-app.

## How to deploy Kubernetes service on Terraform
- Make sure you have Kubernetes and MiniKube Installed
- Start MiniKube by running `minikube start` in the terminal.
- Navigate to the terraform folder in the project directory and execute the following commands:
  ```
  terraform init
  terraform plan
  terraform apply
  ```
- Run the following commands to verify if the deployments and pods are made:
  - `kubectl get pods` to list all the pods and check their status.
  - `kubectl get deployments` to list all the deployments.

- Sometimes the status changes from "running" to something like "CrashLoopBackOff" after the application has executed successfully and exited. In order to check if the application has executed successfully run this command: `kubectl logs [pod-name]`
