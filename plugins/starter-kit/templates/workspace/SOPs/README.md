# SOPs — rögzített szabályok

Az SOP (Standard Operating Procedure) egy desztillált, számozott szabály: valami, amit egyszer eldöntöttünk, és mostantól magától így legyen. A fő-agent és a kollégák ezekre hivatkoznak, hogy ne kelljen újra és újra elmagyarázni ugyanazt.

## Formátum

Minden SOP:

```
# SOP-NN: Cím
**Hatály:** kire vonatkozik
---
## Szabály        — mit kell csinálni (konkrét, tesztelhető)
## Miért          — 1-2 mondat, hogy később ne kelljen újra levezetni
## Hogyan alkalmazd
## Tilalmak       — (opcionális) explicit „ne tedd"
```

## Induló SOP-ok

| # | Cím | Miről szól |
|---|---|---|
| SOP-00 | Öntanulás | Hogyan lesz egy felismerésből rögzített szabály — a rendszer így tanul |
| SOP-01 | Agent-fájl konvenciók | Frontmatter, szekciórend, elhelyezés, symlink, least-privilege |
| SOP-02 | Delegálj, ne magad dolgozz | A fő-agent koordinál, nem állít elő maga deliverable-t |
| SOP-03 | Session-ritmus | Kezdés (kontextus-betöltés) és zárás (napló + öntanulás) |
| SOP-04 | Írás- és deliverable-szabályok | Univerzális minőségi alapelvek a kimenetekhez |

## Új SOP

Új szabály a **SOP-00 (öntanulás)** szerint születik: a fő-agent felajánlja a rögzítést, a tulajdonos jóváhagyja, és a következő szabad sorszámon (`SOP-05`, `SOP-06`, …) létrejön. Ne hozz létre SOP-ot jóváhagyás nélkül, és ne duplikálj meglévőt — inkább bővítsd.
