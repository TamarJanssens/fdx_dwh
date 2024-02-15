
import pandas as pd
import json
from src import project_structure
from pathlib import Path

projectRoot = project_structure.get_root(__file__)
url = 'https://pkgstore.datahub.io/core/country-codes/country-codes_json/data/616b1fb83cbfd4eb6d9e7d52924bb00a/country-codes_json.json'
countries = pd.read_json(url)

countries = countries[['ISO3166-1-Alpha-2','ISO3166-1-Alpha-3','CLDR display name','Capital','Continent','Sub-region Name','Dial']]#'official_name_ar','official_name_cn','official_name_en','official_name_es','official_name_fr','official_name_ru']]

csv_path = Path(projectRoot / 'dbt' / 'dbt_fedex' / 'seeds' / 'countries.csv')

countries.to_csv(csv_path, index=False)