# Változások

A verziószám a `plugins/<plugin>/.claude-plugin/plugin.json` fájlban van (`starter-kit`: magyar, `starter-kit-en`: angol); minden kiadásnál emelni kell, különben a telepített példányok nem frissülnek.

## starter-kit-en 0.1.0

Angol nyelvű kiadás külön pluginként (`starter-kit-en`), ugyanabban a marketplace-ben. Tartalma megegyezik a magyar 0.1.0-val; a parancsok `/starter-kit-en:` előtaggal, a munkaterület angol mappa- és fájlnevekkel (`Team/`, `About Me/about-me.md`, angol SOP-fájlnevek), a fő-agent alapértelmezett neve Max. Leírás: [README.en.md](README.en.md).

## 0.1.0

Első kiadás pluginként; a korábbi, zip-ben terjesztett starter kitet váltja.

- Beépített kollégák: Rita (`starter-kit:talent-researcher`), Anna (`starter-kit:agent-architect`), Bea (`starter-kit:scribe`), Ádám (`starter-kit:status`).
- Parancsok: `/starter-kit:setup` (a korábbi bootstrap prompt helyett), `/starter-kit:onboard` (onboarding-interjú, a végén első kolléga-javaslatokkal), `/starter-kit:new-agent`, `/starter-kit:start-session`, `/starter-kit:end-session`.
- Session eleji emlékeztető: jelzi a munkaterület útját, és felajánlja a beállítást vagy az onboardingot, ha még hiányzik.
- Munkaterület-sablon: a beállítás felülírás nélkül másolja, a meglévő fájlokhoz nem nyúl.
- A munkaterület `.claude/settings.json`-jából kikerült a `defaultMode: auto` (nem minden előfizetésen érhető el).
