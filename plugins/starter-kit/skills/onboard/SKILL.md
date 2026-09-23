---
name: onboard
description: Onboarding-interjú a tulajdonossal. Körönként kérdez (ki vagy, mit csinálsz, kikkel, eszközök, preferenciák, fókusz), a válaszokból megírja a munkaterület About Me/rolam.md fájlját, majd 1-3 első saját kollégát javasol. Akkor használd, ha a profil még kitöltetlen, vagy a felhasználó újra el akarja mondani, ki ő.
argument-hint: "[opcionális: amit már most elmondanál magadról]"
---

# Onboarding-interjú

Készítsd el a tulajdonosról szóló profilt: interjúztasd meg, majd írd meg a munkaterület `About Me/rolam.md` fájlját a válaszaiból (a fájl meglévő szerkezetét követve).

**A munkaterület útja** a session eleji kontextusban szerepel `Munkaterület: <út>` sorként. Ha nincs ilyen sor, vagy a mappa nem létezik, ne interjúztass: mondd el, hogy előbb a `/starter-kit:setup` kell, és ajánld fel a futtatását.

Ha a felhasználó már az indításkor elmondott valamit magáról, használd fel, és azt ne kérdezd meg újra: `$ARGUMENTS`

## 1. Kérdezz körönként, ne egyszerre mindent

Egy körben 2-4 összetartozó kérdés, várd meg a választ, aztán jöhet a következő kör. Az alábbi témákat járd körbe:

- **Ki vagyok:** név, munkakör/szerep, néhány mondat a háttérről.
- **Mit csinálok:** fő tevékenységek, projektek; ha több „kalapja" van (pl. főállás és saját projekt), mindet, és hogy mikor melyik.
- **Kikkel / kiknek:** ügyfelek, célközönség, csapat, partnerek.
- **Eszközeim:** gép/OS, e-mail, fő platformok, amikkel dolgozik.
- **Hogyan dolgozz velem:** hangnem (tömör vagy részletes, tegeződés vagy magázódás), kérdezz vagy feltételezz, mennyire mehetsz mélyre, tiltott stílus/szó, mikor kér őszinte ellenvéleményt.
- **Jelenlegi fókusz:** amin épp dolgozik.

## 2. Kihagyható témák

Ha valamit kihagy, vagy „nem tudom" a válasz, lépj tovább, ne erőltesd. Amit nem mond meg, az üresen marad a fájlban.

## 3. A rolam.md megírása

- Írd meg az `<út>/About Me/rolam.md`-t a válaszok alapján, tömören, **a tulajdonos saját szavaival** (ne told fel AI-töltelékkel).
- A dőlt betűs kitöltési útmutató-sorokat, amelyekre válasz érkezett, cseréld a válaszra; a megválaszolatlan szekció maradhat üresen.
- A tetején a `_Utolsó frissítés: —_` sorban a `—` helyére írd a mai dátumot (`date +%Y-%m-%d`), például `_Utolsó frissítés: 2026-01-15_`. Ez jelzi a rendszernek, hogy a profil kitöltött.
- Mutasd meg, mit írtál, és kérdezd meg, van-e amin igazítsak. Ha igen, javítsd.

## 4. Első saját kollégák (zárólépés)

A válaszok (szerep, munka, eszközök) alapján javasolj **1-3 első saját kollégát**, mindegyiket egy mondatban: mit csinálna, és miért segítene épp neki. Legyenek konkrétak, a tulajdonos valódi munkájához kötve (pl. „levéltervezet-ellenőrző, mert sok ügyféllevelet írsz"). Ne javasolj olyat, amit a beépített kollégák már lefednek (Rita és Anna: felvétel, Bea: napló, Ádám: állapotriport).

- Ha a tulajdonos választ egyet: indítsd a felvételt **Ritával** (`starter-kit:talent-researcher`). Add át neki az igényt egy mondatban, a munkaterület abszolút útját és a profil lényegét. Rita brief-jét mutasd meg jóváhagyásra; ha a tulajdonos rábólint, add át **Annának** (`starter-kit:agent-architect`) a brief-fel és a munkaterület útjával. A végén mondd el, hogyan hívható az új kolléga, és hogy a következő session-indítástól látszik.
- Ha nem kér most: csak jelezd, hogy bármikor felvehet új kollégát a `/starter-kit:new-agent <igény egy mondatban>` paranccsal, vagy egyszerűen így: „Rita, kéne valami, ami…".

## 5. Zárás

Egy mondatban említsd meg: a profil később magától is bővül az öntanulással (SOP-00), ahogy dolgozunk, felajánlom a fontos preferenciák rögzítését. Bármikor mondhatja menet közben: „ezt írd hozzá a rolam.md-hez".
