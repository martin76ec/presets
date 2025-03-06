import os
import re
import subprocess
from dotenv import load_dotenv

# Step 1: Load environment variables from .env
load_dotenv()  # This automatically loads .env variables into os.environ

# Ensure DB_URL is set
DB_URL = os.getenv("DB_URL")
if not DB_URL:
  print("Error: DB_URL not found in .env")
  exit(1)


# Step 2: Generate models.py using sqlacodegen
def generate_models():
  try:
    subprocess.run(
      ["sqlacodegen", DB_URL, "--generator", "sqlmodels", "src/providers/sqlalchemy/models/models.py"], check=True, capture_output=True, text=True
    )
  except subprocess.CalledProcessError as e:
    print("Error:", e.stderr)


# print("Generating models...")
# subprocess.run(["sqlacodegen", DB_URL, "--generator", "sqlmodels", "src/providers/sqlalchemy/models/models.py"], check=True)


# Step 3: Remove `t_pg_stat_statements` from models.py
def clean_models():
  if not os.path.exists("models.py"):
    print("Error: models.py not found")
    exit(1)

  with open("models.py", "r") as f:
    content = f.read()

  # Regex to remove `t_pg_stat_statements = Table(...)`
  pattern = r"t_pg_stat_statements\s*=\s*Table\([^)]*\)\n?"
  cleaned_content = re.sub(pattern, "", content, flags=re.DOTALL)

  with open("models.py", "w") as f:
    f.write(cleaned_content)

  print("Removed t_pg_stat_statements from models.py")


# Step 4: Initialize Alembic if needed and generate migrations
def run_alembic():
  if not os.path.exists("migrations"):
    print("Initializing Alembic...")
    subprocess.run(["alembic", "init", "migrations"], check=True)

  print("Generating Alembic migration...")
  subprocess.run(["alembic", "revision", "--autogenerate", "-m", "Initial migration"], check=True)


def main():
  generate_models()
  # clean_models()
  run_alembic()
  print("✅ Model generation and Alembic migration complete.")


if __name__ == "__main__":
  main()
