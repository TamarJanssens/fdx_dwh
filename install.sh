#!/bin/bash
# install.sh

# Install other dependencies
pip install -r requirements.txt

# Install pyodbc without binary. This is a workaround to support ARM64 M1 Mac models as found on  https://github.com/mkleehammer/pyodbc/issues/1124#issuecomment-1318793968
pip install --no-binary :all: pyodbc==5.0.1

cd ./dbt/dbt_fedex/models
mkdir fct stg mrt