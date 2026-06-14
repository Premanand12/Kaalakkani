const { DatabaseSync } = require('node:sqlite');
const path = require('node:path');

function dump() {
  const dbPath = path.resolve('d:/App/kaalakkani/assets/db/kaalakkani.db');
  console.log('Opening DB:', dbPath);
  const db = new DatabaseSync(dbPath);

  // Get all tables
  const tables = db.prepare("SELECT name FROM sqlite_master WHERE type='table';").all();
  for (const t of tables) {
    const name = t.name;
    console.log(`--- Table: ${name} ---`);
    try {
      const columns = db.prepare(`PRAGMA table_info(${name});`).all();
      for (const col of columns) {
        console.log(`  Col: ${col.name} (${col.type})`);
      }
      const row = db.prepare(`SELECT * FROM ${name} LIMIT 1;`).all();
      console.log('  Sample row:', JSON.stringify(row[0], null, 2));
    } catch (e) {
      console.error(e);
    }
    console.log();
  }
}

dump();
