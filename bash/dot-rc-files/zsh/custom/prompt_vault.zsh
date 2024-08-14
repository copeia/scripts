function prompt_vault_env() {
    export VAULT_SKIP_VERIFY=true
    export VAULT_NAMESPACE=root

    if [ -z $(echo $VAULT_TOKEN) ] || [ -z $(echo $VAULT_ADDR) ]; then 
        p10k segment -s NA -f red -i 󰱮
    else 
        identity="$(vault token lookup 2>/dev/null | grep -s "display_name" | awk '{print $2}' | cut -d '@' -f1 )"
        if [[ "$identity" == *"root"* ]]; then 
            p10k segment -s P -f red -i $'\uea67' -t "$identity"
        else
            p10k segment -s P1 -f blue -i $'\uea67' -t "$identity"
        fi
    fi

    if [[ $VAULT_ADDR == *"prod"* ]]; then
        p10k segment -s P -f red -i $'\ueba3' -t  "prod"
    elif [[ $VAULT_ADDR == *"uat"* ]]; then
        p10k segment -s P1 -f blue -i $'\ueba3' -t "uat"
    elif [[ $VAULT_ADDR == *"qa"* ]]; then
        p10k segment -s P1 -f blue -i $'\ueba3' -t "qa"
    elif [[ $VAULT_ADDR == *"dev"* ]]; then
        p10k segment -s P2 -f green -i $'\ueba3' -t "dev"
    elif [[ $VAULT_ADDR == *"sandbox"* ]]; then
        p10k segment -s P2 -f green -i $'\ueba3' -t "sandbox"
    else
        p10k segment -s NA -f red -i 󰱮
    fi
}
