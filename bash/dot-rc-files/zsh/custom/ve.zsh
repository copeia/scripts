function ve() {

  export VAULT_ADDR="https://vault-enterprise-${1}.corp.internal.<BASE_DOMAIN>.com"
  printf "\ntoken:"
  read -s token
  export VAULT_TOKEN="${token}"
    
}