export DD_SITE=datad0g.com
export VAULT_ADDR=https://vault.us1.staging.dog
vault login -method=oidc
export DD_API_KEY=$(vault kv get -format json applications/datadog-agent/shared/agent_api_key | jq -r .data.value)
export DD_REMOTE_CONFIGURATION_KEY=$(vault kv get -format json applications/datadog-agent/shared/agent_remote_config_key | jq -r .data.value)
export DD_REMOTE_CONFIGURATION_CONFIG_ROOT=$(vault kv get -format json applications/datadog-agent/shared/agent_remote_config_config_root | jq -r .data.value)
export DD_REMOTE_CONFIGURATION_DIRECTOR_ROOT=$(vault kv get -format json applications/datadog-agent/shared/agent_remote_config_director_root | jq -r .data.value)

