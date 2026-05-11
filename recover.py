import subprocess
import re
import os

# Get list of modified files
status = subprocess.check_output(['git', 'status', '--porcelain'], text=True)
files = [line.strip().split()[-1] for line in status.splitlines() if line.endswith('.dart')]

for file in files:
    try:
        with open(file, 'r', encoding='utf-8') as f:
            content = f.read()
    except Exception:
        continue

    if '${match.group(1)}' not in content:
        continue

    # Get diff for this file
    diff = subprocess.check_output(['git', 'diff', file], text=True, encoding='utf-8')
    
    # Parse diff
    lines = diff.splitlines()
    replacements = []
    
    for i, line in enumerate(lines):
        if line.startswith('+') and '${match.group(1)}' in line:
            # Look backwards for the corresponding '-' line
            j = i - 1
            while j >= 0 and not lines[j].startswith('-'):
                j -= 1
            if j >= 0:
                original_line = lines[j][1:] # Remove '-'
                bad_line = line[1:] # Remove '+'
                
                # The original line has "const TextStyle(color: Colors.white, ...)"
                # We want "TextStyle(color: context.adaptiveWhite, ...)"
                fixed_line = original_line.replace('const ', '').replace('Colors.white70', 'context.adaptiveWhite70').replace('Colors.white54', 'context.adaptiveWhite54').replace('Colors.white24', 'context.adaptiveWhite24').replace('Colors.white12', 'context.adaptiveWhite12').replace('Colors.white10', 'context.adaptiveWhite10').replace('Colors.white', 'context.adaptiveWhite')
                
                replacements.append((bad_line.strip(), fixed_line.strip()))

    # Apply replacements
    for bad, fixed in replacements:
        content = content.replace(bad, fixed)
        
    with open(file, 'w', encoding='utf-8') as f:
        f.write(content)
        
    print(f"Fixed {file}")
