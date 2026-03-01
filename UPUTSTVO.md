# Kako koristiti - Telefon → iMac Claude Code

## Koncept

```
📱 Telefon                    💻 iMac
   |                             |
   | Izmijeni task.md            |
   | na GitHub-u                 |
   |→→→→→→→→→→→→→→→→→→→→→→→→→→→|
                                 | watch.sh detektuje promjenu
                                 | Claude Code izvrsava zadatak
                                 | Rezultat → result.md
   |←←←←←←←←←←←←←←←←←←←←←←←←|
   | Provjeri result.md          |
   | na GitHub-u                 |
```

---

## Podesavanje na iMac-u (jednom)

### 1. Kloniraj repozitorijum

```bash
git clone https://github.com/rootmaster911/ULTI-Coin.git
cd ULTI-Coin
```

### 2. Instaliraj Claude Code (ako nije)

```bash
npm install -g @anthropic-ai/claude-code
```

### 3. Postavi API kljuc

```bash
echo 'export ANTHROPIC_API_KEY="sk-ant-TVOJ_KLJUC"' >> ~/.zshrc
source ~/.zshrc
```

### 4. Daj dozvolu skripti

```bash
chmod +x watch.sh
```

### 5. Pokreni watcher

```bash
./watch.sh
```

**Ostavi Terminal otvoren!** Skripta ceka tvoje komande sa telefona.

---

## Koriscenje sa telefona

### Korak 1: Otvori GitHub app ili browser

Idi na: `github.com/rootmaster911/ULTI-Coin`

### Korak 2: Otvori `task.md`

Klikni na fajl `task.md`

### Korak 3: Uredi fajl

- GitHub app: klikni olovku (edit)
- Browser: klikni pencil ikonu

### Korak 4: Napisi zadatak

Primjeri:
```
Napravi novi fajl hello.py koji ispisuje Hello World
```
```
Dodaj README sekciju o instalaciji
```
```
Provjeri da li ima gresaka u kodu i popravi ih
```

### Korak 5: Snimi (Commit changes)

- GitHub app: "Commit changes"
- Browser: zeleno dugme "Commit changes"

### Korak 6: Sacekaj ~30 sekundi

iMac detektuje promjenu i Claude izvrsava zadatak.

### Korak 7: Provjeri rezultat

Otvori `result.md` na GitHub-u da vidis sta je Claude uradio.

---

## Primjeri zadataka

| Sto napises na telefonu | Sta Claude uradi na iMacu |
|------------------------|---------------------------|
| `Napravi fajl test.txt` | Kreira fajl |
| `Dodaj komentare u kod` | Edituje kod |
| `Pokreni npm install` | Instalira pakete |
| `Provjeri greske` | Analizira i popravlja |
| `Napravi novi feature X` | Implementira feature |

---

## Napomene

- Watcher provjerava GitHub **svakih 30 sekundi**
- Rezultat se pojavljuje u `result.md` nakon izvrsavanja
- Log se cuva u `watcher.log`
- Za zaustavljanje: `Ctrl+C` u Terminalu na iMac-u
