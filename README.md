# Claude Code starter kit (magyar)

[English version](README.en.md)

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

## Windowson: telepítés egy paranccsal

Nyisd meg a **Windows PowerShell** alkalmazást (Start menü, „PowerShell”; rendszergazdaként nem kell elindítani), másold be ezt a sort, és nyomj Entert:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; irm https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/main/install-windows.ps1 | iex
```

A sor eleje (`SecurityProtocol … 3072`) a régebbi Windows PowerShell 5.1 miatt kell: bekapcsolja a TLS 1.2-t, amit a GitHub megkövetel. PowerShell 7-ben sem árt.

A telepítő sorban:

1. ellenőrzi a Windowst (Windows 10 1809-es vagy újabb kiadás, illetve Windows 11, 64 bites);
2. ha hiányzik, telepíti a **Git for Windowst** a wingettel (a plugin szkriptjei a vele érkező Git Bashben futnak, ezért ez Windowson kötelező). Először a saját felhasználódnak telepíti, ehhez általában nem kell rendszergazdai jog. Ha ez nem sikerül, a gép egészére próbálja telepíteni, és ilyenkor a Windows jóváhagyást kér (UAC); céges, központilag kezelt gépen ehhez kérd az informatikusok segítségét;
3. ha hiányzik, telepíti a **Claude Code**-ot a hivatalos telepítővel (ehhez nem kell rendszergazdai jog);
4. felveszi a marketplace-t, és telepíti a `starter-kit` plugint;
5. létrehozza a munkaterületet a `~\Munkaterulet` mappában (csak a fő-agent nevét kérdezi meg, alapértelmezés: Máté), és felajánlja a `git init`-et.

Nyugodtan újrafuttatható: ami már kész, azt kihagyja, meglévő fájlt nem ír felül, a plugint pedig frissíti. A végén kiírja a teendőket:

```powershell
cd ~\Munkaterulet
claude
```

Az első indításkor a böngészőben jelentkezz be a Claude-fiókoddal, a „megbízol ebben a mappában?” kérdésre válaszolj igennel (Yes), majd írd be: `/starter-kit:onboard`. Innen a [Napi használat](#napi-használat) rész ugyanúgy érvényes, mint macOS-en.

A parancs egy szkriptet tölt le és futtat. Ha óvatos vagy, előbb nézd át a repóban: [install-windows.ps1](install-windows.ps1) (rövid indító) és [windows/installer.ps1](windows/installer.ps1) (maga a telepítő).

**Kézi telepítés Windowson:** telepítsd a Git for Windowst (https://git-scm.com/downloads/win), majd PowerShellben a Claude Code-ot: `irm https://claude.ai/install.ps1 | iex` (vagy `winget install Anthropic.ClaudeCode`, ez viszont nem frissül magától). Utána a [2. ponttól](#2-a-plugin-telepítése) minden ugyanaz; munkaterületnek a `~\Munkaterulet` ajánlott, mert a Dokumentumok mappát a Windows gyakran a OneDrive-ba szinkronizálja.

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

Windowson lásd fent. Linuxon a Claude Code hivatalos telepítési oldala szerint telepíts; a plugin használata onnantól ugyanaz.

## 2. A plugin telepítése

Indítsd el a `claude`-ot bármelyik mappában, és add ki:

```
/plugin marketplace add outlookonenote/claude-starter-kit
/plugin install starter-kit@claude-starter-kit
```

Utána lépj ki (`/exit`) és indítsd újra a `claude`-ot, hogy a plugin betöltődjön.

Ugyanebben a marketplace-ben van az angol kiadás is (`starter-kit-en`). Csak az egyiket telepítsd: mindkettő munkaterületet állít be és session eleji emlékeztetőt ad.

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

Az első indításkor a Claude Code megkérdezi, megbízol-e ebben a mappában. Fogadd el: amíg ez nem történik meg, a munkaterület `.claude/settings.json` fájljában előre engedélyezett rutinparancsok sem érvényesek, és minden lépésnél jóváhagyást kér.

- Munka elején: `/starter-kit:start-session` — hol tartunk, mi a nyitott, mi a következő lépés.
- Munka végén: `/starter-kit:end-session` — felajánlja a szabályrögzítést (öntanulás), és Bea naplóz.
- Új kolléga: `/starter-kit:new-agent <igény egy mondatban>`, vagy egyszerűen: „Rita, kéne valami, ami…”
- Állapot: „Ádám, hol tartunk az X-szel?”

A saját kollégák a munkaterület `.claude/agents/<Department>/` mappájában élnek (a névjegyzékük a `Csapat/` mappában van), és a Claude Code akkor tölti be őket, ha a munkaterületből indítod. Egy új kolléga a következő `claude` indítástól érhető el.

## Frissítés

```
/plugin marketplace update claude-starter-kit
```

Utána indítsd újra a `claude`-ot. A telepített verziót a `/plugin` menüben látod; a változások a [CHANGELOG.md](CHANGELOG.md)-ben vannak. A frissítés csak a plugint cseréli: a munkaterületed (profil, SOP-ok, jegyzetek, saját kollégák) érintetlen marad. Az új sablonfájlokat a `/starter-kit:setup` újrafuttatása pótolja, a meglévőket nem írja felül. Windowson a telepítő parancs újrafuttatása is frissít.

**0.1.x-ről 0.2.0-ra:** a saját kollégák helye megváltozott (symlink helyett a munkaterület `.claude/agents/` mappája). Frissítés után futtasd a `/starter-kit:setup`-ot: ha régi elhelyezésű kollégát talál, megmutatja, mit helyezne át, és csak a jóváhagyásod után teszi meg. Részletek: [CHANGELOG.md](CHANGELOG.md).

## Hibaelhárítás

- **`claude doctor`** — a telepítés átvizsgálása.
- **Nem látszanak a `/starter-kit:…` parancsok.** Indítsd újra a `claude`-ot, és nézd meg a `/plugin` menüben, hogy a `starter-kit` telepítve és engedélyezve van.
- **A fő-agent nem követi a szabályokat.** Valószínűleg nem a munkaterület mappájából indítottad a `claude`-ot. Lépj ki, `cd` a munkaterületre, és indítsd újra.
- **Egy saját kolléga nem jelenik meg.** A fájljának a munkaterület `.claude/agents/<Department>/` mappájában kell lennie, és a `claude`-ot a munkaterületből kell indítani. Új kolléga csak újraindítás után látszik. Ha 0.1.x-ről frissítettél, futtasd a `/starter-kit:setup`-ot, ami felajánlja a régi kollégák áthelyezését.
- **Áthelyezted a munkaterületet.** Futtasd újra a `/starter-kit:setup`-ot az új hellyel (a meglévő fájlokat nem írja felül). A saját kollégák a mappával együtt költöztek, velük nincs teendő.
- **Jóváhagyást kér minden lépésnél, még a rutinparancsoknál is.** A munkaterület `.claude/settings.json` fájlja néhány rutinparancsot előre engedélyez, de csak akkor, ha a mappát megbízhatónak fogadtad el. Indítsd a `claude`-ot a munkaterületből, és az első indításkor megjelenő kérdésre válaszolj igennel. Ettől függetlenül egy-egy jóváhagyás-kérés normális, nyugodtan engedélyezd.
- **Windows: a `claude` parancsot nem találja a PowerShell.** Nyiss új PowerShell ablakot (a telepítés után a PATH csak az új ablakokban frissül). A program helye: `%USERPROFILE%\.local\bin\claude.exe`.
- **Windows: a Claude Code Git Basht hiányol, vagy a session eleji emlékeztető nem jelenik meg.** Telepítsd a Git for Windowst (https://git-scm.com/downloads/win), vagy futtasd újra a telepítő parancsot. Ha a Git nem a szokásos helyre került, add meg a Git Bash útját a `%USERPROFILE%\.claude\settings.json` fájlban: `"env": { "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe" }`.
- **Windows: a telepítő egy lépésnél hibát írt.** Minden hibaüzenet megmondja a következő lépést. A telepítő biztonságosan újrafuttatható, a kész lépéseket kihagyja.
- **Más nevet adtál a fő-agentnek egy újrafuttatásnál, de a régi maradt.** A setup meglévő fájlt nem ír felül. Kérd meg a fő-agentet, hogy cserélje le a nevet a munkaterület `CLAUDE.md` fájljában és a `SOPs/` alatt.

## Eltávolítás

```
/plugin uninstall starter-kit@claude-starter-kit
/plugin marketplace remove claude-starter-kit
```

A munkaterület mappája megmarad (a te fájljaid, a saját kollégáiddal együtt). Ha 0.1.x-ből maradtak symlinkek a `~/.claude/agents/` alatt, azokat kézzel törölheted, ha már nem kellenek.

## Testreszabás

- **Nevek:** a fő-agent nevét a beállításkor adod meg; a saját kollégák neve szabadon választható. A beépítettek (Rita, Anna, Bea, Ádám) a pluginban élnek, ezeket nem érdemes átírni, mert frissítéskor felülíródnak.
- **Feladatkövetés:** a `Tasks/` lehet markdown, vagy külső eszköz (Jira, Todoist, Notion); a munkamenetek ritmusa ettől független.

## Licenc

MIT, lásd [LICENSE](LICENSE).
