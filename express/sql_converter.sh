#!/usr/bin/env python3

import re
import sys
import argparse

def convert_mysql_to_sqlite(input_file, output_file):
    """Convert MySQL dump to SQLite compatible format"""
    
    print(f"Converting MySQL dump to SQLite format...")
    print(f"Input:  {input_file}")
    print(f"Output: {output_file}")
    
    try:
        with open(input_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Error: Input file '{input_file}' not found!")
        sys.exit(1)
    
    # Remove MySQL-specific comments and settings
    content = re.sub(r'^/\*!.*?\*/;?\s*$', '', content, flags=re.MULTILINE)
    content = re.sub(r'^SET .*?;?\s*$', '', content, flags=re.MULTILINE)
    content = re.sub(r'^--.*$', '', content, flags=re.MULTILINE)
    
    # Remove DELIMITER statements
    content = re.sub(r'^DELIMITER.*$', '', content, flags=re.MULTILINE)
    
    # Remove stored procedures, functions, and triggers (multi-line)
    # This handles the DEFINER syntax and everything between CREATE and END
    content = re.sub(
        r'CREATE\s+(DEFINER\s*=\s*[^\\s]+\s+)?(PROCEDURE|FUNCTION|TRIGGER)\s+.*?END\s*;{0,2}\s*', 
        '', 
        content, 
        flags=re.DOTALL | re.IGNORECASE
    )
    
    # Remove DROP statements for procedures, functions, triggers
    content = re.sub(r'^DROP\s+(PROCEDURE|FUNCTION|TRIGGER).*?;?\s*$', '', content, flags=re.MULTILINE | re.IGNORECASE)
    
    # Remove MySQL-specific table operations
    content = re.sub(r'^LOCK TABLES.*?;?\s*$', '', content, flags=re.MULTILINE)
    content = re.sub(r'^UNLOCK TABLES.*?;?\s*$', '', content, flags=re.MULTILINE)
    
    # Convert AUTO_INCREMENT to AUTOINCREMENT
    content = re.sub(r'AUTO_INCREMENT', 'AUTOINCREMENT', content, flags=re.IGNORECASE)
    
    # Remove MySQL-specific column attributes
    content = re.sub(r'\bUNSIGNED\b', '', content, flags=re.IGNORECASE)
    content = re.sub(r'\bZEROFILL\b', '', content, flags=re.IGNORECASE)
    content = re.sub(r'\bCHARACTER SET\s+\w+', '', content, flags=re.IGNORECASE)
    content = re.sub(r'\bCOLLATE\s+\w+', '', content, flags=re.IGNORECASE)
    
    # Convert MySQL data types to SQLite equivalents
    type_mappings = {
        r'\bTINYINT(\(\d+\))?\b': 'INTEGER',
        r'\bSMALLINT(\(\d+\))?\b': 'INTEGER', 
        r'\bMEDIUMINT(\(\d+\))?\b': 'INTEGER',
        r'\bBIGINT(\(\d+\))?\b': 'INTEGER',
        r'\bINT(\(\d+\))?\b': 'INTEGER',
        r'\bFLOAT(\([0-9,]+\))?\b': 'REAL',
        r'\bDOUBLE(\([0-9,]+\))?\b': 'REAL',
        r'\bDECIMAL(\([0-9,]+\))?\b': 'REAL',
        r'\bVARCHAR(\(\d+\))?\b': 'TEXT',
        r'\bCHAR(\(\d+\))?\b': 'TEXT',
        r'\bTINYTEXT\b': 'TEXT',
        r'\bTEXT\b': 'TEXT',
        r'\bMEDIUMTEXT\b': 'TEXT',
        r'\bLONGTEXT\b': 'TEXT',
        r'\bTINYBLOB\b': 'BLOB',
        r'\bBLOB\b': 'BLOB',
        r'\bMEDIUMBLOB\b': 'BLOB',
        r'\bLONGBLOB\b': 'BLOB',
        r'\bDATETIME\b': 'TEXT',
        r'\bTIMESTAMP\b': 'TEXT',
        r'\bDATE\b': 'TEXT',
        r'\bTIME\b': 'TEXT',
        r'\bYEAR(\(\d+\))?\b': 'INTEGER',
    }
    
    for mysql_type, sqlite_type in type_mappings.items():
        content = re.sub(mysql_type, sqlite_type, content, flags=re.IGNORECASE)
    
    # Handle ENUM types - convert to TEXT
    content = re.sub(r'\bENUM\s*\([^)]+\)', 'TEXT', content, flags=re.IGNORECASE)
    
    # Remove MySQL-specific table options
    content = re.sub(r'\bENGINE\s*=\s*\w+', '', content, flags=re.IGNORECASE)
    content = re.sub(r'\bDEFAULT CHARSET\s*=\s*\w+', '', content, flags=re.IGNORECASE)
    content = re.sub(r'\bCOLLATE\s*=\s*\w+', '', content, flags=re.IGNORECASE)
    content = re.sub(r'\bAUTO_INCREMENT\s*=\s*\d+', '', content, flags=re.IGNORECASE)
    content = re.sub(r'\bCOMMENT\s*=\s*\'[^\']*\'', '', content, flags=re.IGNORECASE)
    
    # Remove backticks
    content = re.sub(r'`', '', content)
    
    # Remove KEY definitions that aren't PRIMARY KEY
    content = re.sub(r'^\s*KEY\s+.*?,?\s*$', '', content, flags=re.MULTILINE)
    content = re.sub(r'^\s*UNIQUE KEY\s+.*?,?\s*$', '', content, flags=re.MULTILINE)
    content = re.sub(r'^\s*INDEX\s+.*?,?\s*$', '', content, flags=re.MULTILINE)
    
    # Remove FOREIGN KEY constraints 
    content = re.sub(r'^\s*CONSTRAINT.*?FOREIGN KEY.*?,?\s*$', '', content, flags=re.MULTILINE | re.DOTALL)
    content = re.sub(r'^\s*FOREIGN KEY.*?,?\s*$', '', content, flags=re.MULTILINE)
    
    # Clean up extra commas and whitespace
    content = re.sub(r',\s*,', ',', content)
    content = re.sub(r',\s*\)', ')', content)
    content = re.sub(r'\(\s*,', '(', content)
    
    # Remove empty lines
    content = re.sub(r'^\s*$', '', content, flags=re.MULTILINE)
    
    # Remove multiple consecutive newlines
    content = re.sub(r'\n\s*\n', '\n', content)
    
    # Write the converted content
    try:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print("Conversion completed successfully!")
        print("")
        print("Note: This script handles most common conversions, but you may need to:")
        print("1. Manually review and adjust complex constraints")
        print("2. Handle any remaining MySQL-specific syntax")
        print("3. Recreate indexes if needed: CREATE INDEX index_name ON table_name(column_name);")
        print("4. Test the resulting SQL file with: sqlite3 database.db < " + output_file)
        print("")
        print("To import into SQLite:")
        print(f"sqlite3 your_database.db < {output_file}")
        
    except Exception as e:
        print(f"Error writing output file: {e}")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description='Convert MySQL dump to SQLite format')
    parser.add_argument('input_file', help='Input MySQL dump file')
    parser.add_argument('output_file', help='Output SQLite file')
    
    args = parser.parse_args()
    
    convert_mysql_to_sqlite(args.input_file, args.output_file)

if __name__ == '__main__':
    main()
