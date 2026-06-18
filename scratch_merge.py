import json

with open('c:/Users/DELL/flutter_uas/nur_kitab/asset/json/maulid.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

for item in data['data']:
    if item['judul'] == 'Maulid Barzanji Nadzom':
        bacaan = item['bacaan']
        # Find the index of "دعاء مولد الديبعي"
        try:
            doa_idx = bacaan.index("دعاء مولد الديبعي")
            # All items after doa_idx are the sentences of the doa
            doa_sentences = bacaan[doa_idx+1:]
            
            # Merge them into one string with spaces
            doa_merged = " ".join(doa_sentences)
            
            # Keep everything up to the title + the merged string
            item['bacaan'] = bacaan[:doa_idx+1] + [doa_merged]
        except ValueError:
            pass

with open('c:/Users/DELL/flutter_uas/nur_kitab/asset/json/maulid.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=2)

print('Merged doa into a single paragraph')
