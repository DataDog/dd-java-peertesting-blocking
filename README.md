# Usage

Docker, as well as docker compose, is needed.
Clone this repository.
A docker compose file is provided to make it simple to run the dotnet test app. So from your local folder:

## Using docker-compose

```console
$ DD_API_KEY=<yourkey> docker-compose up
```

Alternatively, you can add custom response templates via environment variables.

```console
$  DD_APPSEC_HTTP_BLOCKED_TEMPLATE_HTML=/app/blocked.html DD_APPSEC_HTTP_BLOCKED_TEMPLATE_JSON=/app/blocked.json DD_API_KEY=<yourkey> docker-compose up
```

### Environment variables

Env variables are defined in the docker-compose, feel free to choose your own configuration,
it can be useful to change DD_ENV to make it something recognizable to you

## Attacking the app

You should be able to attack the app on port 7777 of your machine.
For now, blocking is active on every rule, only request that don't trigger a security alert will pass.

### curl commands

```console

$ curl http://localhost:7777
Hello World!robert@ROBERT-LAPTOP:~

$ curl http://localhost:7777/?q=database\(\)
{"errors": [{"title": "Access denied", "detail": "Your request has been blocked and was not executed."}]}

$ curl -H "Accept: text/html" http://localhost:7777/?q=database\(\)
<!-- Sorry, you’ve been blocked -->
<!DOCTYPE html>

$ curl -H "Accept: */*" http://localhost:7777/?q=database\(\)
{"errors": [{"title": "Access denied", "detail": "Your request has been blocked and was not executed."}]}

$ curl -H "Accept: application/*" http://localhost:7777/?q=database\(\)
{"errors": [{"title": "Access denied", "detail": "Your request has been blocked and was not executed."}]}

$ curl -H "Accept: application/json" http://localhost:7777/?q=database\(\)
{"errors": [{"title": "Access denied", "detail": "Your request has been blocked and was not executed."}]}
```
