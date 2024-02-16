# Analytics Engineer Assessment 2024

Author: Tamar Janssens

This projects concerns the workout of an Assessment related to an Analytics Engineering Role.

The project has proven to be quite some work and challenging at times, but it has been a pleasure to work on. I hope you will enjoy going through my work as much as I did while developing it.

> [!NOTE]
>
> The DEV branch is AHEAD of main. I have not merged them intentially for the sake of an honest and clear evaluation.
>
> Changes concern the following:
>
> * Additional cleaning on shipState source data (replacing characters not matching with a-z, A-Z or 0-9 by '_' )
> * The location Dimensions that were still missing in the main branch
> * Country data loaded from web (JSON), processed with Pandas into a seed
> * cityState dimension and explanation at the bottom of this README.md of this choice
> * Pivoted Mart model that counts amount of sales by SKU and Year
> * Staging model that joins orders and related tables
>
> No other relevant modifications were made in this MAIN branch after I had invited my future colleagues ;)

## Installation

### Activate Virtual Environment

After cloning this repo, activate the virtual environment

```bash
source ./venv/bin/activate 
```

### Install dependencies

```bash
# provide execution permissions to the install script

chmod +x install.sh

```

### Launch the Docker containing a local SQL Edge database

SQL Edge is a lightweight SQL Server which is able to be installed on IoT devices

```bash
# cd into the main project directory
# run:

docker-compose up -d
```

A free Database client that is able to connect to the Dockerized is Azure Data Studio, which can be downloaded from here: [https://learn.microsoft.com/en-us/azure-data-studio/download-azure-data-studio?tabs=win-install%2Cwin-user-install%2Credhat-install%2Cwindows-uninstall%2Credhat-uninstall]()

### Setup your dbt_profiles.yml in ~/.dbt

1. Copy the following configuration into profiles.yml

```bash
dbt_fedex:
  target: dev
  outputs:
    dev:
      type: sqlserver
      driver: 'ODBC Driver 18 for SQL Server' 
      server: localhost
      port: 57000
      database: master
      schema: fdx
      user: sa
      password: tamar-janssens2024
      threads: 4
      TrustServerCertificate: yes
```

> [!IMPORTANT]
>
> For the sake of ease I have included the password here as well as in the docker-compose.yml and the src/upload_data.py script. I ackknowledge this is very bad practice and hence I would never do this in real life. I would use a (mounted)) environment variable or cloud parameter store, never upload it to Git and make sure it would not appear in any logs.
>
> Same applies to the data which is uploaded to Git.

Or use command line to paste it into a temporary file

```bash
sudo pbpaste > ~/.dbt/RENAME_profiles.yml
cat ~/.dbt/RENAME_profiles.yml
```

Now ensure that dbt is correctly configured

```markdown
dbt debug 
```

Install packages

```bash
 dbt deps
```

## Data Cleaning and Preliminary Analysis

> [!NOTE]
>
> Locate the notebook in ``fedex_dwh/notebooks/clean_source.ipynb`` that contains this analysis

## Inserting the raw data into the local dtabase

> [!WARNING]
>
> Ensure that the Docker containing the Database is running

run

```
python ./src/upload_data.py
```

## Installing Apache SuperSet

Installation instructions can be found here:
https://superset.apache.org/docs/installation/installing-superset-using-docker-compose

1. cd into project directory
2. clone the Superset repository

```
git clone https://github.com/apache/superset.git
cd superset
```

> [!WARNING]
> There seems to be a recent (2 weeks old) issue in the SuperSet build related to the sqlglot package
>
> A fix to this issue is posted here on Github
>
> [https://github.com/apache/superset/issues/26997#issuecomment-1933769661]()

3. fix the issue

```
cd docker
echo "sqlglot==20.8.0" > requirements-local.txt
```

4. after fixing this issue, run SuperSet

```
docker-compose up -d
```

> [!NOTE]
>
> In case of conflicts, the following command can show other processes running at the default SuperSet ports:
>
> ```lsof
> lsof -i :8088 # 5432, 8080
> ```
>
> Or to LISTEN to open ports:
>
> ```
> sudo lsof -i -P | grep LISTEN
> ```
>
> 4. a. 	Change the docker-compose file to use unused ports

5. Once installation turns out to be succesful, login to superset with default user:pass as admin:admin)

## Building op the Kimball DWH

Based on evaluating constant fields per field, I have identified the following Facts and Dimensions

### Orders [FACT]

* orderId
* date
* status
* b2b
* fulfilment
* salesChannel
* shipServiceLevel

### OrderItems [FACT}

* orderId [FK]
* sku [FK]
* qty
* promotionIds *
* currency
* amount
* courierStatus
* fulfilledBy

> [!NOTE]
>
> * I could likely re-construct a promotion table based on a price analysis that defines a base price and evaluates the price markeup/discount within a given time period based on the promotionId and the price paid for the orderItems. This is however beyond the scope of this exercise.

### Date [Dimension]

In order to prevent the date dimension from gaps I used/Googled a macro to generate a series and modified it to fit my use case.

### SKU [Dimension]

* sku
* style
* category
* size
* asin

### Location [Dimension]

> [!NOTE]
>
> Since locations can have different names, it is relevant to create separate dimensions for Country, State and City. This way synonyms can be stored across the dimensions to enforce uniques with respect to similar locations.
>
> Due to time limitations, I am not able to finish these models, but i've showed similar skills in other models.
>
>
> [UPDATE: DEV branch contains these models]

* shipCity
* shipState
* shipPostalCode
* shipCountry
