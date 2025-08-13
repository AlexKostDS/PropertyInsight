import random
from faker import Faker
import datetime

fake = Faker()

# Helper: Random date
def random_date(start_year=2015, end_year=2025):
    start_date = datetime.date(start_year, 1, 1)
    end_date = datetime.date(end_year, 12, 31)
    return fake.date_between(start_date=start_date, end_date=end_date)

# Helper: Escape single quotes for SQL
def esc(text):
    return text.replace("'", "''")

# Helper: Write insert with no trailing comma
def write_values(f, rows):
    for i, row in enumerate(rows, 1):
        end_char = ',' if i < len(rows) else ''
        f.write(f"    {row}{end_char}\n")
    f.write(";\n\n")

with open('insert_data_1000.sql', 'w', encoding='utf-8') as f:

    # Areas (100 rows)
    area_rows = []
    major_cities = ['Athens', 'Thessaloniki', 'Patras', 'Heraklion', 'Larisa', 'Volos', 'Ioannina', 'Kalamata', 'Chania', 'Rethymno']
    for i in range(1, 11):
        population = random.randint(35000, 3000000)
        income = random.randint(20000, 40000)
        area_rows.append(f"({i}, '{esc(major_cities[i-1])}', {population}, {income}, NULL)")
    used_subareas = set()
    for i in range(11, 101):
        while True:
            sub_name = f"{fake.city()} Subarea"
            if sub_name not in used_subareas:
                used_subareas.add(sub_name)
                break
        population = random.randint(10000, 100000)
        income = random.randint(20000, 40000)
        parent = random.randint(1, 10)
        area_rows.append(f"({i}, '{esc(sub_name)}', {population}, {income}, {parent})")

    f.write("INSERT INTO Area VALUES\n")
    write_values(f, area_rows)

    # Categories (5 rows)
    categories = ['Apartment', 'House', 'Studio', 'Villa', 'Penthouse']
    category_rows = [f"({i}, '{esc(c)}')" for i, c in enumerate(categories, 1)]
    f.write("INSERT INTO Category VALUES\n")
    write_values(f, category_rows)

    # Addresses (200 rows)
    address_rows = []
    cities = major_cities + list(used_subareas)
    for i in range(1, 201):
        street = esc(fake.street_name())
        number = random.randint(1, 100)
        city = esc(random.choice(cities))
        postal = random.randint(10000, 99999)
        address_rows.append(f"({i}, '{street}', {number}, '{city}', {postal})")

    f.write("INSERT INTO Address VALUES\n")
    write_values(f, address_rows)

    # Properties (200 rows)
    property_rows = []
    for i in range(1, 201):
        size = random.randint(50, 300)
        year = random.randint(1950, 2025)
        floor = random.randint(1, 10)
        address_code = random.randint(1, 200)
        area_code = random.randint(1, 100)
        property_rows.append(f"({i}, {size}, {year}, {floor}, {address_code}, {area_code})")

    f.write("INSERT INTO Property VALUES\n")
    write_values(f, property_rows)

    # Residences (150 rows)
    residence_rows = []
    used_res_ids = set()
    for i in range(1, 151):
        while True:
            id_num = f"RES-{random.randint(100, 999)}"
            if id_num not in used_res_ids:
                used_res_ids.add(id_num)
                break
        category_code = random.randint(1, 5)
        residence_rows.append(f"({i}, '{id_num}', {category_code})")

    f.write("INSERT INTO Residence VALUES\n")
    write_values(f, residence_rows)

    # Offices (50 rows)
    office_rows = []
    used_tax_ids = set()
    for i in range(1, 51):
        while True:
            tax_id = random.randint(100000000, 999999999)
            if tax_id not in used_tax_ids:
                used_tax_ids.add(tax_id)
                break
        office_rows.append(f"({i}, {tax_id})")

    f.write("INSERT INTO Office VALUES\n")
    write_values(f, office_rows)

    # Evaluators (20 rows)
    evaluator_rows = []
    for i in range(1, 21):
        first_name = esc(fake.first_name())
        last_name = esc(fake.last_name())
        age = random.randint(25, 60)
        gender = random.choice(['Male', 'Female'])
        address_code = random.randint(1, 200)
        evaluator_rows.append(f"({i}, '{first_name}', '{last_name}', {age}, '{gender}', {address_code})")

    f.write("INSERT INTO Evaluator VALUES\n")
    write_values(f, evaluator_rows)

    # Evaluations (250 rows)
    evaluation_rows = []
    for i in range(1, 251):
        price = random.randint(50000, 1500000)
        eval_date = random_date().strftime('%Y-%m-%d')
        property_code = random.randint(1, 200)
        evaluator_code = random.randint(1, 20)  # Matches Evaluator.Code 1-20
        evaluation_rows.append(f"({i}, {price}, '{eval_date}', {property_code}, {evaluator_code})")

    f.write("INSERT INTO Evaluation VALUES\n")
    write_values(f, evaluation_rows)

    # System (25 rows)
    system_rows = []
    used_pairs = set()  # Track (UniqueCode, ConnectionCode) pairs for PK
    while len(system_rows) < 25:
        unique_code = random.randint(1, 20)  # Must match Evaluator.Code 1-20
        connection_code = random.randint(1, 999999)  # Any unique value
        pair = (unique_code, connection_code)
        if pair not in used_pairs:
            used_pairs.add(pair)
            time = fake.time()
            duration = random.randint(15, 60)
            date = random_date().strftime("%Y-%m-%d")
            system_rows.append(f"({unique_code}, {connection_code}, '{time}', {duration}, '{date}')")

    f.write("INSERT INTO System VALUES\n")
    write_values(f, system_rows)

print("SQL file 'insert_data_1000.sql' has been generated successfully.")