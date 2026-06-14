import sqlite3

def dump_schema():
    conn = sqlite3.connect(r"d:\App\kaalakkani\assets\db\kaalakkani.db")
    cursor = conn.cursor()
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = cursor.fetchall()
    for table_name in tables:
        name = table_name[0]
        print(f"--- Table: {name} ---")
        cursor.execute(f"PRAGMA table_info({name});")
        columns = cursor.fetchall()
        for col in columns:
            print(f"  Col: {col[1]} ({col[2]})")
        
        # sample a row
        cursor.execute(f"SELECT * FROM {name} LIMIT 1;")
        row = cursor.fetchone()
        print(f"  Sample row: {row}")
        print()
    conn.close()

if __name__ == "__main__":
    dump_schema()
