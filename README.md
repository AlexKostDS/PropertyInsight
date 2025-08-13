# PropertyInsight

A database project for managing and analyzing property evaluations across various regions.

---

## Overview
This repository contains:
- **Database schema** (`CreateTables.sql`) with tables for areas, properties, evaluators, evaluations, and related entities.
- **Sample data generation script** (`generate_data.py`) to produce 1,000+ rows of realistic test data.
- **SQL data inserts** (`insert_data_1000.sql`) and example insert files for Office, Evaluator, Evaluation, and System tables.
- **Analysis queries** (`Main.sql`) to run on the dataset.
- **Relational diagram** visualizing the database structure.

---

## Project Structure
- `data/`: Contains the generated SQL data file (`insert_data_1000.sql`).
- `scripts/`: Includes SQL scripts (`CreateTables.sql`, `Main.sql`) and the data generation script (`generate_data.py`).
- `diagrams/`: Holds the relational diagram (`relational_diagram.png`).

---

## Relational Diagram

![Relational Diagram](docs/Relational%20Diagram.png)

---
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
