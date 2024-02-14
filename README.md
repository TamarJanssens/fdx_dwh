# Analytics Engineer Assessment 2024

This projects concerns the workout of an Assessment related to an Analytics Engineering Role.

## Installation

#### Activate Virtual Environment

```bash
source ./venv/bin/activate 
```

#### Install dependencies

```bash
# provide execution permissions to the install script

chmod +x install.sh

```

#### Launch the Docker containing a local database

```bash
# cd into the main project directory
# run:

docker-compose up -d
```

#### Setup dbt_profiles.yml in ~/.dbt

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
      password: tamar!janssens2024
      threads: 4
      TrustServerCertificate: yes
```

Or use command line to paste it into a temporary file

```bash
sudo pbpaste > ~/.dbt/RENAME_profiles.yml
cat ~/.dbt/RENAME_profiles.yml
```

Now ensure that dbt is correctly configured

```markdown
dbt test
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

### Installing Apache SuperSet

Installation instructions can be found here:
https://superset.apache.org/docs/installation/installing-superset-using-docker-compose

1. cd into project directory
2. clone the Superset repository

```
git clone https://github.com/apache/superset.git
cd superset
```

> [!WARNING]
> There seems to be a recent (2 weeks) issue in the SuperSet build related to the sqlglot package
>
> A fix to this issue is posted here on Github
>
> https://github.com/apache/superset/issues/26997#issuecomment-1933769661

3. fix the issue

```
cd docker
echo "sqlglot==20.8.0" > requirements-local.txt
```

4. after fixing this issue, run SuperSet

```
docker-compose up -d
```

5. login to superset with user:pass as superset:superset)
