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
- Áthelyező szkript (régi saját kollégákhoz): `${CLAUDE_PLUGIN_ROOT}/scripts/migrate-agents.sh`

A felhasználó által megadott argumentumok (lehet üres): `$ARGUMENTS`

## 1. Van már munkaterület?

Nézd meg a configot:

```bash
cat "${CLAUDE_PLUGIN_DATA}/config" 2>/dev/null
```

Ha van benne `workspace=<út>` sor, és az a mappa létezik (`ls -d "<út>"`), akkor már van beállított munkaterület. Ezt mondd el a felhasználónak (az úttal együtt), és **kérdezd meg, mielőtt bármit teszel**: újrafuttassuk ugyanoda (csak a hiányzó sablonfájlok pótlódnak, meglévő fájl nem íródik felül), vagy új helyre állítsuk. Kivétel: ha az argumentumokban a felhasználó ugyanezt a helyet adta meg, az megerősített újrafuttatásnak számít, kérdezés nélkül folytathatod (a szkript semmit nem ír felül).

## 2. Hely és név

Ha az argumentumok tartalmazzák (pl. `hely: ~/Documents/Munkaterulet, név: Máté`), használd azokat, és ne kérdezz rá újra. Ami hiányzik, azt egy üzenetben kérdezd meg:

- **A munkaterület helye.** Alapértelmezés: `~/Documents/Munkaterulet`, Windowson `~/Munkaterulet` (a Windows a Dokumentumok mappát gyakran a OneDrive-ba szinkronizálja, ami zavarhatja a munkát). Ez egy mappa, ahol a jegyzeteid, szabályaid, saját kollégáid élnek. Windowson a `C:\Users\...` alakú út is jó.
- **A fő-agent neve** (aki koordinál és delegál). Alapértelmezés: `Máté`.

Ha a felhasználó csak annyit mond, hogy „jó az alapértelmezés", használd a fenti értékeket.

## 3. Telepítés

Futtasd a szkriptet (az utat idézőjelek között add át, lehet benne szóköz vagy ékezet; a `~` is megengedett, Windowson a `C:\...` alak is):

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup-workspace.sh" "${CLAUDE_PLUGIN_DATA}" "<hely>" "<név>"
```

A szkript:
- a sablont (rejtett `.claude` mappával együtt) bemásolja, de **meglévő fájlt soha nem ír felül**;
- a fő-agent nevét csak az általa most létrehozott fájlokban cseréli;
- a munkaterület abszolút útját beírja a `${CLAUDE_PLUGIN_DATA}/config` fájlba.

Ne másolj kézzel, és ne írj a felhasználó globális beállításaiba (`~/.claude/settings.json`), engedélyeket se adj hozzá.

Ellenőrzésként listázd a munkaterületet rejtett fájlokkal együtt (`ls -la "<abszolút út>"`), és foglald össze a szkript kimenete alapján: hány új fájl jött létre, mi maradt érintetlen.

## 4. Régi elhelyezésű saját kollégák (csak 0.1.x-ről frissítésnél)

Ha a szkript kimenetében szerepel a „Régi elhelyezésű saját kollégák" sor, a 0.1.x verzió még a `Csapat/<Department>/` alá írta a saját kollégákat, és a `~/.claude/agents/` alól symlink mutatott rájuk. A 0.2.0-tól a helyük a munkaterület `.claude/agents/<Department>/` mappája. Először csak nézd meg a tervet (ez semmit nem változtat):

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/migrate-agents.sh" "<abszolút út>"
```

Mutasd meg a felhasználónak a tervet, és **kérdezd meg, áthelyezheted-e**. Csak igenlő válasz után futtasd `--apply` kapcsolóval:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/migrate-agents.sh" "<abszolút út>" --apply
```

A szkript a fájlokat áthelyezi (nem törli), a `~/.claude/agents/` alól pedig csak azt a bejegyzést veszi ki, ami symlink az adott fájlra, vagy vele azonos tartalmú másolat. A nem agent-fájlokat (például egy `README.md`-t) a helyükön hagyja. Ami eltér, azt érintetlenül hagyja és jelzi; ezeket mutasd meg a felhasználónak, és ne törölj semmit kérés nélkül. Ha a felhasználó nem kéri az áthelyezést, a régi kollégák a symlinkeken át továbbra is működnek.

## 5. Git (felajánlás)

Ha a szkript szerint a munkaterület még nem git-repó, ajánld fel a `git init`-et (a verziókövetés jól jön a jegyzeteknek és szabályoknak). Csak igenlő válasz után futtasd, és **ne commitolj**. Jelezd: vadonatúj Macen a legelső `git` parancs elindíthatja az Xcode Command Line Tools telepítését egy rendszerablakban; ez normális, meg kell várni, amíg végez. Ha az argumentumok alapján nem interaktív a futás (nincs kinek válaszolnia), a git-et csak ajánld, ne futtasd.

## 6. Zárás

Mondd el röviden:

1. Kész a munkaterület: `<abszolút út>`.
2. **A jövőben a munkaterület mappájából indítsd a `claude`-ot** (`cd "<abszolút út>"`, majd `claude`), mert a fő-agent szabályait tartalmazó `CLAUDE.md` csak ott töltődik be.
3. Ajánld fel, hogy **rögtön jöhet az onboarding** (`/starter-kit:onboard`): pár kérdéskörben megismerlek, és kitöltöm az `About Me/rolam.md`-t. Ha a felhasználó igent mond, hívd meg a `starter-kit:onboard` skillt.
