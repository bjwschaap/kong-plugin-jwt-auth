# kong-plugin-jwt-auth
Kong plugin that performs authorization based on custom role claim in JWT

## how to use
This plugin is typically used on routes to authorize access to a specific
route by checking the roles claimed in the JWT.

This plugin is designed to work alongside the standard JWT plugin provided
by Kong. The default Kong JWT plugin will validate the JWT and authenticate
the consumer. This plugin will use the validated token from the Nginx context
and check a custom roles claim in the JWT to contain at least one of the
roles given in the plugin configuration.

## work in progress
This plugin is an exercise. Please don't use in production unless you know
what you are doing. Any contributions to make this plugin production
grade are very welcome!
