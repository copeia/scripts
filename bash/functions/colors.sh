#!/bin/bash

# Called like:
# printf "$(rgb B)Printing things to screen$(rgb e)\n"

# Define color options for printf
function rgb() {
    COLOR="${1}"

    case ${COLOR} in
        # Ends color code
        e)
            echo "\033[0m"
        ;;
        # List of common colors by first letter, lower for standard and upper for Bold i.e (b)lue | (B)lue 
        g)
            echo "\033[0;32m"
        ;;
        b)
            echo "\033[0;34m"
        ;;
        y)
            echo "\033[0;33m"
        ;;
        r)
            echo "\033[0;31m"
        ;;
        p)
            echo "\033[0;35m"
        ;;
        t)
            echo "\033[0;36m"
        ;;
        G)
            echo "\033[32;1m"
        ;;
        B)
            echo "\033[34;1m"
        ;;
        Y)
            echo "\033[33;1m"
        ;;
        R)
            echo "\033[31;1m"
        ;;
        P)
            echo "\033[35;1m"
        ;;
        T)
            echo "\033[36;1m"
        ;;
        *)
            echo "rgb() Down -"
        ;;
    esac
}