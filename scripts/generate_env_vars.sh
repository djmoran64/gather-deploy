#!/usr/bin/env bash
#
# Copyright (C) 2018 by eHealth Africa : http://www.eHealthAfrica.org
#
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

# This script can be used to generate an ".env" for local development with
# docker compose.

check_openssl () {
    which openssl > /dev/null
}

gen_random_string () {
    openssl rand -hex 16 | tr -d "\n"
}

gen_env_file () {
    cat << EOF
#
# USE THIS ONLY LOCALLY
#
# This file was generated by "./scripts/generate_env_vars.sh" script.
#
# Variables in this file will be substituted into docker-compose-ZZZ.yml and
# are intended to be used exclusively for local deployment.
# Never deploy these to publicly accessible servers.
#
# Feel free to replace the generated values.
#
# Verify correct substitution with:
#
#   docker-compose config
#
# If variables are newly added or enabled,
# please restart the images to pull in changes:
#
#   docker-compose restart {container-name}
#


# ------------------------------------------------------------------
# Gather
# ==================================================================
GATHER_VERSION=3.1.0

GATHER_ADMIN_USERNAME=admin
GATHER_ADMIN_PASSWORD=adminadmin
GATHER_DJANGO_SECRET_KEY=$(gen_random_string)
GATHER_DB_PASSWORD=$(gen_random_string)
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# Aether
# ==================================================================
AETHER_VERSION=1.2.0
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# Aether Kernel
# ==================================================================
KERNEL_ADMIN_USERNAME=admin
KERNEL_ADMIN_PASSWORD=adminadmin
KERNEL_ADMIN_TOKEN=$(gen_random_string)
KERNEL_DJANGO_SECRET_KEY=$(gen_random_string)
KERNEL_DB_PASSWORD=$(gen_random_string)

KERNEL_READONLY_DB_USERNAME=readonlyuser
KERNEL_READONLY_DB_PASSWORD=$(gen_random_string)
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# Aether Producer
# ==================================================================
PRODUCER_ADMIN_USER=admin
PRODUCER_ADMIN_PW=adminadmin
# ------------------------------------------------------------------

# ------------------------------------------------------------------
# Aether ODK Module
# ==================================================================
ODK_ADMIN_USERNAME=admin
ODK_ADMIN_PASSWORD=adminadmin
ODK_ADMIN_TOKEN=$(gen_random_string)
ODK_DJANGO_SECRET_KEY=$(gen_random_string)
ODK_DB_PASSWORD=$(gen_random_string)
# ------------------------------------------------------------------


# ------------------------------------------------------------------
# Aether UI
# ==================================================================
UI_ADMIN_USERNAME=admin
UI_ADMIN_PASSWORD=adminadmin
UI_DJANGO_SECRET_KEY=$(gen_random_string)
UI_DB_PASSWORD=$(gen_random_string)
# ------------------------------------------------------------------

EOF
}

if [ -e ".env" ]; then
    echo "[.env] file already exists! Remove it if you want to generate a new one."
    exit 0
fi

check_openssl
RET=$?
if [ $RET -eq 1 ]; then
    echo "Please install 'openssl'"
    exit 1
fi

set -Eeo pipefail
gen_env_file > .env
echo "[.env] file generated!"
