# Csapat — az agentek irodája

*A fő-agent (Máté) az orchestrator: koordinál és delegál, nem maga dolgozik. A kollégák két helyről jönnek: a **beépítettek** a starter-kit pluginban élnek (a plugin frissítésével frissülnek), a **saját kollégáid** ebben a mappában, department-szerinti almappákban. A saját kollégákat symlinkek teszik láthatóvá a Claude Code számára `~/.claude/agents/` alatt (flat).*

Rövid index és felvételi folyamat: [team-index.md](team-index.md).

---

## Beépített (plugin)

Ezek a starter-kit plugin részei, névtérrel hívhatók (`starter-kit:<név>`), és nem ütköznek a saját agentjeiddel. Ne szerkeszd őket a plugin mappájában: frissítéskor felülíródnak.

### HR
| Név | Agent | Mikor hívd | Modell | Eszközök |
|---|---|---|---|---|
| Rita | `starter-kit:talent-researcher` | „kéne valami…" igényre, vagy bizonytalan brief esetén | sonnet | Read, Glob, Grep, WebSearch, WebFetch |
| Anna | `starter-kit:agent-architect` | Rita brief-je után — „Anna, itt a brief, írd meg" | sonnet | Read, Write, Edit, Bash, Glob |

### Üzemeltetés
| Név | Agent | Mikor hívd | Modell | Eszközök |
|---|---|---|---|---|
| Bea | `starter-kit:scribe` | Session végén — „Bea, zárd le" | haiku | Read, Edit, Bash |
| Ádám | `starter-kit:status` | „Ádám, hol tartunk az X-szel?" | haiku | Read, Grep, Glob, Bash |

---

## Saját kollégák — department szerint

*Még üres. Az első saját kolléga felvétele után ide kerülnek a department-szekciók (pl. `Fejlesztés`, `Marketing`) és soraik, ugyanebben a táblázat-formában: Név · Agent · Mikor hívd · Modell · Eszközök.*

---

## Karbantartás

- **Új agent felvétele:** mondd el **Ritának** egy mondatban az igényt (vagy `/starter-kit:new-agent <igény>`). Rita tisztáz, kutat, brief-et ír (department-javaslattal). **Anna** a jóváhagyott brief alapján kiír egy új `.md`-t a megfelelő department-mappába ide, a `Csapat/` alá, symlinkeli `~/.claude/agents/` alá, és frissíti ezt a README-t és a `team-index.md`-t.
- **Saját agent finomítása:** editáld a `.md`-t a department-mappában. A symlink miatt a Claude Code a legközelebbi session-induláskor látja a változást.
- **Saját agent eltávolítása:** töröld az `.md`-t a department-mappából **és** a symlinket `~/.claude/agents/` alól.
- **Department-átsorolás:** `mv` a fájlt a célmappába, majd `ln -sf` a frissített célútra a symlinken.
- **Beépített agent:** nem szerkeszthető itt. Ha másképp működne, vegyél fel saját kollégát a kívánt viselkedéssel, más technikai névvel.

## Felépítés-elv

**Minden saját agent egy helyen — projekt-specifikus mappákba NEM tesszük** (mobilis könyvtárstruktúra: bármely session-ből elérhető legyen).

- **Kanonikus fájl:** `<munkaterület>/Csapat/<Department>/<név>.md`
- **Symlink (flat):** `~/.claude/agents/<név>.md` → a kanonikus fájl

Új symlink kézzel:
```bash
ln -sf "<munkaterület>/Csapat/<Department>/<név>.md" \
       "$HOME/.claude/agents/<név>.md"
```

## Konvenciók a system promptokban

Részletesen: `../SOPs/SOP-01-agent-konvenciok.md`. Röviden:
- **Magyar nyelv**, tömör, AI-szavak nélkül (→ SOP-04).
- **Szekciórend:** bevezető szerepkör → hatókör → munkafolyamat → tilalmak → stílus.
- **Első mondat:** „Te **[Név]** vagy, a csapat [szerep] tagja."
- **Least-privilege eszközök**, egyértelmű `description` mező.
