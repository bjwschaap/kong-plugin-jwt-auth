# kong-plugin-jwt-auth
Kong plugin that performs authorization based on custom role claim in JWT

## How to use
This plugin is typically used on routes to authorize access to a specific
route by checking the roles claimed in the JWT.

This plugin is designed to work alongside the standard JWT plugin provided
by Kong. The default Kong JWT plugin will validate the JWT and authenticate
the consumer. This plugin will use the validated token from the Nginx context
and check a custom roles claim in the JWT to contain at least one of the
roles given in the plugin configuration.

### Configuration parameters
| Parameter        | Type   | Optional | Default | Description |
| ---------------- | ------ | -------- | ------- | ----------- |
| roles_claim_name | string | X        | `roles` | Name of the claim/attribute in the JWT that contains the roles to check |
| roles            | array  | -        |         | List of 1 or more roles that are allowed to use the resource (route, service, etc) |

## Example: enabling the plugin on a route
Configure this plugin on a [route](https://docs.konghq.com/latest/admin-api/#Route-object)
with:

```shell
$ curl -X POST http://kong:8001/routes/{route_id}/plugins \
    --data "name=jwt-auth" \
    --data "conf.roles_claim_name=Groups" \
    --data "conf.roles=role1,role2,role3"
```

## More information
More info on working with JWTs in Kong, check the
[documentation](https://docs.konghq.com/hub/kong-inc/jwt/).

## Work in progress
This plugin is an exercise. Please don't use in production unless you know
what you are doing. Any contributions to make this plugin production
grade are very welcome!
