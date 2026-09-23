# SOP-01: Agent-fájl konvenciók

**Hatály:** mindenki — különösen Anna (agent-architect) számára kötelező

---

## Szabály

Minden agent-fájl egységes struktúrát, elhelyezést és frontmatter-formátumot követ.

### Frontmatter

```
---
name: <kebab-case-technikai-név>
description: <Persona-név> — <egy mondat arról, MIKOR hívja meg a fő-agent>
tools: <a ténylegesen szükséges eszközök, pl. Read, Write, Edit, Bash, Glob>
model: <haiku / sonnet / opus>
---
```

A `description` a legfontosabb mező: ez alapján dönti el a fő-agent, mikor hívjon. Ha homályos, ritkán fogják használni.

### Szekciórend a system promptban

1. **Bevezető szerepkör** — ki az agent, mi a feladata (1-2 mondat). Kötelező első mondat: *„Te **[Név]** vagy, a csapat [rövid szerep-leírás] tagja."*
2. **Hatókör** — mit csinál, mit **nem**.
3. **Munkafolyamat** — lépések.
4. **Tilalmak** — explicit „ne tedd" lista.
5. **Stílus** — ha szükséges.

### Elhelyezés

Két fajta agent van, és mindkettőnek egy kanonikus helye:

- **Beépített (plugin) kollégák** — Rita (`talent-researcher`), Anna (`agent-architect`), Bea (`scribe`), Ádám (`status`). A starter-kit pluginban élnek, névtérrel hívhatók (`starter-kit:<név>`), és a plugin frissítésével frissülnek. Nem szerkesztjük őket, és saját fájlt sem teszünk a plugin mappájába (frissítéskor felülíródik).
- **Saját kollégák** — a munkaterületen élnek, és egy symlink teszi láthatóvá őket a Claude Code számára:
  - **Kanonikus fájl:** `<munkaterület>/Csapat/<Department>/<név>.md`
  - **Symlink (flat):** `~/.claude/agents/<név>.md` → a kanonikus fájl

```bash
ln -sf "<munkaterület>/Csapat/<Department>/<név>.md" \
       "$HOME/.claude/agents/<név>.md"
```

A `<munkaterület>` helyére mindig az abszolút út kerül (a session eleji kontextus adja meg: `Munkaterület: <út>`). Departmentek: amit a munka igényel (pl. `Fejlesztés`, `Marketing`, `Ügyfél`). Saját agent technikai neve ne egyezzen a beépítettekével. Projekt-specifikus mappába (`<projekt>/.claude/agents/`) **nem** teszünk agentet — minden egy helyen legyen, hogy a struktúra mobilis maradjon (bármely session-ből elérhető).

### Modell-választás

- **haiku** — egyszerű, fókuszált, olvasás/összegzés
- **sonnet** — tervezés, kód, strukturált kimenet
- **opus** — nehéz reasoning, komplex döntés

### Least-privilege eszközök

Minden agent csak a feladatához **ténylegesen** szükséges eszközöket kapja. Olvasó-agent ne kapjon Write-ot; szövegmunkás ne kapjon Bash-t.

## Miért

Az egységes struktúra teszi lehetővé, hogy a fő-agent biztonságosan tudja, melyik agent mikor hívandó, mit csinál és mit nem. A kanonikus fájl + symlink rendszer biztosítja, hogy a Claude Code minden session-ben a friss definíciót lássa, és hogy a saját csapat egy mappa átmásolásával másik gépre költöztethető legyen (a beépítetteket a plugin hozza).

## Hogyan alkalmazd

- **Új agent (Anna):** kövesd a szekciórendet, ne hagyd ki a Tilalmakat. A `description`-ben legyen egyértelmű a mikor.
- **Finomítás (saját agent):** szerkeszd a kanonikus fájlt a department-mappában — a symlink miatt a következő session-indítástól érvényes.
- **Eltávolítás (saját agent):** töröld az `.md`-t **és** a symlinket `~/.claude/agents/` alól.
- **Index frissítése:** minden felvétel/törlés után frissítsd a `Csapat/README.md` és `Csapat/team-index.md` táblázatát.

## Tilalmak

- Duplikált agent meglévő hatókörrel — mindig végezz átfedés-vizsgálatot (`team-index.md`, a beépítettekkel együtt).
- Felesleges eszközök.
- Homályos `description`.
- Brief nélküli agent-írás (a kutatás és brief Rita dolga; Anna kész brief-ből dolgozik).
