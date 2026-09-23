---
name: start-session
description: Munkamenet-kezdő eligazítás. Beolvassa a tulajdonos profilját, a session-napló legutóbbi bejegyzését és a nyitott feladatokat, majd tömören elmondja, hol tartunk, mi a nyitott és mi a javasolt következő lépés. Opcionálisan egy témára szűkíthető.
argument-hint: "[opcionális téma]"
---

# Session-kezdés

Adj egy tömör eligazítást (→ `SOPs/SOP-03-session-ritmus.md`).

**A munkaterület útja** a session eleji kontextusban szerepel `Munkaterület: <út>` sorként; minden alábbi fájl ehhez képest értendő. Ha nincs ilyen sor, vagy a mappa nem létezik, mondd el, hogy előbb a `/starter-kit:setup` kell, és ajánld fel a futtatását.

1. Olvasd el az `<út>/About Me/rolam.md`-t (ki a tulajdonos, mik a preferenciái), és ezt tartsd fejben végig. Ha még kitöltetlen, a végén ajánld fel a `/starter-kit:onboard`-ot.
2. Nézd meg az `<út>/Notes/session-log.md` legutóbbi bejegyzését: hol maradt abba a munka.
3. Nézd át a nyitott feladatokat az `<út>/Tasks/` alatt (vagy ahol a tulajdonos a `Tasks/README.md` szerint tartja őket).
4. Add vissza röviden: **hol tartunk**, **mi a nyitott**, **mi a javasolt következő lépés**.

Szűkítés témára (ha üres, nincs szűkítés): `$ARGUMENTS`

Ne olvass fel mindent szó szerint: a lényeg kell, néhány mondatban.
