job "monitoring" {
  datacenters = ["dc1"]

  type = "service"

  group "prometheus" {
    count = 1

    network {
      port "prom" {
        to = 9090
      }
    }

    service {
      name     = "prometheus"
      port     = "prom"
      provider = "nomad"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=PathPrefix(`/prometheus`)",
      ]
    }

    task "server" {
      driver = "docker"

      config {
        image = "prom/prometheus"
        ports = ["prom"]

        mount {
          type     = "volume"
          target   = "/prometheus"
          source   = "prometheus-data"
          readonly = false
          volume_options {
            no_copy = false
            driver_config {
              name = "pxd"
            }
          }
        }
      }
    }
  }

  group "clickhouse" {
    count = 1

    network {
      port "api" {
        to = 8123
      }

      port "native" {
        to = 9000
      }
    }

    service {
      name     = "clickhouse-api"
      port     = "api"
      provider = "nomad"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=PathPrefix(`/clickhouse/api`)",
      ]
    }

    service {
      name     = "clickhouse-native"
      port     = "native"
      provider = "nomad"

      tags = [
        "traefik.enable=true",
        "traefik.http.routers.http.rule=PathPrefix(`/clickhouse/native`)",
      ]
    }

    task "server" {
      driver = "docker"

      config {
        image = "clickhouse/clickhouse-server:23-alpine"
        ports = ["api", "native"]
        args = [
          "--ulimit", "nofile=262144:262144",
        ]

        mount {
          type     = "volume"
          target   = "/var/lib/clickhouse"
          source   = "clickhouse-data"
          readonly = false
          volume_options {
            no_copy = false
            driver_config {
              name = "pxd"
            }
          }
        }
      }
    }
  }
}
