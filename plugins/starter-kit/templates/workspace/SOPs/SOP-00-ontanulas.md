# SOP-00: Öntanulás — hogyan lesz egy szabályból rögzített szabály

**Hatály:** a fő-agent (Máté) és minden kolléga

---

## Szabály

A rendszer **munka közben tanul**. Amikor egy ismétlődő szabály, preferencia vagy döntés felbukkan, a fő-agent **felajánlja a rögzítést** — nem hozza létre csendben, és nem is felejti el.

### Mikor ajánld fel a rögzítést

- A tulajdonos **kijavít** valamit úgy, hogy az legközelebb is érvényes lesz („ne így, hanem úgy", „mostantól mindig…").
- Ugyanaz a döntés vagy kérdés **másodszor** jön elő.
- Kiderül egy **nem magától értetődő tény** a munkáról, egy ügyfélről, egy eszközről, ami később is számít.
- A tulajdonos egy megközelítést **kifejezetten jóváhagy** („igen, pontosan így csináld").

### Hogyan ajánld fel

Egy mondatban, a munka megszakítása nélkül:

> „Ezt rögzítsem szabályként, hogy legközelebb magától így legyen?"

Ha igen, döntsd el, **hova** kerüljön:

| Ez… | …ide kerül |
|---|---|
| Általános munkaszabály, ami több feladatra érvényes | **Új SOP** a `SOPs/` mappában (`SOP-NN-rövid-név.md`) |
| Ki a tulajdonos, mivel foglalkozik, állandó preferencia | **`About Me/rolam.md`** frissítése |
| Egy konkrét projekt/ügyfél állapota, teendője | A projekt jegyzete a `Notes/`-ban vagy a `Tasks/`-ban |
| Egy saját agent viselkedésének finomítása | Az adott agent `.md`-je a `Csapat/<Department>/` alatt (beépített kollégánál, ami a pluginban él: új SOP vagy a `CLAUDE.md`, mert a plugin fájljai frissítéskor felülíródnak) |

### Új SOP létrehozása

1. Válaszd a következő szabad sorszámot (`SOP-05`, `SOP-06`, …).
2. Kövesd a formátumot: `## Szabály`, `## Miért`, `## Hogyan alkalmazd`, opcionálisan `## Tilalmak`.
3. A `Szabály` legyen konkrét és tesztelhető, a `Miért` egy-két mondat (hogy később ne kelljen újra levezetni).
4. Ha egy agentre is vonatkozik, tegyél egy pointert az agent `.md`-jébe (ne másold be a teljes szöveget).

## Miért

Az AI-nak nincs memóriája a beszélgetések között. A tudás akkor marad meg, ha **fájlba** kerül. Az öntanulás nélkül ugyanazt a szabályt újra és újra el kell magyarázni — a felajánlott rögzítés ezt egyszer és mindenkorra megoldja, és a tulajdonos kontrollja alatt tartja (ő dönti el, mi válik szabállyá).

## Hogyan alkalmazd

- **Ajánlj, ne diktálj.** A tulajdonos dönti el, mi lesz szabály. Ne hozz létre SOP-ot jóváhagyás nélkül.
- **Ne halmozz.** Egy felismerés → egy felajánlás. Ne gyűjtsd a végére.
- **Kerüld a duplikációt.** Rögzítés előtt nézd meg, van-e már erről szóló SOP; ha igen, azt bővítsd.
- **A rossz szabályt töröld.** Ha egy korábbi szabály tévesnek bizonyul, javasold a SOP frissítését vagy törlését.

## Tilalmak

- Csendben létrehozott vagy módosított szabály (mindig legyen felajánlás).
- Egyszeri, beszélgetés-specifikus dolog SOP-ba emelése — az nem szabály, csak pillanatnyi kontextus.
- Ugyanannak a szabálynak több helyre másolása (egy kanonikus hely + pointerek).
