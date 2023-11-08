# Steps to Reproduce

This testing environment uses docker compose to run vault and postgres in an
isolated environment to enable reproducing this bug in the
terraform-provider-vault.

1. `make apply`
    1. docker compose up && terraform apply
2. `make outofband`
    1. make a change to connection_url out of band from terraform
3. `make plan` **Notice no changes to connection_url**
4. `make import_fix`
    1. state rm the resource && terraform import
5. `make plan` **Notice connection_url has drifted**
6. `make destroy`
    1. teardown terraform resources && docker compose down
