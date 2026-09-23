# team-index — csapat-áttekintés

Rövid index az aktív agentekről. Ezt nézi meg Rita (`starter-kit:talent-researcher`) átfedés-vizsgálatnál, és a fő-agent, amikor eldönti, kit hívjon. A részletes roster: `README.md`.

## Beépített (plugin)

### HR
- **Rita** (`starter-kit:talent-researcher`) — új agent-igény tisztázása, kutatás, brief-írás. Hívd: „Rita, kéne valami, ami…"
- **Anna** (`starter-kit:agent-architect`) — jóváhagyott brief-ből megírja az agent `.md`-t. Hívd: „Anna, itt a brief, írd meg."

### Üzemeltetés
- **Bea** (`starter-kit:scribe`) — session-záró napló. Hívd: „Bea, zárd le."
- **Ádám** (`starter-kit:status`) — állapotriport. Hívd: „Ádám, hol tartunk az X-szel?"

## Saját kollégák

_Még nincs. Anna ide fűzi az új kollégákat department szerint, egy-egy sorban: **Név** (`technikai-név`) — mit csinál. Hívd: „…"_

## Felvételi folyamat (röviden)

1. A tulajdonos egy mondatban jelzi az igényt **Ritának** (vagy `/starter-kit:new-agent <igény>`).
2. Rita tisztáz, átfedést vizsgál (ez a fájl: beépítettek és sajátok), kutat, brief-et ír.
3. A tulajdonos jóváhagyja, majd a fő-agent átadja **Annának**: „Anna, itt a brief, írd meg."
4. Anna kiírja az `.md`-t a `Csapat/<Department>/` alá, symlinkeli `~/.claude/agents/` alá, frissíti a `README.md`-t és ezt az indexet.

Részletek: `SOPs/SOP-01-agent-konvenciok.md`.
