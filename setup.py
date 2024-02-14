from setuptools import setup, find_packages

setup(
    name='fedex',
    version='1.0',
    install_requires=[
        # Core data manipulation/analysis libraries
        'pandas>=1.5.0',
        'numpy>=1.23.0',
        'scikit-learn>=1.1.3',

        # Data visualization
        'matplotlib>=3.7.2',
        'seaborn',

        # Jupyter ecosystem
        'jupyterlab>=3.4.1',
        'notebook',

        # Database interaction
        'SQLAlchemy>=1.4.44',
        'psycopg2>=2.9.5',

        # Additional database tools
        'dbt-sqlserver>=1.4.2',  # Assuming SQL Server integration

        # Efficient data handling and processing
        'pyarrow>=6.0.1',

        # Specific ODBC version
        'pyodbc==5.0.1',

        # Other dependencies tailored to your project (e.g., specific versions)
        # ...
    ],
    packages=find_packages(),
    python_requires='>=3.6',  # Compatibility range (optional)
)
