#!/bin/bash

# =============================================================
# ULTI-Coin - Claude Code Watcher
# Pokretanje: ./watch.sh
# Skripta prati task.md i automatski pokrece Claude Code
# =============================================================

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TASK_FILE="$REPO_DIR/task.md"
RESULT_FILE="$REPO_DIR/result.md"
LAST_HASH_FILE="$REPO_DIR/.last_task_hash"
LOG_FILE="$REPO_DIR/watcher.log"
CHECK_INTERVAL=30  # sekundi

# Boje za terminal
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "[$(date '+%H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "${GREEN}=== Claude Code Watcher pokrenut ===${NC}"
log "${BLUE}Projekat: $REPO_DIR${NC}"
log "${BLUE}Provjera svakih: ${CHECK_INTERVAL}s${NC}"
log "Izmijeni task.md sa telefona i Claude ce izvrsiti zadatak."
log "Pritisnite Ctrl+C za zaustavljanje."
echo ""

# Inicijalizuj hash ako ne postoji
if [ ! -f "$LAST_HASH_FILE" ]; then
    if [ -f "$TASK_FILE" ]; then
        md5 -q "$TASK_FILE" > "$LAST_HASH_FILE" 2>/dev/null || \
        md5sum "$TASK_FILE" | cut -d' ' -f1 > "$LAST_HASH_FILE"
    fi
fi

while true; do
    # Povuci najnovije promjene sa GitHub-a
    log "${YELLOW}Provjeravam GitHub za nove zadatke...${NC}"

    cd "$REPO_DIR" || exit 1
    git fetch origin --quiet 2>/dev/null

    LOCAL=$(git rev-parse HEAD 2>/dev/null)
    REMOTE=$(git rev-parse origin/$(git branch --show-current) 2>/dev/null)

    if [ "$LOCAL" != "$REMOTE" ]; then
        log "${GREEN}Nova izmjena pronadjena! Preuzimam...${NC}"
        git pull origin "$(git branch --show-current)" --quiet
    fi

    # Provjeri da li se task.md promijenio
    if [ -f "$TASK_FILE" ]; then
        CURRENT_HASH=$(md5 -q "$TASK_FILE" 2>/dev/null || md5sum "$TASK_FILE" | cut -d' ' -f1)
        SAVED_HASH=$(cat "$LAST_HASH_FILE" 2>/dev/null || echo "")

        if [ "$CURRENT_HASH" != "$SAVED_HASH" ]; then
            log "${GREEN}*** Novi zadatak pronadjen! Pokrecem Claude Code... ***${NC}"

            # Procitaj zadatak (preskoči komentare)
            TASK=$(grep -v '^#' "$TASK_FILE" | grep -v '^<!--' | grep -v '^-->' | grep -v '^\s*$' | head -50)

            if [ -z "$TASK" ]; then
                log "${RED}Zadatak je prazan. Preskacem.${NC}"
            else
                log "${BLUE}Zadatak: $TASK${NC}"

                # Sacuvaj novi hash
                echo "$CURRENT_HASH" > "$LAST_HASH_FILE"

                # Azuriraj result.md - "u toku"
                cat > "$RESULT_FILE" << RESULT_EOF
# Rezultat

**Status:** Izvrsavam...
**Zadatak:** $TASK
**Poceto:** $(date '+%d.%m.%Y u %H:%M:%S')

---

*Claude Code radi na zadatku...*
RESULT_EOF

                git add "$RESULT_FILE"
                git commit -m "status: u toku - $(date '+%H:%M')" --quiet
                git push origin "$(git branch --show-current)" --quiet

                # Pokreni Claude Code sa zadatkom
                log "${GREEN}Pokrenjem: claude -p \"$TASK\"${NC}"

                CLAUDE_OUTPUT=$(claude -p "$TASK" 2>&1)
                EXIT_CODE=$?

                # Sacuvaj rezultat
                if [ $EXIT_CODE -eq 0 ]; then
                    STATUS="Uspjesno zavrseno"
                    log "${GREEN}Zadatak uspjesno zavrsen!${NC}"
                else
                    STATUS="Greska (kod: $EXIT_CODE)"
                    log "${RED}Greska pri izvrsavanju!${NC}"
                fi

                cat > "$RESULT_FILE" << RESULT_EOF
# Rezultat

**Status:** $STATUS
**Zadatak:** $TASK
**Zavrseno:** $(date '+%d.%m.%Y u %H:%M:%S')

---

## Izlaz:

\`\`\`
$CLAUDE_OUTPUT
\`\`\`
RESULT_EOF

                # Commituj i pushaj rezultat
                git add "$RESULT_FILE"
                git commit -m "rezultat: $(date '+%H:%M') - $STATUS" --quiet
                git push origin "$(git branch --show-current)" --quiet

                log "${GREEN}Rezultat sacuvan u result.md${NC}"
            fi
        fi
    fi

    log "Sljedeca provjera za ${CHECK_INTERVAL}s... ($(date '+%H:%M:%S'))"
    sleep "$CHECK_INTERVAL"
done
