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
- **Saját kollégák** — a munkaterület `.claude/agents/` mappájában élnek:
  - **Agent-fájl:** `<munkaterület>/.claude/agents/<Department>/<név>.md`

A Claude Code ezt a mappát (az almappákkal együtt) akkor tölti be, ha a `claude`-ot a munkaterületből indítják. Symlinket nem használunk, és a `~/.claude/agents/` alá sem írunk. A `<munkaterület>` helyére mindig az abszolút út kerül (a session eleji kontextus adja meg: `Munkaterület: <út>`). Departmentek: amit a munka igényel (pl. `Fejlesztés`, `Marketing`, `Ügyfél`). Saját agent technikai neve ne egyezzen a beépítettekével, és a departmentek között se ismétlődjön. Más projektek mappájába (`<projekt>/.claude/agents/`) **nem** teszünk agentet: a saját csapat egy helyen, a munkaterületen él.

### Modell-választás

- **haiku** — egyszerű, fókuszált, olvasás/összegzés
- **sonnet** — tervezés, kód, strukturált kimenet
- **opus** — nehéz reasoning, komplex döntés

### Least-privilege eszközök

Minden agent csak a feladatához **ténylegesen** szükséges eszközöket kapja. Olvasó-agent ne kapjon Write-ot; szövegmunkás ne kapjon Bash-t.

## Miért

Az egységes struktúra teszi lehetővé, hogy a fő-agent biztonságosan tudja, melyik agent mikor hívandó, mit csinál és mit nem. Mivel a saját kollégák a munkaterületen belül élnek, a Claude Code minden munkaterületi sessionben a friss definíciót látja, symlink vagy másolat nélkül (Windowson is), és a saját csapat a munkaterület mappájával együtt másik gépre költöztethető (a beépítetteket a plugin hozza).

## Hogyan alkalmazd

- **Új agent (Anna):** kövesd a szekciórendet, ne hagyd ki a Tilalmakat. A `description`-ben legyen egyértelmű a mikor.
- **Finomítás (saját agent):** szerkeszd a fájlt a `.claude/agents/<Department>/` mappában; a következő session-indítástól érvényes.
- **Eltávolítás (saját agent):** töröld az `.md`-t a `.claude/agents/<Department>/` mappából.
- **Index frissítése:** minden felvétel/törlés után frissítsd a `Csapat/README.md` és `Csapat/team-index.md` táblázatát.

## Tilalmak

- Duplikált agent meglévő hatókörrel — mindig végezz átfedés-vizsgálatot (`team-index.md`, a beépítettekkel együtt).
- Felesleges eszközök.
- Homályos `description`.
- Brief nélküli agent-írás (a kutatás és brief Rita dolga; Anna kész brief-ből dolgozik).
