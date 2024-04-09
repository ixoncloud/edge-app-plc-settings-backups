# Stage 1: Build environment
FROM rust:alpine as builder
WORKDIR /app

# Install necessary build dependencies
RUN apk add --no-cache musl-dev
RUN rustup component add rustfmt

# Copy source code to the container
COPY . /app

# Leverage Docker cache to speed up builds
RUN --mount=type=cache,target=/usr/local/cargo/registry \
    --mount=type=cache,target=/app/target/release/build \
    --mount=type=cache,target=/app/target/release/deps \
    --mount=type=cache,target=/app/target/release/incremental \
    cargo build --release

# Stage 2: Runtime environment
FROM alpine:latest
WORKDIR /app

# Set up the user and group IDs
ARG UID="1000"
ARG GID="1000"
ARG USER="ixon"
RUN addgroup -g ${GID} -S ${USER}
RUN adduser -u ${UID} -S ${USER} -s /bin/ash ${USER}

# Copy only the built binary from the builder stage
COPY --from=builder /app/target/release/webui /app/webui
COPY --from=builder /app/static /app/static

# Expose the port the app runs on
EXPOSE 8080

# Set the user to run the binary
USER ixon

# Command to run the application
CMD ["./webui"]

