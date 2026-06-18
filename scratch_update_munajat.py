import json

def reformat_munajat(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    modified = False
    for item in data['data']:
        if item.get('judul') == 'Munajat':
            new_bacaan = []
            
            # Check if we already have the title
            if len(item['bacaan']) > 0 and isinstance(item['bacaan'][0], str) and "مُنَاجَاة" in item['bacaan'][0]:
                pass
            else:
                new_bacaan.append("اَلْمُنَاجَاة")
                
            for line in item['bacaan']:
                if isinstance(line, str) and "۞" in line:
                    parts = line.split(" ۞ ")
                    if len(parts) == 2:
                        new_bacaan.append({
                            "bait_kanan": parts[0].strip(),
                            "bait_kiri": parts[1].strip()
                        })
                    else:
                        new_bacaan.append(line)
                elif line != "اَلْمُنَاجَاة" and line != "مُنَاجَاة":
                    new_bacaan.append(line)
            item['bacaan'] = new_bacaan
            modified = True
            
    if modified:
        with open(filepath, 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print(f"Updated format in {filepath}")

hizib_path = r'c:\Users\DELL\flutter_uas\nur_kitab\asset\json\hizib.json'
ratib_path = r'c:\Users\DELL\flutter_uas\nur_kitab\asset\json\ratib.json'

reformat_munajat(hizib_path)
reformat_munajat(ratib_path)
