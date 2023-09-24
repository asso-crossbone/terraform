variable "cf_access_id" {
  description = "ID of the Cloudflare Access token to use for passing the Zero Trust proxy."
  type = string
  sensitive = true
}

variable "cf_access_secret" {
  description = "Secret for the same, aforementioned token."
  type = string
  sensitive = true
}
