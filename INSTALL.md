# Debian 11 (bullseye) install :

you need python3, pip, virtualenv

    bash
    apt-get -qy install python3 python3-pip virtualenv

create virtualenv

    bash
    virtualenv -p python3 .venv
    .venv/bin/pip3 install -r requirement.txt

### psycopg2 require package libpq-dev for "pg_config"

