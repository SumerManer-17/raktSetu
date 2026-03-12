# test_connection.py — run this once to verify
import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

try:
    conn = psycopg2.connect(os.getenv("DATABASE_URL"))
    cursor = conn.cursor()
    cursor.execute("SELECT version();")
    version = cursor.fetchone()
    print("✅ Connected successfully!")
    print(f"PostgreSQL version: {version[0]}")
    conn.close()
except Exception as e:
    print(f"❌ Connection failed: {e}")