const { DatabaseSync } = require('node:sqlite');
const path = require('node:path');

function inspect() {
  const dbPath = path.resolve('d:/App/kaalakkani/assets/db/kaalakkani.db');
  const db = new DatabaseSync(dbPath);

  console.log("=== DISTINCT LUCKY COLORS ===");
  console.log(db.prepare("SELECT DISTINCT lucky_color_ta FROM rasipalan_monthly;").all());

  console.log("\n=== DISTINCT HOROSCOPE PREDICTIONS ===");
  console.log(db.prepare("SELECT DISTINCT prediction_ta FROM rasipalan_monthly;").all());

  console.log("\n=== DISTINCT PALLI BODY PARTS ===");
  console.log(db.prepare("SELECT DISTINCT body_part_ta FROM palli_palangal;").all());

  console.log("\n=== DISTINCT PALLI MEANINGS ===");
  console.log(db.prepare("SELECT DISTINCT meaning_ta FROM palli_palangal;").all());

  console.log("\n=== DISTINCT PALLI TIMES ===");
  console.log(db.prepare("SELECT DISTINCT time_period_ta FROM palli_palangal;").all());
}

inspect();
