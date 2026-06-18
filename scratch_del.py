import json

# Delete Maulid Simtutdurar (pembuka) from maulid.json
try:
    with open('c:/Users/DELL/flutter_uas/nur_kitab/asset/json/maulid.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    original_len = len(data['data'])
    data['data'] = [item for item in data['data'] if item.get('judul') != 'Maulid Simtutdurar (pembuka)']
    if len(data['data']) < original_len:
        with open('c:/Users/DELL/flutter_uas/nur_kitab/asset/json/maulid.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print("Deleted Maulid Simtutdurar (pembuka) from maulid.json")
except Exception as e:
    print(f"Error processing maulid.json: {e}")

# Delete Qashidah Ya Imamarusli and Qashidah Busro Lana from qashidah.json
try:
    with open('c:/Users/DELL/flutter_uas/nur_kitab/asset/json/qashidah.json', 'r', encoding='utf-8') as f:
        data = json.load(f)
    original_len = len(data['data'])
    
    titles_to_remove = ['Qashidah Ya Imamarusli', 'Qashidah Busro Lana', 'Qashidah Ya Imamarrusli'] # sometimes spelling differs
    
    data['data'] = [item for item in data['data'] if item.get('judul') not in titles_to_remove]
    
    if len(data['data']) < original_len:
        with open('c:/Users/DELL/flutter_uas/nur_kitab/asset/json/qashidah.json', 'w', encoding='utf-8') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        print("Deleted Qashidahs from qashidah.json")
except Exception as e:
    print(f"Error processing qashidah.json: {e}")
