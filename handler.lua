local BasePlugin = require "kong.plugins.base_plugin"
local responses = require "kong.tools.responses"
local constants = require "kong.constants"
local jwt_decoder = require "kong.plugins.jwt.jwt_parser"

local ngx_error = ngx.ERR
local ngx_log = ngx.log

local JWTAuthHandler = BasePlugin:extend()


JWTAuthHandler.PRIORITY = 950
JWTAuthHandler.VERSION = "0.1.0"


function JWTAuthHandler:new()
  JWTAuthHandler.super.new(self, "jwt-auth")
end


--- checks whether a claimed role is part of a given list of roles.
-- @param roles_to_check (array) an array of role names.
-- @param claimed_roles (table) list of roles claimed in JWT
-- @return (boolean) whether a claimed role is part of any of the given roles.
local function role_in_roles_claim(roles_to_check, claimed_roles)
  result = false
  for _, role_to_check in ipairs(roles_to_check) do
    for _, role in ipairs(claimed_roles) do
      if role == role_to_check then
        result = true
        break
      end
    end
    if result then
      break
    end
  end
  return result
end


function JWTAuthHandler:access(conf)
  JWTAuthHandler.super.access(self)

  -- get the JWT from the Nginx context
  local token = ngx.ctx.authenticated_jwt_token
  if not token
    ngx_log(ngx_error, "[jwt-auth plugin] Cannot get JWT token, add the ",
                       "JWT plugin to be able to use the JWT-Auth plugin")
    return responses.send_HTTP_FORBIDDEN("You cannot consume this service")
  end

  -- decode token to get roles claim
  local jwt, err = jwt_decoder:new(token)
  if err then
    return false, {status = 401, message = "Bad token; " .. tostring(err)}
  end

  local claims = jwt.claims
  local roles = claims[conf.roles_claim_name]

  if not role_in_roles_claim(conf.roles, roles) then
    return responses.send_HTTP_FORBIDDEN("You cannot consume this service")
  end

end

return JWTAuthHandler
