#!/usr/bin/env bash
# release-notes.sh <from-ref> <to-ref> [version]
# Sinh release notes Markdown từ git history:
#  - Nhóm commit theo Conventional Commits (feat/fix/docs/...) hoặc tiền tố "Lxx:"
#  - Gom các work item được nhắc (#123 hoặc AB#123) và lấy tiêu đề qua az boards (nếu có az CLI)
set -euo pipefail
FROM=${1:?from ref}; TO=${2:-HEAD}; VERSION=${3:-$TO}
DATE=$(git log -1 --format=%cs "$TO")
echo "# Release notes ${VERSION} (${DATE})"
echo
echo "Changes from \`${FROM}\` to \`${TO}\` ($(git rev-list --count --no-merges "${FROM}..${TO}") commits)."
echo
FIX='^fix|[Ff]ix(es|ed)? (AB)?#'
section() { # title, grep-pattern, [exclude-pattern]
  local lines
  lines=$(git log --no-merges --format='%s|%h|%an' "${FROM}..${TO}" | grep -E "$2" | grep -vE "${3:-^$}" || true)
  [ -z "$lines" ] && return 0
  echo "## $1"
  while IFS='|' read -r subj hash author; do echo "- ${subj} (\`${hash}\`, ${author})"; done <<< "$lines"
  echo
}
FEAT='^(feat|L[0-9]+:|Lesson)'
section "Bug fixes"      "$FIX" 
section "Features"       "$FEAT" "$FIX"
section "Documentation"  '^docs' "$FIX"
section "Other"          '.' "$FIX|$FEAT|^docs"
IDS=""   # GitHub version: issue numbers are linked by GitHub itself
if [ -n "$IDS" ]; then
  echo "## Work items"
  for id in $IDS; do
    if command -v az >/dev/null 2>&1; then
      t=$(az boards work-item show --id "$id" --query '[fields."System.WorkItemType", fields."System.Title", fields."System.State"]' -o tsv 2>/dev/null | paste -sd'|' - || true)
      [ -n "$t" ] && { IFS='|' read -r typ title state <<< "$t"; echo "- #${id} ${typ}: ${title} (**${state}**)"; continue; }
    fi
    echo "- #${id}"
  done
  echo
fi
echo "## Contributors"
git shortlog -sn --no-merges "${FROM}..${TO}" | sed 's/^ *\([0-9]*\)\t\(.*\)/- \2 (\1)/'
