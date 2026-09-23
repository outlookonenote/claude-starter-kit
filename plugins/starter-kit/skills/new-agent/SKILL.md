---
name: new-agent
description: Új saját kolléga (agent) felvétele a csapatba. Végigviszi a felvételt - Rita (starter-kit:talent-researcher) tisztáz és brief-et ír, a tulajdonos jóváhagyja, Anna (starter-kit:agent-architect) megírja az agentet a munkaterületre, symlinkeli és frissíti a csapat-indexet. Akkor használd, ha a felhasználó egy új, visszatérő feladathoz szeretne agentet ("kéne valami, ami...").
argument-hint: "<az igény egy mondatban>"
---

# Új kolléga felvétele

Az igény a felhasználótól, egy mondatban: `$ARGUMENTS`

Ha az igény üres, kérdezd meg egy mondatban: „Mit csinálna az új kolléga? Például: átnézi a leveleim tervezetét, mielőtt elküldöm, és jelzi, ha valami félreérthető."

**A munkaterület útja** a session eleji kontextusban szerepel `Munkaterület: <út>` sorként. Ha nincs ilyen sor, vagy a mappa nem létezik, ne indítsd a felvételt: mondd el, hogy előbb a `/starter-kit:setup` kell, és ajánld fel a futtatását.

## Menet

1. **Rita.** Hívd meg a `starter-kit:talent-researcher` agentet. Add át neki: az igényt a felhasználó szavaival, a munkaterület abszolút útját, és ha van, a tulajdonos profiljának lényegét (`<út>/About Me/rolam.md`). Rita visszakérdezhet (legfeljebb 3 kérdés); a kérdéseit add tovább a felhasználónak, a válaszokat vissza Ritának.

2. **Jóváhagyás.** Rita brief-jét mutasd meg a felhasználónak, és kérdezd meg, jó-e így. Ha módosítást kér, vidd vissza Ritához. Jóváhagyás nélkül ne menj tovább.

3. **Anna.** A jóváhagyott brief-et add át a `starter-kit:agent-architect` agentnek, a munkaterület abszolút útjával együtt. Anna megírja az agent `.md`-t a `<út>/Csapat/<Department>/` alá, symlinkeli `~/.claude/agents/` alá, és frissíti a `Csapat/README.md`-t és a `team-index.md`-t.

4. **Zárás.** Mondd el a felhasználónak, hová került az új kolléga, mit csinál egy mondatban, és hogyan hívhatja meg (példa-mondattal). Jelezd, hogy a Claude Code a következő session-indítástól látja (`/exit`, majd `claude`).

Így bővül a rendszer: minden új munkakörre ezt az utat járjuk be. A fő-agent magától is felajánlja, ha észreveszi, hogy egy visszatérő feladathoz nincs megfelelő kolléga.
