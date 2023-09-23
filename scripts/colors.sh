#!/usr/bin/env bash

# Define ANSI color escape code
# color <ansi_color_code>

color() { printf "\033[${1}m"; }

# No Color
NO_COLOR=$(color "0")
NC=${NO_COLOR}
RESET_ALL='\033[0m'

# Stiles
BOLD='\e[1m'
ITALIC='\e[3m'
UNDERLINE='\e[4m'

# Black        0;30
# Dark Gray    1;30
BLACK=$(color "0;30")
DARK_GRAY=$(color "1;30")
LIGHT_BLACK=${DARK_GRAY}

# Red          0;31
# Light Red    1;31
RED=$(color "0;31")
BOLD_RED=$(color "1;31")

# Green        0;32
# Light Green  1;32
GREEN=$(color "0;32")
BOLD_GREEN=$(color "1;32")
# Brown/Orange 0;33
# Yellow       1;33
BROWN=$(color "0;33")
ORANGE=${BROWN}
YELLOW=$(color "0;33")
BOLD_BROWN=${YELLOW}
LIGHT_ORANGE=${YELLOW}

# Blue         0;34
# Light Blue   1;34
BLUE=$(color "0;34")
BOLD_BLUE=$(color "1;34")

# Purple       0;35
# Light Purple 1;35
PURPLE=$(color "0;35")
BOLD_PURPLE=$(color "1;35")

# Cyan         0;36
# Light Cyan   1;36
CYAN=$(color "0;36")
BOLD_CYAN=$(color "1;36")

# Light Gray   0;37
# White        1;37
GRAY=$(color "0;37")
BOLD_WHITE=$(color "1;37")
STANDARD=${LIGTH_GRAY}
LIGHT_STANDARD=${WHITE}

function fail() {
    local message=${1}
    local status=${2:-1}
    echo "${RED}error:${NC} ${message}"
    exit ${status}
}

function warn() {
    local message=${1}
    echo "${YELLOW}[warn]${NC} ${message}"
}

function ok() {
    local message=${1}
    echo "${GREEN}[ok]${NC} ${message}"
}

function info() {
    local message=${1}
    echo "${BLUE}[info]${NC} ${message}"
}
