#!/bin/bash

: <<DOCUMENTATION

Use this script to test/run Airflow on your local computer.
-------------------------------------------------------------
Run these commands from the root directory to run the script.

chmod +x script/run-airflow-locally.sh
/bin/bash script/run-airflow-locally.sh

DOCUMENTATION


# Create folders if they don't exist
mkdir -p ./dags ./plugins ./logs

# Create .env if it doesn't exist
if ! echo "${PWD}/.env" ; then
  cat > .env
fi
sleep 2 # give it a second to create the .env

# If AIRFLOW_VERSION isn't in the .env, add it
if ! grep '^AIRFLOW_VERSION=' .env ; then
  echo -e "AIRFLOW_VERSION=2.5.2" >> .env
fi
# If ROLE isn't in the .env, add it
if ! grep '^ROLE=' .env ; then
  echo -e "ROLE=Admin" >> .env
fi
# If USER isn't in the .env, add it
if ! grep '^USER=' .env ; then
  echo -e "USER=admin" >> .env
fi
# If PASSWORD isn't in the .env, add it
if ! grep '^PASSWORD=' .env ; then
  echo -e "PASSWORD=admin" >> .env
fi
# If FIRST isn't in the .env, add it
if ! grep '^FIRST=' .env ; then
  echo -e "FIRST=admin" >> .env
fi
# If LAST isn't in the .env, add it
if ! grep '^LAST=' .env ; then
  echo -e "LAST=admin" >> .env
fi
# If EMAIL isn't in the .env, add it
if ! grep '^EMAIL=' .env ; then
  echo -e "EMAIL=admin@company.com" >> .env
fi

# If AIRFLOW_UID isn't in .env, add it
if ! grep '^AIRFLOW_UID=[0-9]' .env ; then 
  echo -e "AIRFLOW_UID=$(id -u)\n" >> .env
fi

# Export global variables from .env
export "$(grep '^AIRFLOW_VERSION=' .env)" && echo $AIRFLOW_VERSION
export "$(grep '^ROLE=' .env)" && echo $ROLE
export "$(grep '^USER=' .env)" && echo $USER
export "$(grep '^PASSWORD=' .env)" && echo $PASSWORD
export "$(grep '^FIRST=' .env)" && echo $FIRST
export "$(grep '^LAST=' .env)" && echo $LAST
export "$(grep '^EMAIL=' .env)" && echo $EMAIL

# Specify Airflow home
export AIRFLOW_HOME="$PWD/airflow"
export SQLALCHEMY_SILENCE_UBER_WARNING=1


# Create virtual env if there isn't one
VENV_DIR=venv
if ! [ -d $PWD/$VENV_DIR ] ; then
  python3 -m venv venv
fi
sleep 2 # give it a second (or 2) to create the venv

# Activate venv
source venv/bin/activate

# Install Airflow in venv
PYTHON_PATH="$PWD/$VENV_DIR/bin/python3"
"$PYTHON_PATH" -m pip install --upgrade pip
"$PYTHON_PATH" -m pip install "apache-airflow==${AIRFLOW_VERSION}"


# Run Airflow on local server at port 8080
# airflow standalone
airflow db init
airflow db upgrade
airflow users create \
  --role $ROLE \
  --username $USER \
  --password $PASSWORD \
  --firstname $FIRST \
  --lastname $LAST \
  --email $EMAIL
airflow webserver --port 8080
airflow scheduler
