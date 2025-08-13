# PropertyInsight

A database project for managing and analyzing property evaluations across various regions.

## Overview
This repository contains a relational database schema, sample data generation scripts, and analysis queries for property evaluations. The project includes:
- A database schema with tables for areas, properties, evaluators, and evaluations.
- A Python script to generate 1000 rows of sample data.
- SQL queries for data analysis and reporting.
- A relational diagram (PNG) visualizing the database structure.

## Project Structure
- `data/`: Contains the generated SQL data file (`insert_data_1000.sql`).
- `scripts/`: Includes SQL scripts (`CreateTables.sql`, `Main.sql`) and the data generation script (`generate_data.py`).
- `docs/`: Holds the relational diagram (`relational_diagram.png`).

## Setup
1. **Prerequisites**:
   - A SQL Server instance (e.g., Microsoft SQL Server).
   - Python 3.x with the `faker` library (`pip install faker`).
2. **Installation**:
   - Clone the repository: `git clone <repository-url>`.
   - Navigate to the project directory: `cd PropertyInsight`.
   - Run the data generation script: `python scripts/generate_data.py` to create `data/insert_data_1000.sql`.
3. **Database Setup**:
   - Use SQL Server Management Studio or a similar tool.
   - Execute `scripts/CreateTables.sql` to create the database schema.
   - Execute `data/insert_data_1000.sql` to populate the database.
4. **Run Queries**:
   - Execute `scripts/Main.sql` to perform analysis queries.

## Usage
- The `Main.sql` file contains 16 queries for various analyses (e.g., evaluator statistics, price trends).
- The relational diagram in `docs/relational_diagram.png` provides a visual overview of the schema.

## License
[MIT License](LICENSE).

## Acknowledgments
- Data generation inspired by the Faker library.
