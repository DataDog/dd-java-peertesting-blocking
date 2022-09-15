# Java Peertesting Setup

## Requirements

- Docker
- Docker compose

## Clone this repository.
A docker compose file is provided to make it simple to run the java test app.

If your docker containers are running on aarch64, please add `arm64` after target in the docker compose:
```code
version: '2'
services:
  web:
    build:
      context: .
      args:
        target: arm64
```

Then, you will need to set the following environment variables:
 * `DD_API_KEY` to create [here](https://dd.datad0g.com/organization-settings/api-keys)
 * `DD_REMOTE_CONFIGURATION_KEY` to create [here](https://dd.datad0g.com/organization-settings/remote-config)

Then:
```shell
export DD_API_KEY=YOUR_API_KEY  # replace with your key if created from the interface
export DD_REMOTE_CONFIGURATION_KEY=YOUR_REMOTE_CONFIGURATION_KEY  # replace with your key if created from the interface
docker-compose up
```

## curl commands
```shell
curl -v 'http://localhost:7777' -H "X-Forwarded-For: 167.172.130.2"
```
