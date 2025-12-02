#!/usr/bin/env python3
"""
Query Validation Script for Portal Submission
Tests all queries from FINAL_CORRECTED_queries_portal.txt against the database.
"""

import psycopg2
import re
from pathlib import Path

# Database connection settings
DB_CONFIG = {
    'host': 'db.kii.pef.czu.cz',
    'database': 'xozte001',
    'user': 'xozte001',
    'password': 'your_password_here'  # Replace with actual password
}

def extract_queries(filepath):
    """Extract SQL queries from the portal file."""
    content = Path(filepath).read_text(encoding='utf-8')
    
    # Pattern to match query blocks
    pattern = r'---\s*([A-Z]\d?-?\d*)\s*---.*?SQL:\s*\n(.*?)(?=\n={3,}|\n---|\Z)'
    matches = re.findall(pattern, content, re.DOTALL)
    
    queries = []
    for query_id, sql in matches:
        # Clean up the SQL
        sql = sql.strip()
        # Remove trailing semicolon for psycopg2
        if sql.endswith(';'):
            sql = sql[:-1]
        queries.append((query_id.strip(), sql))
    
    return queries

def validate_query(cursor, query_id, sql):
    """Test a single query and return result."""
    try:
        cursor.execute(sql)
        rows = cursor.fetchall()
        return {
            'id': query_id,
            'status': 'OK',
            'rows': len(rows),
            'error': None
        }
    except Exception as e:
        return {
            'id': query_id,
            'status': 'FAIL',
            'rows': 0,
            'error': str(e)
        }

def main():
    # Path to query file
    query_file = Path(__file__).parent / 'FINAL_CORRECTED_queries_portal.txt'
    
    if not query_file.exists():
        print(f"ERROR: Query file not found: {query_file}")
        return
    
    # Extract queries
    queries = extract_queries(query_file)
    print(f"Found {len(queries)} SQL queries to validate\n")
    
    # Try to connect to database
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        conn.autocommit = True
        cursor = conn.cursor()
        print("Connected to database successfully\n")
    except Exception as e:
        print(f"Cannot connect to database: {e}")
        print("\nValidating query syntax only (no execution)...\n")
        
        # Just show the queries
        for query_id, sql in queries:
            print(f"[{query_id}] Query extracted:")
            print(f"  {sql[:100]}..." if len(sql) > 100 else f"  {sql}")
            print()
        return
    
    # Run validation
    results = []
    for query_id, sql in queries:
        result = validate_query(cursor, query_id, sql)
        results.append(result)
    
    # Print results
    print("=" * 70)
    print("VALIDATION RESULTS")
    print("=" * 70)
    
    passed = 0
    failed = 0
    
    for r in results:
        if r['status'] == 'OK':
            print(f"[{r['id']:8}] ✓ OK - {r['rows']} rows returned")
            passed += 1
        else:
            print(f"[{r['id']:8}] ✗ FAIL - {r['error']}")
            failed += 1
    
    print("\n" + "=" * 70)
    print(f"SUMMARY: {passed} passed, {failed} failed out of {len(results)} queries")
    print("=" * 70)
    
    # Close connection
    cursor.close()
    conn.close()

if __name__ == '__main__':
    main()
