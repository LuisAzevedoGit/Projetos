# permite a colaboraçao de varias pessoas, se nao usar isto, pode gerar conflitos no tfstate


terraform {
  backend "s3" {

    bucket  = "terraform-state-luisazevedo" #nome
    key     = "site/terraform.tfstate"      #pasta onde o arquivo vai  ficar
    region  = "eu-west-3"                   #regiao do bucket
    encrypt = true                          #encryptar os dados
    use_lockfile = true
  }
}