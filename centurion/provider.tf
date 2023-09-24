provider "nomad" {
  address = "https://nomad.crossbone.cc"
  region = "global"

  headers {
    name = "CF-Access-Client-Id"
    value = var.cf_access_id
  }

  headers {
    name = "CF-Access-Client-Secret"
    value = var.cf_access_secret
  }
}
