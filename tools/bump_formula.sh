#!/usr/bin/env bash
#
# Bump the tinybridge Homebrew formula to a new release.
#
# Rewrites the `url` and `sha256` lines of Formula/tinybridge.rb so the
# release tarball and its checksum always move together. Called by the
# bump-formula GitHub workflow on a `tinybridge-release` repository_dispatch,
# but runnable by hand too:
#
#   tools/bump_formula.sh 0.6.3 <sha256>
#   tools/bump_formula.sh 0.6.3 <sha256> --dry-run
#
set -euo pipefail

REPO="Mullassery/tinybridge"
TARGET="aarch64-apple-darwin"

usage() {
  echo "usage: $0 <version> <sha256> [--dry-run] [formula_path]" >&2
  exit 2
}

VERSION="${1:-}"
SHA="${2:-}"
[ -n "$VERSION" ] && [ -n "$SHA" ] || usage
shift 2

DRY_RUN=0
FORMULA=""
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -*) echo "unknown flag: $arg" >&2; usage ;;
    *) FORMULA="$arg" ;;
  esac
done
FORMULA="${FORMULA:-$(cd "$(dirname "$0")/.." && pwd)/Formula/tinybridge.rb}"

# Strip a leading v so both `0.6.3` and `v0.6.3` are accepted.
VERSION="${VERSION#v}"

if ! printf '%s' "$VERSION" | grep -Eq '^[0-9]+\.[0-9]+\.[0-9]+([.-][0-9A-Za-z.]+)?$'; then
  echo "error: '$VERSION' does not look like a version" >&2
  exit 1
fi
if ! printf '%s' "$SHA" | grep -Eq '^[0-9a-f]{64}$'; then
  echo "error: '$SHA' is not a 64-character lowercase hex sha256" >&2
  exit 1
fi
if [ ! -f "$FORMULA" ]; then
  echo "error: formula not found at $FORMULA" >&2
  exit 1
fi

NEW_URL="https://github.com/$REPO/releases/download/v$VERSION/tinybridge-$VERSION-$TARGET.tar.gz"

if ! grep -q '^  url ' "$FORMULA"; then
  echo "error: no 'url' line found in $FORMULA" >&2
  exit 1
fi
if ! grep -q '^  sha256 ' "$FORMULA"; then
  echo "error: no 'sha256' line found in $FORMULA" >&2
  exit 1
fi

TMP="$(mktemp)"
trap 'rm -f "$TMP"' EXIT
sed \
  -e "s|^  url .*|  url \"$NEW_URL\"|" \
  -e "s|^  sha256 .*|  sha256 \"$SHA\"|" \
  "$FORMULA" > "$TMP"

if cmp -s "$FORMULA" "$TMP"; then
  echo "Formula already at $VERSION ($SHA) — nothing to do."
  exit 0
fi

if [ "$DRY_RUN" -eq 1 ]; then
  echo "--- dry run: $FORMULA"
  diff -u "$FORMULA" "$TMP" || true
  echo "--- url would be: $NEW_URL"
  exit 0
fi

cp "$TMP" "$FORMULA"
echo "Bumped $(basename "$FORMULA") to $VERSION ($SHA)"
echo "  url: $NEW_URL"
