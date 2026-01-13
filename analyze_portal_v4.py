import re
import os
import sys

# Use relative paths since we are in the correct directory
html_file = 'kkkkkQueries _ Edit _ BI-DBS.html'
queries_file = '07_QUERIES_TO_UPDATE.txt'
output_file = 'analysis_v4_results.txt'

def parse_queries_file(filepath):
    queries = {}
    if not os.path.exists(filepath):
        print(f"Error: Queries file not found at {filepath}")
        return queries
        
    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            m = re.match(r'Query:\s*(D\d+)', line)
            if m:
                queries[m.group(1)] = True
    return queries

def analyze_portal(html_path, target_queries):
    if not os.path.exists(html_path):
        print(f"Error: HTML file not found at {html_path}")
        return

    try:
        with open(html_path, 'r', encoding='utf-8-sig') as f:
            content = f.read()
    except Exception as e:
        print(f"Error reading HTML: {e}")
        return

    print(f"Successfully read HTML file ({len(content)} bytes).")

    # Split by the specific div that wraps each query editor
    chunks = re.split(r'<div class="box box-primary" id="snippet-queryForm-D\d+-query">', content)
    
    print(f"Found {len(chunks)} chunks based on split.")

    results_list = []

    for i, chunk in enumerate(chunks):
        # Look for the Query ID: <h3 class="box-title">D5</h3>
        id_match = re.search(r'<h3 class="box-title">\s*(D\d+)\s*</h3>', chunk)
        if not id_match:
            continue
            
        qid = id_match.group(1)
        
        # Check if this is one of the queries we care about
        if qid not in target_queries:
            continue
            
        # Parse Status
        status_match = re.search(r'box-solid box-(success|danger|warning)[^>]*query-alert', chunk)
        if status_match:
            status = status_match.group(1).title() # Success, Danger, Warning
        else:
            status = "Unknown"
        
        # Normalize status
        if status == "Danger": status = "Error"
        
        # Parse Result Equality
        is_equal = "Result are equal" in chunk
        is_not_equal = "Result are not equal" in chunk
        
        if is_equal:
            result_status = "Equal"
        elif is_not_equal:
            result_status = "Not Equal"
        else:
            result_status = "Unknown"
            
        # Check for NATURAL JOIN in SQL
        has_natural = "NATURAL JOIN" in chunk.upper()
        
        issues = []
        if status != "Success": issues.append(f"Status: {status}")
        if result_status != "Equal": issues.append(f"Result: {result_status}")
        if has_natural: issues.append("Uses NATURAL JOIN")
        
        needs_update = len(issues) > 0
        
        result_entry = f"{qid:<6} | {status:<10} | {result_status:<10} | {str(has_natural):<13} | {'YES' if needs_update else 'NO'} {str(issues) if issues else ''}"
        results_list.append(result_entry)

    # Sort results by QID (numerical part)
    results_list.sort(key=lambda x: int(re.search(r'D(\d+)', x).group(1)))
    
    header = f"{'Query':<6} | {'Status':<10} | {'Result':<10} | {'Natural Join?':<13} | {'Update Needed?'}"
    separator = "-" * len(header)
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(header + "\n")
        f.write(separator + "\n")
        print(header)
        print(separator)
        for line in results_list:
            f.write(line + "\n")
            print(line)

    print(f"\nAnalysis complete. Results saved to {output_file}")

if __name__ == '__main__':
    print("Starting analysis...")
    targets = parse_queries_file(queries_file)
    print(f"Loaded {len(targets)} target queries from {queries_file}")
    analyze_portal(html_file, targets)
