function ke() {
if  [ "$1" = "sb-dev" ]; then
    export AWS_PROFILE="sb-dev"
    kubectx sb-dev
    echo "### sb-dev ###"
  elif [ "$1" = "sb-staging" ]; then
    export AWS_PROFILE="sb-staging"
    kubectx sb-staging
    echo "### sb-staging ###"
  elif [ "$1" = "sb-prod" ]; then
    export AWS_PROFILE="sb-prod"
    kubectx sb-prod
    echo "### sb-prod ###"
  elif [ "$1" = "staging-cc" ]; then
    export AWS_PROFILE="simplebet-np-cc"
    kubectx staging-cc
    echo "### staging-cc ###"
  elif [ "$1" = "prod-cc" ]; then
    export AWS_PROFILE="simplebet-prod-cc"
    kubectx prod-cc
    echo "### prod-cc ###"
  elif [ "$1" = "sb-sandbox" ]; then
    export AWS_PROFILE="simplebet-sandbox"
    kubectx sandbox
    echo "### sandbox ###"
fi
}