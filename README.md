# Claude Code starter kit (magyar)

Egy Claude Code plugin, ami pár perc alatt felépít egy magyar nyelvű munkakörnyezetet: egy **fő-agentet**, aki koordinál és delegál, egy kis **csapatot agentekből**, amit a saját munkádra bővíthetsz, egy **szabályrendszert** (SOP), ami munka közben tanul, és egy **onboardingot**, amivel a rendszer megtudja, ki vagy.

Nem egy konkrét szakmára készült: a magja bármilyen munkakörre használható, a saját munkádra a beépített kollégafelvétellel szabod.

## A három vezérelv

1. **Delegálj, ne magad dolgozz.** A fő-agent koordinál; az érdemi munkát a szakosodott kollégákra bízza.
2. **Öntanulás.** Ha munka közben ismétlődő szabály vagy preferencia bukkan fel, a rendszer felajánlja a rögzítését, így legközelebb már magától tudja.
3. **Bővülő csapat.** Ha egy munkakörre nincs kolléga, a rendszer felajánlja egy új agent felvételét, és pár lépésben elkészíti.

## Mi van benne

| Rész | Mit ad |
|---|---|
| **Beépített kollégák** | Rita (recruiter) és Anna (agent-architect): ők veszik fel az új kollégákat. Bea (napló) és Ádám (állapotriport). |
| **Parancsok** | `/starter-kit:setup`, `/starter-kit:onboard`, `/starter-kit:new-agent`, `/starter-kit:start-session`, `/starter-kit:end-session` |
| **Sablon a munkaterülethez** | Egy mappa a gépeden: a fő-agent szabályai (`CLAUDE.md`), rólad szóló profil, SOP-ok, feladatok, jegyzetek, saját kollégák. |
| **Session eleji emlékeztető** | Minden indításkor jelzi a modellnek, hol a munkaterületed, és mi a következő lépés (beállítás vagy onboarding). |

A plugin a „motor”, a munkaterület a tiéd: a plugin frissítése soha nem nyúl a munkaterületed fájljaihoz.

## Előfeltétel

Fizetős Claude-előfizetés (Pro, Max, Team vagy Enterprise) vagy Anthropic API-kulcs. Ingyenes fiókkal a Claude Code nem használható.

## 1. Claude Code telepítése (macOS)

Válassz **egy** módot:

```bash
# A) Homebrew (ha van brew a gépen)
brew install --cask claude-code

# B) Natív telepítő (nem kell hozzá se brew, se Node)
curl -fsSL https://claude.ai/install.sh | bash

# C) npm (ha van Node.js 22 vagy újabb)
npm install -g @anthropic-ai/claude-code
```

A `curl … | bash` egy szkriptet tölt le és futtat. Ha óvatos vagy, előbb nyisd meg böngészőben a `https://claude.ai/install.sh` címet, és nézd át.

Ellenőrzés új terminálablakban:

```bash
claude --version
claude doctor
```

Ha a `claude` parancsot nem találja, zárd be és nyisd újra a terminált.

**Bejelentkezés:** indítsd el a `claude`-ot; megnyílik a böngésző, lépj be a Claude-fiókoddal. Ha a böngésző nem nyílik meg, a terminál kiír egy linket. Kilépés: `/exit`.

Windowson és Linuxon a Claude Code hivatalos telepítési oldala szerint telepíts; a plugin használata onnantól ugyanaz.

## 2. A plugin telepítése

Indítsd el a `claude`-ot bármelyik mappában, és add ki:

```
/plugin marketplace add OWNER/claude-starter-kit
/plugin install starter-kit@claude-starter-kit
```

Utána lépj ki (`/exit`) és indítsd újra a `claude`-ot, hogy a plugin betöltődjön.

## 3. Beállítás és onboarding

```
/starter-kit:setup
```

Megkérdezi, hova kerüljön a munkaterület (alapértelmezés: `~/Documents/Munkaterulet`) és mi legyen a fő-agent neve (alapértelmezés: Máté). A sablont felülírás nélkül másolja be, így később is nyugodtan újrafuttatható. Felajánlja a `git init`-et is; vadonatúj Macen ilyenkor feljöhet az Xcode Command Line Tools telepítőablaka, ezt meg kell várni.

A végén rögtön jöhet az onboarding:

```
/starter-kit:onboard
```

Pár kérdéskörben megismer (ki vagy, mivel foglalkozol, milyen eszközökkel, hogyan szeretsz dolgozni), kitölti az `About Me/rolam.md`-t, és javasol egy-három első saját kollégát a munkádhoz.

## Napi használat

**A `claude`-ot a munkaterület mappájából indítsd**, mert a fő-agent szabályai (`CLAUDE.md`) csak ott töltődnek be:

```bash
cd ~/Documents/Munkaterulet
claude
```

- Munka elején: `/starter-kit:start-session` — hol tartunk, mi a nyitott, mi a következő lépés.
- Munka végén: `/starter-kit:end-session` — felajánlja a szabályrögzítést (öntanulás), és Bea naplóz.
- Új kolléga: `/starter-kit:new-agent <igény egy mondatban>`, vagy egyszerűen: „Rita, kéne valami, ami…”
- Állapot: „Ádám, hol tartunk az X-szel?”

A saját kollégák a munkaterület `Csapat/<Department>/` mappájában élnek, és symlink teszi őket láthatóvá a `~/.claude/agents/` alatt. Egy új kolléga a következő `claude` indítástól érhető el.

## Frissítés

```
/plugin marketplace update claude-starter-kit
```

Utána indítsd újra a `claude`-ot. A telepített verziót a `/plugin` menüben látod; a változások a [CHANGELOG.md](CHANGELOG.md)-ben vannak. A frissítés csak a plugint cseréli: a munkaterületed (profil, SOP-ok, jegyzetek, saját kollégák) érintetlen marad. Az új sablonfájlokat a `/starter-kit:setup` újrafuttatása pótolja, a meglévőket nem írja felül.

## Hibaelhárítás

- **`claude doctor`** — a telepítés átvizsgálása.
- **Nem látszanak a `/starter-kit:…` parancsok.** Indítsd újra a `claude`-ot, és nézd meg a `/plugin` menüben, hogy a `starter-kit` telepítve és engedélyezve van.
- **A fő-agent nem követi a szabályokat.** Valószínűleg nem a munkaterület mappájából indítottad a `claude`-ot. Lépj ki, `cd` a munkaterületre, és indítsd újra.
- **Egy saját kolléga nem jelenik meg.** Nézd meg a symlinket: `ls -la ~/.claude/agents/`. A kolléga fájljára kell mutatnia a munkaterület `Csapat/…` mappájában. Új kolléga csak újraindítás után látszik.
- **Áthelyezted a munkaterületet.** Futtasd újra a `/starter-kit:setup`-ot az új hellyel (a meglévő fájlokat nem írja felül), és hozd létre újra a saját kollégák symlinkjeit (a `Csapat/README.md` leírja, hogyan).
- **Jóváhagyást kér minden lépésnél.** Ez normális, nyugodtan engedélyezd. A munkaterület `.claude/settings.json` fájlja néhány rutinparancsot eleve engedélyez.

## Eltávolítás

```
/plugin uninstall starter-kit@claude-starter-kit
/plugin marketplace remove claude-starter-kit
```

A munkaterület mappája megmarad (a te fájljaid), ahogy a saját kollégák symlinkjei is a `~/.claude/agents/` alatt; ezeket kézzel törölheted, ha már nem kellenek.

## Testreszabás

- **Nevek:** a fő-agent nevét a beállításkor adod meg; a saját kollégák neve szabadon választható. A beépítettek (Rita, Anna, Bea, Ádám) a pluginban élnek, ezeket nem érdemes átírni, mert frissítéskor felülíródnak.
- **Feladatkövetés:** a `Tasks/` lehet markdown, vagy külső eszköz (Jira, Todoist, Notion); a munkamenetek ritmusa ettől független.

## Licenc

MIT, lásd [LICENSE](LICENSE).
