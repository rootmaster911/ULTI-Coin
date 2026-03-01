# ULTI-Coin - Claude Code iMac Konekcija

## Kako se povezati na Claude Code sa iMac-a

### Preduslov / Prerequisites

- macOS 12 (Monterey) ili noviji
- Node.js 18+ instaliran
- Git instaliran
- Anthropic API ključ

---

## Korak 1: Instalacija Claude Code CLI

Otvorite **Terminal** na iMac-u i pokrenite:

```bash
npm install -g @anthropic-ai/claude-code
```

Provjerite instalaciju:

```bash
claude --version
```

---

## Korak 2: Autentifikacija

Pokrenite Claude Code i autentifikujte se:

```bash
claude
```

Ili postav­ite API ključ direktno:

```bash
export ANTHROPIC_API_KEY="your-api-key-here"
```

Da biste trajno sačuvali ključ, dodajte ga u `~/.zshrc` (macOS koristi zsh):

```bash
echo 'export ANTHROPIC_API_KEY="your-api-key-here"' >> ~/.zshrc
source ~/.zshrc
```

---

## Korak 3: Kloniranje repozitorijuma

```bash
git clone https://github.com/rootmaster911/ULTI-Coin.git
cd ULTI-Coin
```

---

## Korak 4: Pokretanje Claude Code u projektu

```bash
cd ULTI-Coin
claude
```

---

## Korak 5: Konfiguracija (opciono)

Kreirajte `.claude/settings.json` u projektu za prilagođene postavke:

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(npm:*)",
      "Read(*)",
      "Write(*)",
      "Edit(*)"
    ]
  }
}
```

---

## Troubleshooting / Rješavanje problema

### Problem: `claude: command not found`

```bash
# Provjerite da li je npm/node instaliran
node --version
npm --version

# Pokušajte sa sudo
sudo npm install -g @anthropic-ai/claude-code
```

### Problem: API greška autentifikacije

```bash
# Provjerite API ključ
echo $ANTHROPIC_API_KEY

# Ponovo postavite ključ
claude config set apiKey "your-api-key-here"
```

### Problem: Git permission

```bash
# Provjerite SSH ključ za GitHub
ssh -T git@github.com

# Ako nemate SSH ključ, kreirajte ga
ssh-keygen -t ed25519 -C "your-email@example.com"
cat ~/.ssh/id_ed25519.pub
# Dodajte ovaj ključ na GitHub: Settings > SSH and GPG keys
```

---

## Brzi start na iMac-u

```bash
# 1. Instalirajte Claude Code
npm install -g @anthropic-ai/claude-code

# 2. Postavite API ključ
export ANTHROPIC_API_KEY="sk-ant-..."

# 3. Klonirajte i otvorite projekat
git clone https://github.com/rootmaster911/ULTI-Coin.git
cd ULTI-Coin

# 4. Pokrenite Claude Code
claude
```

---

## Korisni linkovi

- [Claude Code dokumentacija](https://docs.anthropic.com/en/docs/claude-code)
- [Anthropic Console (API ključevi)](https://console.anthropic.com)
- [GitHub repozitorijum](https://github.com/rootmaster911/ULTI-Coin)
