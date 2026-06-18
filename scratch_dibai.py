import json

titles = [
    "Niat dan Hadiah Fatihah",
    "Ya Rabbi shalli...",
    "Ya Rasûlallah...",
    "Innâ fataḥnâ...",
    "Al-ḥamdulillâhil qawiyy...",
    "Qîla huwa âdam...",
    "Yub‘atsu min tihamah...",
    "Tsumma ardudduhu...",
    "Shalâtullâhi ma laḥat...",
    "Fasubḥânaman khashshahû...",
    "Awwalu mâ nastaftiḥu...",
    "Al-ḥadîtsul awwal...",
    "Al-ḥadîtsuts tsânî...",
    "Fayaqûlul haqqu...",
    "Ahdhirû qulûbakum...",
    "Fahtazzal arsyu...",
    "Mahallul Qiyâm: Yâ nabî salam...",
    "Wawulida shallallâhu...",
    "Qîla man yakfulu...",
    "Tsumma a’radla...",
    "Fabainamal habîbu...",
    "Faqâlatil malâikah...",
    "Fabainamal habîbu shallallâhu...",
    "Falammâ ra’athu halîmah...",
    "Wa kâna shallallâhu...",
    "Wa qîla liba’dlihim...",
    "Wa mâ ‘asâ an yuqâla...",
    "Ya badratimmin...",
    "Doa Maulid ad-Diba’i"
]

try:
    with open('c:/Users/DELL/flutter_uas/nur_kitab/asset/json/maulid.json', 'r', encoding='utf-8') as f:
        data = json.load(f)

    # find the max ID
    max_id = max([item['id'] for item in data['data']]) if data['data'] else 0

    for idx, title in enumerate(titles):
        # We prefix the title slightly or just use the user's title
        data['data'].append({
            "id": max_id + idx + 1,
            "judul": title,
            "tipe": "maulid",
            "bacaan": [
                title,
                "[Teks Arab belum tersedia. Silakan perbarui file JSON nanti.]"
            ]
        })

    with open('c:/Users/DELL/flutter_uas/nur_kitab/asset/json/maulid.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)

    print("Success adding 29 chapters of Maulid Diba'i to JSON")
except Exception as e:
    print(f"Error: {e}")
