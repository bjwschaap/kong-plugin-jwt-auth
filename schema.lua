return {
  no_consumer = true,
  fields = {
    roles = {type = "array", default = {}},
    roles_claim_name = {type = "string", default = "roles"},
    policy = {type = "string", default = "any", enum = {"any", "all"} }
  }
}
