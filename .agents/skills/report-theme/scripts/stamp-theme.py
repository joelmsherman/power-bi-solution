#!/usr/bin/env python3
"""Stamp brand values into a PowerUI-authored Power BI theme file, in place.

PowerUI bakes colours and fonts into visualStyles as literals, so a brand change
is a literal swap across the whole file, not an edit of the top-level keys
alone. This does every swap in one regex pass, so a chain (A -> B, B -> C) can
never cascade, and it rewrites the text rather than re-serialising the JSON, so
the file keeps PowerUI's formatting and the diff shows only what changed.

usage: stamp-theme.py <theme.json> <map.json> [--dry-run]

map.json:
{
  "name":       "Client Light",                      # optional: the theme's display name
  "colors":     {"#00adff": "#1b4f72", ...},         # old hex -> new hex, case-insensitive
  "dataColors": ["#1b4f72", "#e07a1f", ...],         # optional: replaces the array outright
  "fonts":      {"Segoe UI": "Source Sans 3", ...}   # old family -> new family, exact match
}
"""
import json
import re
import sys


def main() -> int:
    args = [a for a in sys.argv[1:] if a != "--dry-run"]
    dry_run = "--dry-run" in sys.argv
    if len(args) != 2:
        print("usage: stamp-theme.py <theme.json> <map.json> [--dry-run]", file=sys.stderr)
        return 2
    theme_path, map_path = args
    text = open(theme_path, encoding="utf-8").read()
    spec = json.load(open(map_path, encoding="utf-8"))
    original = json.loads(text)  # fail early on a broken input file

    counts: dict[str, int] = {}

    colors = {k.lower(): v for k, v in spec.get("colors", {}).items()}
    if colors:
        pattern = re.compile("|".join(re.escape(k) for k in colors) + r"(?![0-9A-Fa-f])", re.IGNORECASE)

        def swap_color(m: re.Match) -> str:
            key = m.group(0).lower()
            counts[key] = counts.get(key, 0) + 1
            return colors[key]

        text = pattern.sub(swap_color, text)

    fonts = spec.get("fonts", {})
    if fonts:
        # Longest first, so "Segoe UI Semibold" is not caught by "Segoe UI".
        keys = sorted(fonts, key=len, reverse=True)
        pattern = re.compile(r'"(' + "|".join(re.escape(k) for k in keys) + r')"')

        def swap_font(m: re.Match) -> str:
            counts[m.group(1)] = counts.get(m.group(1), 0) + 1
            return '"' + fonts[m.group(1)] + '"'

        text = pattern.sub(swap_font, text)

    if "dataColors" in spec:
        # Match PowerUI's layout: one colour per line, indented two past the key.
        def swap_data_colors(m: re.Match) -> str:
            indent = m.group(1)
            items = (",\n" + indent + "  ").join(json.dumps(c) for c in spec["dataColors"])
            return f'{indent}"dataColors": [\n{indent}  {items}\n{indent}]'

        text, n = re.subn(r'^([ \t]*)"dataColors"\s*:\s*\[[^\]]*\]', swap_data_colors, text, count=1,
                          flags=re.MULTILINE)
        counts["dataColors"] = n

    if "name" in spec:
        text, n = re.subn(r'^(\s*)"name"\s*:\s*"[^"]*"', lambda m: m.group(1) + '"name": ' + json.dumps(spec["name"]),
                          text, count=1, flags=re.MULTILINE)
        counts["name"] = n

    stamped = json.loads(text)  # the result must still be valid JSON
    if set(stamped) != set(original):
        print("refusing to write: top-level keys changed", file=sys.stderr)
        return 1

    for key, n in counts.items():
        print(f"{key:>24}  {n} replaced")
    missing = [k for k in list(colors) + list(fonts) if k not in counts and k.lower() not in counts]
    for key in missing:
        print(f"{key:>24}  NOT FOUND (check the role map in .report-theme)")

    if dry_run:
        print("dry run: nothing written")
    else:
        with open(theme_path, "w", encoding="utf-8", newline="") as f:
            f.write(text)
        print(f"wrote {theme_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
