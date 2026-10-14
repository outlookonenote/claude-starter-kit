# Csapat — az agentek irodája

*A fő-agent (Máté) az orchestrator: koordinál és delegál, nem maga dolgozik. A kollégák két helyről jönnek: a **beépítettek** a starter-kit pluginban élnek (a plugin frissítésével frissülnek), a **saját kollégáid** a munkaterület `.claude/agents/` mappájában, department szerinti almappákban. Ez a mappa (`Csapat/`) a névjegyzék: ki kicsoda, kit mikor hívj.*

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

- **Új agent felvétele:** mondd el **Ritának** egy mondatban az igényt (vagy `/starter-kit:new-agent <igény>`). Rita tisztáz, kutat, brief-et ír (department-javaslattal). **Anna** a jóváhagyott brief alapján kiír egy új `.md`-t a `.claude/agents/<Department>/` mappába, és frissíti ezt a README-t és a `team-index.md`-t.
- **Saját agent finomítása:** szerkeszd a `.md`-t a `.claude/agents/<Department>/` mappában. A Claude Code a következő session-induláskor látja a változást.
- **Saját agent eltávolítása:** töröld az `.md`-t a `.claude/agents/<Department>/` mappából, és vedd ki a sorát ebből a README-ből és a `team-index.md`-ből.
- **Department-átsorolás:** helyezd át a fájlt egy másik almappába a `.claude/agents/` alatt.
- **Beépített agent:** nem szerkeszthető itt. Ha másképp működne, vegyél fel saját kollégát a kívánt viselkedéssel, más technikai névvel.

## Felépítés-elv

**Minden saját agent egy helyen, a munkaterületen belül:**

- **Agent-fájl:** `<munkaterület>/.claude/agents/<Department>/<név>.md`

A Claude Code a munkaterület `.claude/agents/` mappáját (az almappákkal együtt) akkor tölti be, ha a `claude`-ot a munkaterületből vagy annak egy almappájából indítod. Nincs symlink és nincs másolat, így minden rendszeren (macOS, Windows, Linux) ugyanúgy működik, és a munkaterület mappájával együtt költözik. A `.claude` mappa rejtett lehet: macOS Finderben a Cmd+Shift+. mutatja meg.

## Konvenciók a system promptokban

Részletesen: `../SOPs/SOP-01-agent-konvenciok.md`. Röviden:
- **Magyar nyelv**, tömör, AI-szavak nélkül (→ SOP-04).
- **Szekciórend:** bevezető szerepkör → hatókör → munkafolyamat → tilalmak → stílus.
- **Első mondat:** „Te **[Név]** vagy, a csapat [szerep] tagja."
- **Least-privilege eszközök**, egyértelmű `description` mező.
