# Java Peertesting Setup

## Requirements

- Docker
- Docker compose

### I don't have Docker, what can I do?

Please test the blocking from the signal side panel UI/UX and make sure everything looks OK.

## Clone this repository
A docker compose file is provided to make it simple to run the Java test app. So from the local folder, choose one of the 2 following options.

If your docker containers are running on aarch64 or alpine, please add `arm64` or `alpine` after target in the docker compose
```code
version: '2'
services:
  web:
    build:
      context: .
      args:
        target: arm64
```

### 1. With vault

This option is recommended when you have both vault and appgate.

The file `docker-compose.yml` can be used with your vault's variables set first.

> **Tip!** For Unix-like systems, you can just run `source setup_staging_env.sh` in your terminal, and skip the rest of the section.

Set these environment variables first:
- Unix:
```console
export VAULT_ADDR=https://vault.us1.staging.dog
vault login -method=oidc
export DD_API_KEY=$(vault kv get -format json applications/datadog-agent/shared/agent_api_key | jq -r .data.value)
export DD_REMOTE_CONFIGURATION_KEY=$(vault kv get -format json applications/datadog-agent/shared/agent_remote_config_key | jq -r .data.value)
export DD_REMOTE_CONFIGURATION_CONFIG_ROOT=$(vault kv get -format json applications/datadog-agent/shared/agent_remote_config_config_root | jq -r .data.value)
export DD_REMOTE_CONFIGURATION_DIRECTOR_ROOT=$(vault kv get -format json applications/datadog-agent/shared/agent_remote_config_director_root | jq -r .data.value)
```
- Windows:
```console
$env:DD_API_KEY=(vault.exe kv get -format json applications/datadog-agent/shared/agent_api_key | jq -r .data.value)
$env:DD_REMOTE_CONFIGURATION_KEY=(vault.exe kv get -format json applications/datadog-agent/shared/agent_remote_config_key | ConvertFrom-Json).data.value
$env:DD_REMOTE_CONFIGURATION_CONFIG_ROOT= (vault.exe kv get -format json applications/datadog-agent/shared/agent_remote_config_config_root | ConvertFrom-Json).data.value | ConvertTo-Json
$env:DD_REMOTE_CONFIGURATION_DIRECTOR_ROOT= (vault.exe kv get -format json applications/datadog-agent/shared/agent_remote_config_director_root | ConvertFrom-Json).data.value | ConvertTo-Json
```

Then:

```console
docker compose up -d
```

### 2. With an already running local agent remote-config enabled

No need to do much but just:

```console
$ docker compose up
```

> If you want to set it up locally follow these [steps](https://datadoghq.atlassian.net/wiki/spaces/RC/pages/2507146289/Getting+Started#Prerequisite%3A-Local-agent-setup)


## Testing the whole cycle

1. Create a signal on staging (change the IP to avoid conflicts with other testers)
```console
for i in $(seq 100); do
    curl -v 'http://localhost:7777' -A "Arachni/v1" -H "X-Forwarded-For: 167.172.130.4"
done
```
2. Find the signal in the UI ([link](https://dd.datad0g.com/security?query=%40workflow.rule.type%3A%22Application%20Security%22&column=time&order=desc&product=appsec&view=signal)), block the ip
![Screenshot 2022-09-07 122337](https://user-images.githubusercontent.com/8353486/188855593-852682dc-edf8-427b-8044-2192881c9708.png)
3. Check the IP is indeed blocked (a few seconds might be needed)
```console
curl -v 'http://localhost:7777' -H "X-Forwarded-For: 167.172.130.4"
```

4. Unblock the IP from the same signal
![Screenshot 2022-09-07 122337](https://user-images.githubusercontent.com/8353486/188855593-852682dc-edf8-427b-8044-2192881c9708.png)

5. Check the IP is indeed unblocked (a few seconds might be needed)
```console
curl -v 'http://localhost:7777' -H "X-Forwarded-For: 167.172.130.4"
```

## Attacking the app with blocked IPs

### curl commands
```console
curl -v 'http://localhost:7777' -H "X-Forwarded-For: 167.172.130.2"
```
> To avoid having the long blocked body response every time but just see the headers you can add ```-o null``` to your curl command

A raw list of blocked IPs is available on [this API](https://dd.datad0g.com/api/unstable/remote_config/products/asm/data).
