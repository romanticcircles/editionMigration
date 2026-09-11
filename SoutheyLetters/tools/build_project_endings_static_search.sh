#!/usr/bin/env bash

# Rebuild the Southey Project Endings StaticSearch index on macOS or Linux.
# Usage: ./build_project_endings_static_search.sh /path/to/staticSearch-1.4.7

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SOURCE_CONFIG="$PROJECT_ROOT/config_staticSearch.xml"
ANT_CONTRIB="$SCRIPT_DIR/lib/ant-contrib-1.0b3.jar"
STATICSEARCH_ROOT="${1:-${STATICSEARCH_ROOT:-}}"

if [[ -z "$STATICSEARCH_ROOT" ]]; then
    echo "Usage: $0 /path/to/staticSearch-1.4.7" >&2
    exit 2
fi

STATICSEARCH_ROOT="$(cd -- "$STATICSEARCH_ROOT" && pwd)"

for command_name in java ant python3; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "Missing required command: $command_name" >&2
        exit 1
    fi
done

for required_file in \
    "$STATICSEARCH_ROOT/build.xml" \
    "$STATICSEARCH_ROOT/xsl/english_stopwords.txt" \
    "$STATICSEARCH_ROOT/xsl/english_words.txt" \
    "$SOURCE_CONFIG" \
    "$ANT_CONTRIB"; do
    if [[ ! -f "$required_file" ]]; then
        echo "Missing required file: $required_file" >&2
        exit 1
    fi
done

RUNNER="$(mktemp -d "$SCRIPT_DIR/.staticSearch-runner.XXXXXX")"
TEMP_CONFIG="$(mktemp "$PROJECT_ROOT/.config_staticSearch.macos.XXXXXX")"

cleanup() {
    rm -rf -- "$RUNNER"
    rm -f -- "$TEMP_CONFIG"
}
trap cleanup EXIT

cp -R "$STATICSEARCH_ROOT/." "$RUNNER/"

# StaticSearch 1.4.7's build file passes a property that is not accepted by
# the bundled transformation in this environment. This is the same small
# compatibility patch used by the Windows build.
python3 - "$RUNNER/build.xml" <<'PY'
from pathlib import Path
import re
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
text = re.sub(r'\r?\n\s*<arg value="ssPatternsetFile=\$\{ssPatternsetFile\}"/>', '', text)
path.write_text(text, encoding="utf-8")
PY

# Make the dictionary paths portable instead of relying on the historical
# Windows directory layout recorded in the source configuration.
python3 - "$SOURCE_CONFIG" "$TEMP_CONFIG" "$STATICSEARCH_ROOT" <<'PY'
from pathlib import Path
import re
import sys
from xml.sax.saxutils import escape

source, target, root = map(Path, sys.argv[1:])
text = source.read_text(encoding="utf-8")
stopwords = escape(str(root / "xsl" / "english_stopwords.txt"))
dictionary = escape(str(root / "xsl" / "english_words.txt"))
text = re.sub(
    r'<stopwordsFile>.*?</stopwordsFile>',
    f'<stopwordsFile>{stopwords}</stopwordsFile>',
    text,
)
text = re.sub(
    r'<dictionaryFile>.*?</dictionaryFile>',
    f'<dictionaryFile>{dictionary}</dictionaryFile>',
    text,
)
target.write_text(text, encoding="utf-8")
PY

echo "Running Project Endings StaticSearch..."
ant -lib "$ANT_CONTRIB" -f "$RUNNER/build.xml" \
    "-DssConfigFile=$TEMP_CONFIG" allButValidate

# Make names such as con.json and aux.json safe for Git and Windows, patch the
# browser runtime to request the renamed files, and create HTML/search/index.html.
python3 - "$PROJECT_ROOT" <<'PY'
from pathlib import Path
import re
import shutil
import sys

project = Path(sys.argv[1])
output = project / "HTML" / "staticSearch"
stems = output / "stems"
reserved = {"con", "prn", "aux", "nul"}
reserved.update(f"com{i}" for i in range(1, 10))
reserved.update(f"lpt{i}" for i in range(1, 10))

for name in sorted(reserved):
    source = stems / f"{name}.json"
    if source.exists():
        source.replace(stems / f"_{name}.json")
        print(f"Renamed Windows-reserved stem {name}.json to _{name}.json.")

debug_js = output / "ssSearch-debug.js"
text = debug_js.read_text(encoding="utf-8")
text = text.replace(
    "self.jsonDirectory + 'stems/' + stemsToFind[i] + this.versionString + '.json'",
    "self.jsonDirectory + 'stems/' + "
    "(/^(con|prn|aux|nul|com[1-9]|lpt[1-9])$/i.test(stemsToFind[i]) "
    "? '_' + stemsToFind[i] : stemsToFind[i]) + this.versionString + '.json'",
)
debug_js.write_text(text, encoding="utf-8")

min_js = output / "ssSearch.js"
text = min_js.read_text(encoding="utf-8")
text = text.replace(
    'c.jsonDirectory+"stems/"+b[e]+this.versionString+".json"',
    'c.jsonDirectory+"stems/"+'
    '(/^(con|prn|aux|nul|com[1-9]|lpt[1-9])$/i.test(b[e])?"_"+b[e]:b[e])+'
    'this.versionString+".json"',
)
min_js.write_text(text, encoding="utf-8")

search_source = project / "HTML" / "search.html"
search_dir = project / "HTML" / "search"
search_dir.mkdir(parents=True, exist_ok=True)
text = search_source.read_text(encoding="utf-8")
if not re.search(r'<base\s', text):
    text = text.replace('<head>', '<head>\n    <base href="../"/>', 1)
(search_dir / "index.html").write_text(text, encoding="utf-8")

stem_count = len(list(stems.glob("*.json")))
filter_count = len(list((output / "filters").glob("*.json")))
print("StaticSearch build complete.")
print(f"Stem JSON files: {stem_count}")
print(f"Filter JSON files: {filter_count}")
PY
