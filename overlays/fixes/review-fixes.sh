#!/usr/bin/env bash
# Review script for overlay fixes
# This script helps you review and maintain overlay fixes

set -euo pipefail

FIXES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Overlay Fixes Review ===${NC}\n"

# Get list of all fix files (excluding template and this script)
fixes=()
while IFS= read -r -d '' file; do
    fixes+=("$file")
done < <(find "$FIXES_DIR" -name "*.nix" -not -name "_template.nix" -print0 | sort -z)

if [ ${#fixes[@]} -eq 0 ]; then
    echo -e "${GREEN}No active fixes found!${NC}"
    exit 0
fi

echo -e "${YELLOW}Found ${#fixes[@]} active fix(es)${NC}\n"

for fix in "${fixes[@]}"; do
    filename=$(basename "$fix")
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}Fix: ${filename}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    # Extract and display metadata
    issue=$(grep "^# Issue:" "$fix" 2>/dev/null | sed 's/^# Issue: //' || echo "N/A")
    workaround=$(grep "^# Workaround:" "$fix" 2>/dev/null | sed 's/^# Workaround: //' || echo "N/A")
    status=$(grep "^# Status:" "$fix" 2>/dev/null | sed 's/^# Status: //' || echo "N/A")
    last_checked=$(grep "^# Last checked:" "$fix" 2>/dev/null | sed 's/^# Last checked: //' || echo "Never")

    echo -e "${YELLOW}Issue:${NC} $issue"
    echo -e "${YELLOW}Workaround:${NC} $workaround"
    echo -e "${YELLOW}Status:${NC} $status"
    echo -e "${YELLOW}Last checked:${NC} $last_checked"

    # Calculate days since last check
    if [ "$last_checked" != "Never" ]; then
        if date -d "$last_checked" &>/dev/null; then
            last_check_epoch=$(date -d "$last_checked" +%s)
            now_epoch=$(date +%s)
            days_ago=$(( (now_epoch - last_check_epoch) / 86400 ))

            if [ $days_ago -gt 90 ]; then
                echo -e "${RED}⚠ Last checked $days_ago days ago - consider reviewing${NC}"
            elif [ $days_ago -gt 30 ]; then
                echo -e "${YELLOW}⚡ Last checked $days_ago days ago${NC}"
            else
                echo -e "${GREEN}✓ Recently checked ($days_ago days ago)${NC}"
            fi
        fi
    else
        echo -e "${RED}⚠ Never checked - please add 'Last checked' date${NC}"
    fi

    # Show packages affected
    echo -e "\n${YELLOW}Affected packages:${NC}"
    # Extract package names (simple heuristic - lines with = that aren't comments)
    grep -E "^[[:space:]]*[a-zA-Z0-9_-]+ =" "$fix" | sed 's/=.*//' | sed 's/^[[:space:]]*/  • /' || echo "  (Could not parse)"

    echo ""
done

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "\n${YELLOW}Maintenance Actions:${NC}"
echo -e "1. Test each fix by commenting it out in overlays/default.nix"
echo -e "2. Run: ${GREEN}nix build .#nixosConfigurations.HOSTNAME.config.system.build.toplevel${NC}"
echo -e "3. If build succeeds, the fix may no longer be needed"
echo -e "4. Update 'Last checked' dates in fix files"
echo -e "5. Remove obsolete fixes and update import list"
echo -e "\n${BLUE}See README.md for detailed maintenance guide${NC}\n"
