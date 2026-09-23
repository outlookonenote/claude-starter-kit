# SOP-03: Session-ritmus — kezdés és zárás

**Hatály:** a fő-agent (Máté) és Bea (scribe)

---

## Szabály

Minden érdemi munkamenetnek van eleje és vége. A **kezdés** betölti a kontextust, a **zárás** megőrzi, ami történt — így a következő session nem nulláról indul.

### Session-kezdés (`/starter-kit:start-session`)

A munka elején a fő-agent tömör eligazítást ad:

1. Elolvassa az `About Me/rolam.md`-t (ki a tulajdonos, preferenciák).
2. Megnézi a legutóbbi napló-bejegyzést (`Notes/session-log.md`), hogy hol maradt abba a munka.
3. Átnézi a nyitott feladatokat (`Tasks/`).
4. Rövid összefoglalót ad: hol tartunk, mi a nyitott, mi a javasolt következő lépés.

Ez opcionálisan témára szűkíthető (pl. „kezdjük, de csak az X projekttel").

### Session-zárás (`/starter-kit:end-session`)

A munka végén, ha érdemi haladás, döntés vagy új információ született:

1. A fő-agent **felajánlja az öntanulást** (`SOP-00`): van-e valami, amit szabályként rögzítsünk?
2. Meghívja **Beát** (`starter-kit:scribe`): egy dátumozott bejegyzést fűz a naplóhoz (append-only).
3. A bejegyzés röviden: mi történt, milyen döntés született, mi a nyitott szál.

## Miért

Az AI nem emlékszik a beszélgetések között. A napló a folytonosság: a következő session-ben a fő-agent a naplóból tudja, hol maradtatok, döntés-vitákat nem kell újrajátszani, és a félkész munka nem vész el. A kezdő eligazítás pedig percek alatt visszahelyez a kontextusba.

## Hogyan alkalmazd

- A napló helye alapból `Notes/session-log.md` (havi bontás is lehet: `Notes/_session-log/ÉÉÉÉ-HH.md`). A helyet a tulajdonos szabja meg — a lényeg, hogy **egy** kanonikus helyen legyen, és append-only.
- A feladatkövetés lehet a `Tasks/` mappa markdown-listája, egy külső eszköz (Jira, Todoist, Notion), vagy bármi — a session-ritmus ettől független. A `/starter-kit:start-session` onnan olvassa a nyitottakat, ahol a tulajdonos tartja őket.
- Ne naplózz üres session-t. Ha nem történt érdemi dolog, a zárás elmarad.

## Tilalmak

- Meglévő napló-bejegyzés átírása (Bea **append-only** — soha nem módosít korábbit).
- Zárás öntanulás-felajánlás nélkül, ha közben szabályszerű döntés született.
