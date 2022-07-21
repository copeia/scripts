#!/bin/bash

# Basic colors
function rgb() {
    COLOR="${1}"

    case ${COLOR} in
        e)
            echo "\033[0m"
        ;;
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
        *)
            echo "rgb() Down -"
        ;;
    esac
}

# Most colors
function rgb() {
    COLOR="${1}"

    case ${COLOR} in
        e)
            echo "\033[0m"
        ;;
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
        b_g)
            echo "\033[32;1m"
        ;;
        b_b)
            echo "\033[34;1m"
        ;;
        b_y)
            echo "\033[33;1m"
        ;;
        b_r)
            echo "\033[31;1m"
        ;;
        b_p)
            echo "\033[35;1m"
        ;;
        b_t)
            echo "\033[36;1m"
        ;;
        *)
            echo "rgb() Down -"
        ;;
    esac
}