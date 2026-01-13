import re
import os

html_path = r"c:\Users\Hostilian\Downloads\database\Course_EIE36E_Database_System..._.1068306\Movie_Database_Project\Movie_TVshow_index\kkkkkQueries _ Edit _ BI-DBS.html"

queries_to_check = [
    "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D15", "D18", "D19", 
    "D20", "D21", "D22", "D25", "D26", "D27", "D28", "D37", "D47", "D48", "D49", 
    "D50", "D51"
]

def check_queries(file_path):
    if not os.path.exists(file_path):
        print(f"File not found: {file_path}")
        return

    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()

    # Split by query blocks roughly (box-primary seems to be the container)
    # But IDs are distinct.
    
    results = {}
    
    for qid in queries_to_check:
        # Find the header
        # <h3 class="box-title">D3</h3>
        pattern = re.compile(fr'<h3 class="box-title">{qid}</h3>', re.IGNORECASE)
        match = pattern.search(content)
        
        if not match:
            results[qid] = "NOT_FOUND"
            continue
            
        start_pos = match.start()
        # Look within the next, say, 15000 chars for status. Using a large window to be safe.
        chunk = content[start_pos:start_pos+15000]
        
        status = "UNKNOWN"
        if "SQL Query: Success" in chunk:
            status = "SUCCESS"
        elif "SQL Query: Error" in chunk:
            status = "ERROR"
        elif "SQL Query: Warning" in chunk:
            status = "WARNING"
            
        equal = "UNKNOWN"
        if "Result are equal" in chunk:
            equal = "EQUAL"
        elif "Result are NOT equal" in chunk or "Result are different" in chunk: # Guessing failure text
            equal = "NOT_EQUAL"
            
        has_natural_join = "NATURAL JOIN" in chunk.upper()
        
        # Check if rows is 0
        zero_rows = "0 rows" in chunk
        
        results[qid] = {
            "status": status,
            "equal": equal,
            "has_natural_join": has_natural_join,
            "zero_rows": zero_rows
        }

    print(f"{'Query':<6} | {'Status':<10} | {'Equal?':<10} | {'NatJoin?':<10} | {'ZeroRows?':<10}")
    print("-" * 60)
    for qid in queries_to_check:
        if qid not in results:
            print(f"{qid:<6} | {'MISSING':<10} | {'-':<10} | {'-':<10} | {'-':<10}")
            continue
            
        r = results[qid]
        if r == "NOT_FOUND":
            print(f"{qid:<6} | {'NOT_FOUND':<10} | {'-':<10} | {'-':<10} | {'-':<10}")
        else:
            print(f"{qid:<6} | {r['status']:<10} | {r['equal']:<10} | {str(r['has_natural_join']):<10} | {str(r['zero_rows']):<10}")

check_queries(html_path)
