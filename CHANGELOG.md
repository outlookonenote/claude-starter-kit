# Változások

A verziószám a `plugins/<plugin>/.claude-plugin/plugin.json` fájlban van (`starter-kit`: magyar, `starter-kit-en`: angol); minden kiadásnál emelni kell, különben a telepített példányok nem frissülnek.

## 0.2.0 (starter-kit és starter-kit-en)

Windows-támogatás és új helye a saját kollégáknak.

- **Telepítés egy paranccsal Windowson:** `[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; irm https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/main/install-windows.ps1 | iex` (Windows PowerShell 5.1 és PowerShell 7; rendszergazdai jog általában nem kell, csak ha a Git felhasználói telepítése nem sikerül, és a telepítő a gép egészére próbálja feltenni). Ellenőrzi a Windowst, szükség esetén telepíti a Git for Windowst (winget) és a Claude Code-ot (hivatalos telepítő), felveszi a marketplace-t, telepíti a plugint, létrehozza a munkaterületet (`~\Munkaterulet`), és felajánlja a `git init`-et. Újrafuttatható. Angol kiadás: `-English` kapcsoló (lásd README.en.md).
- **Kiadási rögzítés:** az `install-windows.ps1` a telepítő magját (`windows/installer.ps1`) nem a változó `main` ágról, hanem a `$ReleaseRef` konstansban megadott git tagről tölti le (most `v0.2.0`). **Minden kiadásnál emelni kell ezt a konstanst, és létre kell hozni a taget**, a plugin verziókkal együtt. A marketplace-t a telepítő szándékosan tag nélkül veszi fel: egy taghez rögzített marketplace-t a `/plugin marketplace update` soha nem lépteti tovább (és az újabb taggel való újrafelvétel sem írja át), így a felhasználók nem kapnák meg a későbbi kiadásokat. Tesztelésre a `STARTER_KIT_REF` (ág) és a `STARTER_KIT_SOURCE` (például helyi klón) környezeti változó szolgál; beállítva sárga figyelmeztetést írnak ki.
- **Saját kollégák új helye:** `<munkaterület>/.claude/agents/<Department>/<név>.md` (a Claude Code a projekt agentjeit az almappákból is betölti, ha a `claude`-ot a munkaterületből indítod). Megszűnt a symlink a `~/.claude/agents/` alá: Git Bashben az `ln -s` alapból másolatot készít, így a szerkesztések elavultak. A `Csapat/` (angolul `Team/`) mappa a névjegyzék marad (`README.md`, `team-index.md`). Anna, a `/starter-kit:new-agent`, a sablonok és a SOP-01 már az új helyet használják; a munkaterület `.claude/settings.json`-jából kikerült az `ln -sf` engedély.
- **Windows-útvonalak:** a `setup-workspace.sh` elfogadja a `C:\...`, `C:/...` és `~\...` alakot (Git Bashben `cygpath`-szal alakít), a configba `C:/...` alakban írja a munkaterület útját. A GNU és BSD `sed` közti különbség miatti hibaüzenet megszűnt.
- **Session eleji emlékeztető Windowson:** a hook a `C:\...` alakú utakat is kezeli, és a munkaterület almappájából indított sessiont is munkaterületinek tekinti.
- **`.gitattributes`:** a `.sh` fájlok mindig LF sorvéggel kerülnek ki, különben Windowson a Git CRLF-re alakítaná és a bash nem futtatná őket.

### Átállás 0.1.x-ről (meglévő saját kollégák)

A 0.1.x a saját kollégákat a `Csapat/<Department>/` alá írta, és a `~/.claude/agents/` alól symlink mutatott rájuk. Ezek frissítés után is működnek, de az új kollégák már az új helyre kerülnek. Az átállás:

1. Frissítés után futtasd a `/starter-kit:setup`-ot (angolul `/starter-kit-en:setup`) ugyanarra a munkaterületre.
2. Ha régi elhelyezésű kollégát talál, a `migrate-agents.sh` először csak megmutatja a tervet; jóváhagyás után áthelyezi a fájlokat a `.claude/agents/<Department>/` alá, és a `~/.claude/agents/` alól csak a rájuk mutató symlinket vagy a velük azonos tartalmú másolatot veszi ki. Ami eltér, azt nem bántja, csak jelzi.
3. A meglévő munkaterületi fájlokat (`CLAUDE.md`, `Csapat/README.md`, `Csapat/team-index.md`, `SOPs/SOP-01-…`) a setup nem írja felül, ezekben még a régi leírás szerepel. Kérd meg a fő-agentet, hogy igazítsa őket az új elhelyezéshez (a plugin sablonjai mutatják a mintát).

## starter-kit-en 0.1.0

Angol nyelvű kiadás külön pluginként (`starter-kit-en`), ugyanabban a marketplace-ben. Tartalma megegyezik a magyar 0.1.0-val; a parancsok `/starter-kit-en:` előtaggal, a munkaterület angol mappa- és fájlnevekkel (`Team/`, `About Me/about-me.md`, angol SOP-fájlnevek), a fő-agent alapértelmezett neve Max. Leírás: [README.en.md](README.en.md).

## 0.1.0

Első kiadás pluginként; a korábbi, zip-ben terjesztett starter kitet váltja.

- Beépített kollégák: Rita (`starter-kit:talent-researcher`), Anna (`starter-kit:agent-architect`), Bea (`starter-kit:scribe`), Ádám (`starter-kit:status`).
- Parancsok: `/starter-kit:setup` (a korábbi bootstrap prompt helyett), `/starter-kit:onboard` (onboarding-interjú, a végén első kolléga-javaslatokkal), `/starter-kit:new-agent`, `/starter-kit:start-session`, `/starter-kit:end-session`.
- Session eleji emlékeztető: jelzi a munkaterület útját, és felajánlja a beállítást vagy az onboardingot, ha még hiányzik.
- Munkaterület-sablon: a beállítás felülírás nélkül másolja, a meglévő fájlokhoz nem nyúl.
- A munkaterület `.claude/settings.json`-jából kikerült a `defaultMode: auto` (nem minden előfizetésen érhető el).
