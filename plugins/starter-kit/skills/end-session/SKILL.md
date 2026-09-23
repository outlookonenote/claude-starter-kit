---
name: end-session
description: Munkamenet lezárása. Felajánlja a nap során felbukkant szabályok, preferenciák rögzítését (öntanulás, SOP-00), majd érdemi session után Bea (starter-kit:scribe) dátumozott bejegyzést fűz a munkaterület session-naplójához.
argument-hint: "[opcionális megjegyzés a naplóhoz]"
---

# Session-zárás

Zárjuk le a munkamenetet (→ `SOPs/SOP-03-session-ritmus.md`).

**A munkaterület útja** a session eleji kontextusban szerepel `Munkaterület: <út>` sorként. Ha nincs ilyen sor, vagy a mappa nem létezik, mondd el, hogy előbb a `/starter-kit:setup` kell, és ajánld fel a futtatását.

A felhasználó megjegyzése a záráshoz (lehet üres): `$ARGUMENTS`

1. **Öntanulás (SOP-00).** Nézd át, történt-e ma olyan ismétlődő szabály, preferencia vagy döntés, amit érdemes rögzíteni (SOP, `About Me`, vagy jegyzet). Ha igen, ajánld fel egy mondatban; a tulajdonos dönt. Jóváhagyás nélkül ne hozz létre szabályt.

2. **Naplózás.** Ha érdemi haladás, döntés vagy új információ született, hívd meg **Beát** (`starter-kit:scribe`): fűzzön egy dátumozott bejegyzést az `<út>/Notes/session-log.md`-hez. Add át neki a munkaterület abszolút útját, és hogy mi történt, milyen döntés született, mi a nyitott szál.

3. Ha a session üres volt (nem történt érdemi dolog), a naplózás elmarad; ezt csak jelezd.
