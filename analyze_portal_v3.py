import re
import os

html_path = r'c:\Users\Hostilian\Downloads\database\Course_EIE36E_Database_System..._.1068306\Movie_Database_Project\Movie_TVshow_index\kkkkkQueries _ Edit _ BI-DBS.html'
queries_file_path = r'c:\Users\Hostilian\Downloads\database\Course_EIE36E_Database_System..._.1068306\Movie_Database_Project\Movie_TVshow_index\07_QUERIES_TO_UPDATE.txt'

def parse_queries_file(filepath):
    queries = {}
    current_q = None
    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            m = re.match(r'Query:\s*(D\d+)', line)
            if m:
                current_q = m.group(1)
                queries[current_q] = True
    return queries

def parse_html(filepath, target_queries):
    results = {}
    
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading HTML: {e}")
        return

    # Split by query snippets to avoid overlapping regex
    # Pattern: <div class="box box-primary" id="snippet-queryForm-D\d+-query">
    snippets = re.split(r'<div class="box box-primary" id="snippet-queryForm-D\d+-query">', content)
    
    print(f"{'Query':<6} | {'Status':<10} | {'Result':<15} | {'Natural Join?':<13} | {'Update Needed?'}")
    print("-" * 70)

    for snippet in snippets:
        # Find Visible ID
        # <h3 class="box-title">D5</h3>
        id_match = re.search(r'<h3 class="box-title">(D\d+)</h3>', snippet)
        if not id_match:
            continue
        
        visible_id = id_match.group(1)
        if visible_id not in target_queries:
            continue

        # Status
        # <div class="box box-solid box-(success|danger|warning) ... query-alert">
        status_match = re.search(r'box-solid box-(success|danger|warning)[^>]*query-alert', snippet)
        status = status_match.group(1).title() if status_match else "Unknown"

        # Result
        # Result are equal.
        # Result are not equal.
        if "Result are equal" in snippet:
            result = "Equal"
        elif "Result are not equal" in snippet:
            result = "Not Equal"
        else:
            result = "Unknown"

        # SQL Content check (Natural Join)
        # <textarea ... name="sql" ...>CONTENT</textarea>
        # Regex is tricky with multiline. search for name="sql" and then capture content?
        # Or look for "NATURAL JOIN" in the sql editor part
        # Better: check simply if "NATURAL JOIN" is present in the SQL text area part.
        # simpler: check if "NATURAL JOIN" string exists in the snippet (might match RA too, but good enough warning)
        has_natural = "NATURAL JOIN" in snippet.upper()
        
        # Update Needed?
        # Logic: If Status!=Success OR Result!=Equal OR HasNatural -> YES.
        # Also, even if Success/Equal, we determined many mismatches manually.
        # So I will mark ALL as Yes, but flag specific reasons.
        
        reasons = []
        if status != "Success": reasons.append(f"Status {status}")
        if result != "Equal": reasons.append(f"Result {result}")
        if has_natural: reasons.append("Natural Join")
        
        reason_str = ", ".join(reasons) if reasons else "Logic/Category Update"
        
        print(f"{visible_id:<6} | {status:<10} | {result:<15} | {str(has_natural):<13} | Yes ({reason_str})")

target_queries = parse_queries_file(queries_file_path)
parse_html(html_path, target_queries)
