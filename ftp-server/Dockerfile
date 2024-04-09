# Start from the base image
FROM garethflowers/ftp-server

# Set environment variables (Not recommended for sensitive data)
ENV FTP_PASS=ftppassword
ENV FTP_USER=ftpuser

# Add your backup script into the image
COPY ./data /home/ftpuser

# Expose necessary ports for FTP and passive mode
EXPOSE 20-21
EXPOSE 40000-40009

# The base image already includes an ENTRYPOINT that starts the FTP server,
# but you might override it if you have custom startup scripts or need to 
# programmatically set environment variables based on build args, etc.
