# Use an official Golang runtime as a parent image
FROM golang:1.17

# Set the working directory inside the container
WORKDIR /go/src/app

# Copy the local package files to the container's workspace
COPY . .

# Download and install any required third-party dependencies into the container
RUN go mod download

# Build the Go application
RUN go build -o main .

# Expose port 8080 to the outside world
EXPOSE 8080

# Set environment variables for PostgreSQL connection
ENV DB_USER=postgres
ENV DB_PASSWORD=alpha123
ENV DB_HOST=postgres
ENV DB_PORT=5432
ENV DB_NAME=my_pgdb
ENV DB_SSL_MODE=disable

# Command to run the executable
CMD ["./main"]
