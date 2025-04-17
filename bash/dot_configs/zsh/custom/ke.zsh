function ke() {
if  [ "$1" = "example-dev" ]; then
    export AWS_PROFILE="example-dev"
    kubectx example-dev
    echo "### example-dev ###"
  elif [ "$1" = "example-staging" ]; then
    export AWS_PROFILE="example-staging"
    kubectx example-staging
    echo "### example-staging ###"
  elif [ "$1" = "example-prod" ]; then
    export AWS_PROFILE="example-prod"
    kubectx example-prod
    echo "### example-prod ###"
  elif [ "$1" = "staging-cc" ]; then
    export AWS_PROFILE="example-np-cc"
    kubectx staging-cc
    echo "### staging-cc ###"
  elif [ "$1" = "prod-cc" ]; then
    export AWS_PROFILE="example-prod-cc"
    kubectx prod-cc
    echo "### prod-cc ###"
  elif [ "$1" = "example-sandbox" ]; then
    export AWS_PROFILE="example-sandbox"
    kubectx sandbox
    echo "### sandbox ###"
fi
}