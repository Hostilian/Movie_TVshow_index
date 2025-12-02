import zipfile
import os

# Create a new ZIP file with proper structure
zip_path = '05_sql_developer_export.zip'

# Remove if exists
if os.path.exists(zip_path):
    os.remove(zip_path)

# Create ZIP with explicit settings - files at root level without folder
with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as zipf:
    # Add files directly at root level (no folder structure)
    zipf.write('sql_developer_export/ddl_export.sql',
               arcname='ddl_export.sql')
    zipf.write('sql_developer_export/model_export.xml',
               arcname='model_export.xml')

print(f"ZIP file created: {zip_path}")

# Verify the ZIP
with zipfile.ZipFile(zip_path, 'r') as zipf:
    print("\nContents:")
    for info in zipf.infolist():
        print(f"  {info.filename} - {info.file_size} bytes")

    # Test ZIP integrity
    bad_file = zipf.testzip()
    if bad_file is None:
        print("\nZIP integrity: OK")
    else:
        print(f"\nZIP integrity: FAILED on {bad_file}")
