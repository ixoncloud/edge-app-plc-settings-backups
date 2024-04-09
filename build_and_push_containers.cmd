@echo off
REM Output executed commands and stop on errors.
setlocal enabledelayedexpansion
set "platform=linux/arm64/v8"

REM Ensure the correct builder is in use.
docker buildx use secure-edge-pro

REM Function to build, tag, and push Docker images.
:build_and_push_image
set "directory=%1"
set "tag=192.168.140.1:5000/%directory%:latest"

cd %directory%
docker buildx build --platform %platform% --tag %tag% --push .
cd ..

exit /b

REM Build and push the ftp-server image.
call :build_and_push_image "ftp-server"

REM Build and push the backup-service image.
call :build_and_push_image "backup-service"

REM Build and push the backup-webui image.
call :build_and_push_image "backup-webui"

endlocal
