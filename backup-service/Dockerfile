# Use Alpine Linux as the base image
FROM alpine:latest

# Install necessary package: lftp for FTP operations
RUN apk add --no-cache lftp

# Set environment variables for the FTP connection
ENV FTP_SERVER=192.168.140.1
ENV FTP_USERNAME=ftpuser
ENV FTP_PASSWORD=ftppassword

# Add your backup script into the image
COPY backup-script.sh /backup-script.sh

# Make sure the backup script is executable
RUN chmod +x /backup-script.sh

# The CMD directive specifies the command to execute when the container starts.
# Here, we use a while loop to run the backup script every 10 minutes.
CMD ["/bin/sh", "-c", "while true; do /backup-script.sh; sleep 600; done"]
