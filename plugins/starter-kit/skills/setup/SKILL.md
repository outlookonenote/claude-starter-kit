---
name: setup
description: A starter kit munkaterületének létrehozása vagy újrafuttatása. Megkérdezi a munkaterület helyét és a fő-agent nevét, a sablont felülírás nélkül bemásolja (a rejtett .claude mappával együtt), beírja a nevet a CLAUDE.md-be, és elmenti a munkaterület útját a plugin configjába. Akkor használd, ha a felhasználó most telepítette a plugint, vagy a session eleji kontextus szerint nincs beállított munkaterület.
argument-hint: "[hely: <mappa>] [név: <fő-agent neve>]"
---

# Munkaterület beállítása

A feladatod a starter kit munkaterületének létrehozása (vagy biztonságos újrafuttatása). Magyarul, tömören beszélj a felhasználóval.

Fix utak ebben a telepítésben (a parancsokban szó szerint ezeket használd, ne környezeti változót):

- Plugin mappa: `${CLAUDE_PLUGIN_ROOT}`
- Plugin adatmappa (itt él a config): `${CLAUDE_PLUGIN_DATA}`
- Telepítő szkript: `${CLAUDE_PLUGIN_ROOT}/scripts/setup-workspace.sh`

A felhasználó által megadott argumentumok (lehet üres): `$ARGUMENTS`

## 1. Van már munkaterület?

Nézd meg a configot:

```bash
cat "${CLAUDE_PLUGIN_DATA}/config" 2>/dev/null
```

Ha van benne `workspace=<út>` sor, és az a mappa létezik (`ls -d "<út>"`), akkor már van beállított munkaterület. Ezt mondd el a felhasználónak (az úttal együtt), és **kérdezd meg, mielőtt bármit teszel**: újrafuttassuk ugyanoda (csak a hiányzó sablonfájlok pótlódnak, meglévő fájl nem íródik felül), vagy új helyre állítsuk. Kivétel: ha az argumentumokban a felhasználó ugyanezt a helyet adta meg, az megerősített újrafuttatásnak számít, kérdezés nélkül folytathatod (a szkript semmit nem ír felül).

## 2. Hely és név

Ha az argumentumok tartalmazzák (pl. `hely: ~/Documents/Munkaterulet, név: Máté`), használd azokat, és ne kérdezz rá újra. Ami hiányzik, azt egy üzenetben kérdezd meg:

- **A munkaterület helye.** Alapértelmezés: `~/Documents/Munkaterulet`. Ez egy mappa, ahol a jegyzeteid, szabályaid, saját kollégáid élnek.
- **A fő-agent neve** (aki koordinál és delegál). Alapértelmezés: `Máté`.

Ha a felhasználó csak annyit mond, hogy „jó az alapértelmezés", használd a fenti értékeket.

## 3. Telepítés

Futtasd a szkriptet (az utat idézőjelek között add át, lehet benne szóköz vagy ékezet; a `~` is megengedett):

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup-workspace.sh" "${CLAUDE_PLUGIN_DATA}" "<hely>" "<név>"
```

A szkript:
- a sablont (rejtett `.claude` mappával együtt) bemásolja, de **meglévő fájlt soha nem ír felül**;
- a fő-agent nevét csak az általa most létrehozott fájlokban cseréli;
- a munkaterület abszolút útját beírja a `${CLAUDE_PLUGIN_DATA}/config` fájlba.

Ne másolj kézzel, és ne írj a felhasználó globális beállításaiba (`~/.claude/settings.json`), engedélyeket se adj hozzá.

Ellenőrzésként listázd a munkaterületet rejtett fájlokkal együtt (`ls -la "<abszolút út>"`), és foglald össze a szkript kimenete alapján: hány új fájl jött létre, mi maradt érintetlen.

## 4. Git (felajánlás)

Ha a szkript szerint a munkaterület még nem git-repó, ajánld fel a `git init`-et (a verziókövetés jól jön a jegyzeteknek és szabályoknak). Csak igenlő válasz után futtasd, és **ne commitolj**. Jelezd: vadonatúj Macen a legelső `git` parancs elindíthatja az Xcode Command Line Tools telepítését egy rendszerablakban; ez normális, meg kell várni, amíg végez. Ha az argumentumok alapján nem interaktív a futás (nincs kinek válaszolnia), a git-et csak ajánld, ne futtasd.

## 5. Zárás

Mondd el röviden:

1. Kész a munkaterület: `<abszolút út>`.
2. **A jövőben a munkaterület mappájából indítsd a `claude`-ot** (`cd "<abszolút út>"`, majd `claude`), mert a fő-agent szabályait tartalmazó `CLAUDE.md` csak ott töltődik be.
3. Ajánld fel, hogy **rögtön jöhet az onboarding** (`/starter-kit:onboard`): pár kérdéskörben megismerlek, és kitöltöm az `About Me/rolam.md`-t. Ha a felhasználó igent mond, hívd meg a `starter-kit:onboard` skillt.
