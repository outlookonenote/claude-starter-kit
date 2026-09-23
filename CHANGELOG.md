# Változások

A verziószám a `plugins/starter-kit/.claude-plugin/plugin.json` fájlban van; minden kiadásnál emelni kell, különben a telepített példányok nem frissülnek.

## 0.1.0

Első kiadás pluginként; a korábbi, zip-ben terjesztett starter kitet váltja.

- Beépített kollégák: Rita (`starter-kit:talent-researcher`), Anna (`starter-kit:agent-architect`), Bea (`starter-kit:scribe`), Ádám (`starter-kit:status`).
- Parancsok: `/starter-kit:setup` (a korábbi bootstrap prompt helyett), `/starter-kit:onboard` (onboarding-interjú, a végén első kolléga-javaslatokkal), `/starter-kit:new-agent`, `/starter-kit:start-session`, `/starter-kit:end-session`.
- Session eleji emlékeztető: jelzi a munkaterület útját, és felajánlja a beállítást vagy az onboardingot, ha még hiányzik.
- Munkaterület-sablon: a beállítás felülírás nélkül másolja, a meglévő fájlokhoz nem nyúl.
- A munkaterület `.claude/settings.json`-jából kikerült a `defaultMode: auto` (nem minden előfizetésen érhető el).
