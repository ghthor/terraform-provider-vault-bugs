VAULT_ADDR              := http://127.0.0.1:8200
VAULT_TOKEN             := dev-only-token
VAULT_DEV_ROOT_TOKEN_ID := $(VAULT_TOKEN)

# Used by vault terraform provider
export VAULT_ADDR
export VAULT_TOKEN
export VAULT_DEV_ROOT_TOKEN_ID

POSTGRES_PASSWORD := dev-only-password
PGUSER            := postgres
PGPASSWORD        := $(POSTGRES_PASSWORD)
PGHOST            := localhost

# Used by postgres docker container to set initial password
export POSTGRES_PASSWORD

# Used by postgresql terraform provider
export PGUSER
export PGPASSWORD
export PGHOST

.PHONY: up logs down
up:
	docker compose --project-name terraform-vault-provider up --wait --wait-timeout 30

logs:
	docker compose --project-name terraform-vault-provider logs

down:
	docker compose --project-name terraform-vault-provider down

.terraform:
	terraform init

.PHONY: plan
plan: .terraform up
	terraform plan

.PHONY: apply
apply: .terraform up
	terraform apply

.PHONY: outofband
outofband: apply
	bash ./modify_connection_url_outofband.sh

.PHONY: import_fix
import_fix: .terraform up
	terraform state rm vault_database_secret_backend_connection.database_backend
	terraform taint random_password.vault_user
	terraform import vault_database_secret_backend_connection.database_backend db/config/postgres
	terraform apply

.PHONY: destroy
destroy: .terraform
	terraform destroy
	$(MAKE) down
