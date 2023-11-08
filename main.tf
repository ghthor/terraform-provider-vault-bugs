terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.22.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.21.0"
    }
  }
}

provider "vault" {
}

provider "postgresql" {
  sslmode         = "disable"
  superuser       = false
  connect_timeout = 15
}

locals {
  mount_path = "db"
}

resource "vault_database_secrets_mount" "db" {
  path = local.mount_path

  default_lease_ttl_seconds = 17280   // 12 hours
  max_lease_ttl_seconds     = 5184000 // 60 days

  lifecycle {
    ignore_changes = [
      postgresql
    ]
  }
}

resource "random_password" "vault_user" {
  length = 40
}

resource "postgresql_role" "vault_user" {
  name     = "vault"
  password = random_password.vault_user.result

  login       = true
  create_role = true
  superuser   = false
  roles       = ["postgres"]
}

resource "vault_database_secret_backend_connection" "database_backend" {
  backend           = vault_database_secrets_mount.db.path
  name              = "postgres"
  allowed_roles     = []
  verify_connection = false

  postgresql {
    username       = postgresql_role.vault_user.name
    password       = random_password.vault_user.result
    connection_url = "postgres://{{username}}:{{password}}@postgres:5432/postgres"
  }
}
