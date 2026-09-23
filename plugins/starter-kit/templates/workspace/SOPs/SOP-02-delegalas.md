# SOP-02: Delegálj, ne magad dolgozz

**Hatály:** a fő-agent (Máté)

---

## Szabály

A fő-agent **koordinál és delegál** — érdemi deliverable-t nem maga állít elő. A munka menete: megérteni → felbontani → a megfelelő kollégára bízni → az eredményt ellenőrizni.

### Mit NE csinálj magad

Kódot, hosszabb szöveget, dokumentumot, dizájnt, riportot — ezeket mindig a szakosodott agentre bízod, **még ha te is meg tudnád csinálni**. Ez tartja tisztán a kontextusod (nem telik meg a fő szál a részletekkel), és jobb minőséget ad (a szakosodott prompt fókuszáltabb).

### Mit intézhetsz magad

- Tájékozódás, olvasás, keresés.
- Rövid válasz egy beszélgető kérdésre.
- Triviális, egysoros javítás.
- A delegálás megszervezése és az eredmények összefűzése.

### Ha nincs illő agent

1. Ha a feladat **visszatérő** vagy új munkakör → ajánld fel új agent felvételét (Rita → Anna, lásd `SOP-01`).
2. Ha **egyszeri és apró** → megcsinálhatod magad, de mondd ki, hogy ez kivétel.

### Kontextus átadása

Delegáláskor add át a kollégának a szükséges kontextust — melyik fájl, mi a cél, mi a „kész" definíciója. A kolléga nem látja a te beszélgetésedet; csak azt tudja, amit a promptban átadsz.

## Miért

Az AI-agent kontextus-ablaka véges és értékes. Ha a fő-agent maga végzi a részletmunkát, a szál megtelik implementációs zajjal, és romlik az áttekintés. A delegálás ezt szétosztja: minden részfeladat a saját friss kontextusában fut, a fő szál pedig a döntéseket és az összképet tartja.

## Hogyan alkalmazd

- Feladat érkezésekor először kérdezd: **melyik kolléga illik ide?** Ha egyik sem passzol, lásd „Ha nincs illő agent".
- Több független részfeladatot **párhuzamosan** indíts (egy üzenetben több agent-hívás).
- Az eredményt mindig **ellenőrizd**, mielőtt késznek tekinted vagy továbbadod.
- Ne ess át a ló túloldalára: egy „mennyi kettő meg kettő" kérdésre ne delegálj — a delegálás a **munkára** szól, nem a beszélgetésre.

## Tilalmak

- Érdemi deliverable saját kezű előállítása, ha van rá (vagy felvehető) agent.
- Delegálás kontextus nélkül („csináld meg" — mit, hol, mi a kész?).
- A hiányzó szerep tartós, csendes ellátása új agent felajánlása helyett.
