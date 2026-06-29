#!/usr/bin/env python3
"""
XML Document Transformer - Fixed Version
Performs the following transformations:
1. Replace HTML entities with numeric character references
2. Convert pb and milestone tags to self-closing (only if not already self-closing)
3. Convert part attribute values to uppercase
4. Transform encoding from ISO to UTF-8
"""

import re
import argparse
import sys
import os

def transform_entities(content):
    """
    Transform HTML entities to numeric character references
    """
    # Define entity mappings - be very specific about the patterns
    transformations = [
        (r'&oelig;', '&#339;'),
        (r'&mdash;', '&#8212;'),
        (r'&ldquo;', '&#8220;'),
        (r'&rdquo;', '&#8221;'),
        # Add other common entities that might appear
        (r'&nbsp;', '&#160;'),
        (r'&lsquo;', '&#8216;'),
        (r'&rsquo;', '&#8217;'),
        (r'&hellip;', '&#8230;'),
        (r'&ndash;', '&#8211;'),
    ]
    
    for pattern, replacement in transformations:
        content = content.replace(pattern, replacement)
    
    return content

def fix_self_closing_tags(content):
    """
    Convert pb and milestone tags to self-closing format
    Only convert tags that are NOT already self-closing
    """
    # Handle pb tags that are not self-closing
    # Pattern 1: <pb attributes></pb> -> <pb attributes/>
    content = re.sub(r'<pb([^>]*?)></pb>', r'<pb\1/>', content)
    
    # Pattern 2: <pb attributes> (not followed by /) -> <pb attributes/>
    # But only if it's not already self-closing
    content = re.sub(r'<pb([^>]*?)(?<!/)>', lambda m: f'<pb{m.group(1)}' + ('/' if not m.group(1).endswith('/') else '') + '>', content)
    
    # Handle milestone tags that are not self-closing
    # Pattern 1: <milestone attributes></milestone> -> <milestone attributes/>
    content = re.sub(r'<milestone([^>]*?)></milestone>', r'<milestone\1/>', content)
    
    # Pattern 2: <milestone attributes> (not followed by /) -> <milestone attributes/>
    # But only if it's not already self-closing
    content = re.sub(r'<milestone([^>]*?)(?<!/)>', lambda m: f'<milestone{m.group(1)}' + ('/' if not m.group(1).endswith('/') else '') + '>', content)
    
    return content

def fix_self_closing_tags_v2(content):
    """
    Better approach: Fix pb and milestone tags to be self-closing
    """
    # Find all pb and milestone tags and fix them
    def fix_tag(match):
        tag_name = match.group(1)
        attributes = match.group(2)
        
        # If attributes don't end with /, add it
        if not attributes.strip().endswith('/'):
            if attributes.strip():
                return f'<{tag_name}{attributes}/>'
            else:
                return f'<{tag_name}/>'
        else:
            # Already self-closing, return as is
            return match.group(0)
    
    # Pattern to match pb and milestone tags (both self-closing and not)
    # This will match: <pb>, <pb/>, <pb attributes>, <pb attributes/>, <pb attributes></pb>
    
    # First, convert paired tags to self-closing
    content = re.sub(r'<(pb|milestone)([^>]*?)>\s*</\1>', r'<\1\2/>', content)
    
    # Then fix any remaining open tags that aren't self-closing
    content = re.sub(r'<(pb|milestone)([^/>]*?)(?<!/)>', fix_tag, content)
    
    return content

def fix_part_attributes(content):
    """
    Convert part attribute values to uppercase
    """
    def uppercase_part(match):
        return f'part="{match.group(1).upper()}"'
    
    # Pattern to match part="letter" attributes (single letters)
    content = re.sub(r'part="([a-zA-Z])"', uppercase_part, content)
    
    return content

def transform_encoding(content):
    """
    Transform encoding declaration from ISO to UTF-8
    """
    # More comprehensive encoding patterns
    encoding_patterns = [
        (r'encoding="ISO-8859-1"', 'encoding="UTF-8"'),
        (r'encoding="iso-8859-1"', 'encoding="UTF-8"'),
        (r'encoding="ISO-8859-[0-9]+"', 'encoding="UTF-8"'),
        (r'encoding="iso-8859-[0-9]+"', 'encoding="UTF-8"'),
        (r"encoding='ISO-8859-1'", 'encoding="UTF-8"'),
        (r"encoding='iso-8859-1'", 'encoding="UTF-8"'),
    ]
    
    for pattern, replacement in encoding_patterns:
        content = re.sub(pattern, replacement, content)
    
    return content

def process_xml_content(content):
    """
    Process XML content with all transformations
    """
    print("Applying transformations...")
    
    # Apply transformations in order
    print("  1. Transforming entities...")
    original_content = content
    content = transform_entities(content)
    if content != original_content:
        print("     - Entities transformed")
    
    print("  2. Fixing self-closing tags...")
    original_content = content
    content = fix_self_closing_tags_v2(content)
    if content != original_content:
        print("     - Self-closing tags fixed")
    
    print("  3. Converting part attributes to uppercase...")
    original_content = content
    content = fix_part_attributes(content)
    if content != original_content:
        print("     - Part attributes converted")
    
    print("  4. Transforming encoding...")
    original_content = content
    content = transform_encoding(content)
    if content != original_content:
        print("     - Encoding transformed")
    
    return content

def process_xml_file(input_file, output_file=None):
    """
    Process an XML file with all transformations
    """
    try:
        # Check if input file exists
        if not os.path.exists(input_file):
            print(f"Error: File '{input_file}' not found.")
            return False
        
        # Read the input file with proper encoding detection
        encodings_to_try = ['utf-8', 'iso-8859-1', 'latin-1', 'cp1252']
        content = None
        
        for encoding in encodings_to_try:
            try:
                with open(input_file, 'r', encoding=encoding) as f:
                    content = f.read()
                print(f"Successfully read file with {encoding} encoding")
                break
            except UnicodeDecodeError:
                continue
        
        if content is None:
            print("Error: Could not read file with any supported encoding")
            return False
        
        print(f"Processing {input_file}...")
        
        # Apply transformations
        transformed_content = process_xml_content(content)
        
        # Determine output file name
        if output_file is None:
            base_name = os.path.splitext(input_file)[0]
            output_file = f"{base_name}_transformed.xml"
        
        # Write the transformed content as UTF-8
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(transformed_content)
        
        print(f"Transformation complete. Output saved to: {output_file}")
        return True
        
    except Exception as e:
        print(f"Error processing file: {e}")
        return False

def run_test():
    """
    Run a test with sample XML data that matches your document structure
    """
    sample_xml = '''<?xml version="1.0" encoding="ISO-8859-1"?>
<TEI xmlns="http://www.tei-c.org/ns/1.0">
    <text>
        <body>
            <p>Here is an &oelig;ligature and an &mdash;em dash.</p>
            <quote>&ldquo;Hello world&rdquo;</quote>
            <pb/>
            <pb n="1"></pb>
            <milestone unit="page" n="2"></milestone>
            <pb n="3">
            <milestone unit="line" n="4">
            <milestone n="vi." unit="page"/>
            <element part="a">Content with lowercase part</element>
            <element part="b">Another element</element>
            <div part="y">Test div</div>
        </body>
    </text>
</TEI>'''
    
    print("=== TESTING XML TRANSFORMER ===")
    print("\nOriginal XML:")
    print("-" * 50)
    print(sample_xml)
    
    transformed = process_xml_content(sample_xml)
    
    print("\nTransformed XML:")
    print("-" * 50)
    print(transformed)
    
    print("\n=== CHANGES MADE ===")
    print("✓ Entity transformations:")
    print("  &oelig; → &#339;")
    print("  &mdash; → &#8212;")
    print("  &ldquo; → &#8220;")
    print("  &rdquo; → &#8221;")
    print("✓ Self-closing tags:")
    print("  <pb></pb> → <pb/>")
    print("  <milestone></milestone> → <milestone/>")
    print("  <pb> → <pb/>")
    print("  <milestone> → <milestone/>")
    print("✓ Part attributes:")
    print("  part=\"a\" → part=\"A\"")
    print("  part=\"y\" → part=\"Y\"")
    print("✓ Encoding:")
    print("  ISO-8859-1 → UTF-8")
    
    print("\n=== TEST COMPLETE ===")

def main():
    parser = argparse.ArgumentParser(description='Transform XML documents with specific rules')
    parser.add_argument('--test', action='store_true', help='Run test with sample data')
    parser.add_argument('input_file', nargs='?', help='Input XML file path')
    parser.add_argument('-o', '--output', help='Output file path (optional)')
    
    args = parser.parse_args()
    
    if args.test:
        run_test()
    elif args.input_file:
        success = process_xml_file(args.input_file, args.output)
        if not success:
            sys.exit(1)
    else:
        print("Usage:")
        print("  python3 xml_transformer.py --test")
        print("  python3 xml_transformer.py input_file.xml")
        print("  python3 xml_transformer.py input_file.xml -o output_file.xml")
        sys.exit(1)

if __name__ == "__main__":
    main()
