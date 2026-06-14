"""
காலக்கணி — Panchangam Data Generator
Generates SQLite database 2020-2030 using Swiss Ephemeris
Chennai: lat=13.0827, lon=80.2707, IST=UTC+5.5
"""
import swisseph as swe
import sqlite3
from datetime import date, timedelta

DB_PATH = "/home/claude/kaalakkani/assets/db/kaalakkani.db"
LAT, LON, ALT = 13.0827, 80.2707, 6.0
TZ = 5.5

swe.set_sid_mode(swe.SIDM_LAHIRI)

THITHI_TA = ["பிரதமை","துவிதியை","திரிதியை","சதுர்த்தி","பஞ்சமி",
             "சஷ்டி","சப்தமி","அஷ்டமி","நவமி","தசமி",
             "ஏகாதசி","துவாதசி","திரயோதசி","சதுர்தசி","பௌர்ணமி"]
THITHI_EN = ["Prathama","Dvitiya","Tritiya","Chaturthi","Panchami",
             "Sashti","Saptami","Ashtami","Navami","Dashami",
             "Ekadasi","Dvadasi","Trayodasi","Chaturdasi","Pournami"]

NAKSHATRA_TA = ["அஸ்வினி","பரணி","கார்த்திகை","ரோஹிணி","மிருகசீரிஷம்",
                "திருவாதிரை","புனர்பூசம்","பூசம்","ஆயில்யம்","மகம்",
                "பூரம்","உத்திரம்","ஹஸ்தம்","சித்திரை","சுவாதி",
                "விசாகம்","அனுஷம்","கேட்டை","மூலம்","பூராடம்",
                "உத்திராடம்","திருவோணம்","அவிட்டம்","சதயம்","பூரட்டாதி",
                "உத்திரட்டாதி","ரேவதி"]
NAKSHATRA_EN = ["Ashwini","Bharani","Krittika","Rohini","Mrigashirsha",
                "Ardra","Punarvasu","Pushya","Ashlesha","Magha",
                "Purva Phalguni","Uttara Phalguni","Hasta","Chitra","Swati",
                "Vishakha","Anuradha","Jyeshtha","Mula","Purva Ashadha",
                "Uttara Ashadha","Shravana","Dhanishtha","Shatabhisha",
                "Purva Bhadrapada","Uttara Bhadrapada","Revati"]

YOGA_TA = ["விஷ்கம்பம்","பிரீதி","ஆயுஷ்மான்","சௌபாக்கியம்","சோபனம்",
           "அதிகண்டம்","சுகர்மா","த்ருதி","சூலம்","கண்டம்",
           "வ்ருத்தி","த்ருவம்","வ்யாகாதம்","ஹர்ஷணம்","வஜ்ரம்",
           "சித்தி","வ்யதீபாதம்","வரீயான்","பரிகம்","சிவம்",
           "சித்தம்","சாத்யம்","சுபம்","சுக்லம்","ப்ரம்மம்",
           "இந்திரம்","வைத்ருதி"]

KARANAM_TA = ["கவம்","கௌலவம்","கரஜம்","திஷ்டிலம்","கரணம்",
              "வணிஜம்","விஷ்டி","சகுனி","சதுஷ்பாதம்","நாகவம்","கிம்ஸ்துக்னம்"]

RASI_TA = ["மேஷம்","ரிஷபம்","மிதுனம்","கடகம்","சிம்மம்","கன்னி",
           "துலாம்","விருச்சிகம்","தனுசு","மகரம்","கும்பம்","மீனம்"]

WEEKDAY_TA = ["ஞாயிறு","திங்கள்","செவ்வாய்","புதன்","வியாழன்","வெள்ளி","சனி"]

TAMIL_MONTHS_TA = ["சித்திரை","வைகாசி","ஆனி","ஆடி","ஆவணி","புரட்டாசி",
                   "ஐப்பசி","கார்த்திகை","மார்கழி","தை","மாசி","பங்குனி"]

TAMIL_YEARS = ["பிரபவ","விபவ","சுக்ல","பிரமோதூத","பிரஜோத்பத்தி",
               "ஆங்கீரஸ","ஸ்ரீமுக","பவ","யுவ","தாது",
               "ஈஸ்வர","வெகுதான்ய","பிரமாதி","விக்ரம","விஷு",
               "சித்ரபானு","சுபானு","தாரண","பார்த்திவ","வ்யய",
               "சர்வஜித்","சர்வதாரி","விரோதி","விக்ருதி","கர",
               "நந்தன","விஜய","ஜய","மன்மத","துர்முகி",
               "ஹேவிலம்பி","விளம்பி","விகாரி","சார்வரி","பிலவ",
               "சுபகிருது","சோபகிருது","குரோதி","விஸ்வாவசு","பராபவ",
               "பிலவங்க","கீலக","சௌம்ய","சாதாரண","விரோதகிருது",
               "பரிதாபி","பிரமாதீச","ஆனந்த","ராக்ஷஸ","நல",
               "பிங்கள","காளயுக்தி","சித்தார்த்தி","ரௌத்ரி","துர்மதி",
               "துந்துபி","ருத்ரோத்காரி","ரக்தாக்ஷி","குரோதன","அக்ஷய"]

RAHU_SLOT  = [7,1,6,4,5,3,2]
YAMA_SLOT  = [4,5,3,2,1,6,7]
KULI_SLOT  = [3,2,7,5,6,4,1]
GOWRI_SLOT = [1,3,6,5,4,7,2]

SOOLAM_DIR = ["தெற்கு","கிழக்கு","வடக்கு","மேற்கு","தெற்கு","மேற்கு","கிழக்கு"]
SOOLAM_REM = ["நல்லெண்ணெய்","தயிர்","பால்","வெல்லம்","நல்லெண்ணெய்","வெல்லம்","தயிர்"]

def jd_ist(jd):
    y,m,d,h = swe.revjul(jd - TZ/24.0)
    hr=int(h); mn=int((h-hr)*60)
    return f"{hr:02d}:{mn:02d}"

def get_rise(jd, body, flag):
    try:
        r = swe.rise_trans(jd-1, body, "", flag, 0, [LAT,LON,ALT], 0, 0)
        return r[1][0]
    except:
        return jd

def slot_time(sr, ss, idx):
    dur = (ss - sr) / 8
    s = sr + (idx-1)*dur
    e = sr + idx*dur
    return jd_ist(s), jd_ist(e)

def thithi(jd):
    sl = swe.calc_ut(jd, swe.SUN,  swe.FLG_SIDEREAL)[0][0]
    ml = swe.calc_ut(jd, swe.MOON, swe.FLG_SIDEREAL)[0][0]
    diff = (ml - sl) % 360
    idx = int(diff/12)
    frac = (diff%12)/12
    end_jd = jd + (1-frac)*(12/360)*29.53
    paksha = "சுக்ல" if idx < 15 else "கிருஷ்ண"
    return idx%15, paksha, jd_ist(end_jd)

def nakshatra(jd):
    ml = swe.calc_ut(jd, swe.MOON, swe.FLG_SIDEREAL)[0][0]
    idx = int(ml/(360/27))
    frac = (ml % (360/27)) / (360/27)
    end_jd = jd + (1-frac)*(360/27)/13.2
    return idx%27, jd_ist(end_jd)

def yoga(jd):
    sl = swe.calc_ut(jd, swe.SUN,  swe.FLG_SIDEREAL)[0][0]
    ml = swe.calc_ut(jd, swe.MOON, swe.FLG_SIDEREAL)[0][0]
    return int(((sl+ml)%360)/(360/27))

def karanam(jd):
    sl = swe.calc_ut(jd, swe.SUN,  swe.FLG_SIDEREAL)[0][0]
    ml = swe.calc_ut(jd, swe.MOON, swe.FLG_SIDEREAL)[0][0]
    diff = (ml - sl) % 360
    k = int(diff/6)
    fixed = {0:10,57:7,58:8,59:9}
    return fixed.get(k, (k-1)%7)

def planet_rasi(jd, pid):
    lon = swe.calc_ut(jd, pid, swe.FLG_SIDEREAL)[0][0]
    return RASI_TA[int(lon/30)]

def tamil_month_year(d):
    m = d.month
    day = d.day
    idx = (m - 4) % 12
    if day < 14:
        idx = (idx - 1) % 12
    yr_idx = (d.year - 1987) % 60
    return TAMIL_MONTHS_TA[idx], TAMIL_YEARS[yr_idx]

def generate(start_y=2020, end_y=2030):
    conn = sqlite3.connect(DB_PATH)
    c = conn.cursor()
    c.executescript("""
    DROP TABLE IF EXISTS panchangam;
    DROP TABLE IF EXISTS festivals;
    DROP TABLE IF EXISTS thirukkural;
    DROP TABLE IF EXISTS rasipalan_monthly;

    CREATE TABLE panchangam (
        date TEXT PRIMARY KEY,
        weekday INTEGER, weekday_ta TEXT,
        tamil_month TEXT, tamil_year TEXT,
        sunrise TEXT, sunset TEXT, moonrise TEXT,
        thithi_index INTEGER, thithi_name_ta TEXT, thithi_name_en TEXT,
        thithi_paksha TEXT, thithi_end TEXT,
        nakshatra_index INTEGER, nakshatra_name_ta TEXT, nakshatra_name_en TEXT, nakshatra_end TEXT,
        yoga_index INTEGER, yoga_name_ta TEXT,
        karanam_index INTEGER, karanam_name_ta TEXT,
        nalla_neram_start TEXT, nalla_neram_end TEXT,
        rahukaalam_start TEXT, rahukaalam_end TEXT,
        yamagandam_start TEXT, yamagandam_end TEXT,
        kuligai_start TEXT, kuligai_end TEXT,
        gowri_start TEXT, gowri_end TEXT,
        varjyam_start TEXT, varjyam_end TEXT,
        abhijit_start TEXT, abhijit_end TEXT,
        soolam_direction TEXT, soolam_remedy TEXT,
        sun_rasi TEXT, moon_rasi TEXT, jupiter_rasi TEXT, saturn_rasi TEXT,
        chandrashtamam_rasi TEXT,
        is_fasting INTEGER DEFAULT 0,
        is_kari INTEGER DEFAULT 0,
        is_festival INTEGER DEFAULT 0,
        is_muhurtham INTEGER DEFAULT 0,
        melnokku INTEGER DEFAULT 0
    );

    CREATE TABLE festivals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT, name_ta TEXT, name_en TEXT,
        type TEXT, banner_type TEXT DEFAULT 'normal', importance INTEGER DEFAULT 1
    );

    CREATE TABLE thirukkural (
        number INTEGER PRIMARY KEY,
        paal_ta TEXT, adhigaram_ta TEXT, adhigaram_en TEXT,
        kural_ta TEXT, kural_en TEXT, explanation_ta TEXT
    );

    CREATE TABLE rasipalan_monthly (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        year INTEGER, month INTEGER, rasi_index INTEGER,
        rasi_name_ta TEXT, prediction_ta TEXT,
        lucky_color_ta TEXT, lucky_number INTEGER, rating INTEGER
    );

    CREATE INDEX IF NOT EXISTS idx_date ON panchangam(date);
    CREATE INDEX IF NOT EXISTS idx_fest ON festivals(date);
    """)

    cur_date = date(start_y, 1, 1)
    end_date = date(end_y, 12, 31)
    n = 0

    while cur_date <= end_date:
        jd = swe.julday(cur_date.year, cur_date.month, cur_date.day, 12.0 - TZ)
        sr = get_rise(jd, swe.SUN, swe.CALC_RISE)
        ss = get_rise(jd, swe.SUN, swe.CALC_SET)
        mr_jd = get_rise(jd, swe.MOON, swe.CALC_RISE)

        # weekday: 0=Sun
        wd_py = cur_date.weekday()  # 0=Mon
        wd = (wd_py + 1) % 7        # 0=Sun

        th_idx, th_pak, th_end = thithi(jd)
        nak_idx, nak_end = nakshatra(jd)
        yog_idx = yoga(jd) % 27
        kar_idx = karanam(jd)

        rahu_s, rahu_e = slot_time(sr, ss, RAHU_SLOT[wd])
        yama_s, yama_e = slot_time(sr, ss, YAMA_SLOT[wd])
        kuli_s, kuli_e = slot_time(sr, ss, KULI_SLOT[wd])
        gowri_s, gowri_e = slot_time(sr, ss, GOWRI_SLOT[wd])
        ab_s, ab_e = slot_time(sr, ss, 5)
        var_s, var_e = slot_time(sr, ss, min(YAMA_SLOT[wd]+1, 8))

        sun_r = planet_rasi(jd, swe.SUN)
        moon_r = planet_rasi(jd, swe.MOON)
        jup_r = planet_rasi(jd, swe.JUPITER)
        sat_r = planet_rasi(jd, swe.SATURN)

        moon_rasi_idx = RASI_TA.index(moon_r) if moon_r in RASI_TA else 0
        chandra_idx = (moon_rasi_idx + 7) % 12
        chandrashtamam = RASI_TA[chandra_idx]

        tm, ty = tamil_month_year(cur_date)

        is_fast = 1 if th_idx in [10, 14] else 0
        is_kari = 1 if th_idx == 8 else 0
        melnokku = 1 if wd in [0, 3, 6] else 0

        c.execute("""INSERT OR REPLACE INTO panchangam VALUES
            (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""", (
            cur_date.isoformat(),
            wd, WEEKDAY_TA[wd],
            tm, ty,
            jd_ist(sr), jd_ist(ss), jd_ist(mr_jd),
            th_idx, THITHI_TA[th_idx], THITHI_EN[th_idx], th_pak, th_end,
            nak_idx, NAKSHATRA_TA[nak_idx], NAKSHATRA_EN[nak_idx], nak_end,
            yog_idx, YOGA_TA[yog_idx],
            kar_idx, KARANAM_TA[kar_idx % 11],
            gowri_s, gowri_e,
            rahu_s, rahu_e,
            yama_s, yama_e,
            kuli_s, kuli_e,
            gowri_s, gowri_e,
            var_s, var_e,
            ab_s, ab_e,
            SOOLAM_DIR[wd], SOOLAM_REM[wd],
            sun_r, moon_r, jup_r, sat_r,
            chandrashtamam,
            is_fast, is_kari, 0, 0, melnokku
        ))

        if n % 365 == 0:
            conn.commit()
            print(f"  Year {cur_date.year} done...")

        cur_date += timedelta(days=1)
        n += 1

    conn.commit()
    print(f"Done: {n} days generated")

    # Verify
    c.execute("SELECT date, thithi_name_ta, nakshatra_name_ta, nalla_neram_start, nalla_neram_end, rahukaalam_start FROM panchangam WHERE date='2026-06-14'")
    row = c.fetchone()
    if row:
        print(f"\nVerification — 2026-06-14:")
        print(f"  Thithi:      {row[1]}")
        print(f"  Nakshatra:   {row[2]}")
        print(f"  Nalla Neram: {row[3]}–{row[4]}")
        print(f"  Rahukaalam:  {row[5]}")

    c.execute("SELECT COUNT(*) FROM panchangam")
    print(f"  Total rows:  {c.fetchone()[0]}")
    conn.close()

if __name__ == "__main__":
    generate(2020, 2030)
