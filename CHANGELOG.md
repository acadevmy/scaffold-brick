# 0.2.0

- pnpm 12 (`packageManager: pnpm@12.16.1`) e Node.js `>=22.12.0`, richiesti
  dalle applicazioni Next.js 16.4.
- Impostazioni di workspace spostate in `pnpm-workspace.yaml`: pnpm 11+ non
  legge più il campo `"pnpm"` del `package.json` né le impostazioni del
  `.npmrc` di progetto (`requiredScripts`, `supportedArchitectures`,
  `autoInstallPeers`).
- Node.js forzato a 24.22.2 con `devEngines.runtime` (`onFail: download`), al
  posto di `executionEnv.nodeVersion`: pnpm scarica quella versione e la usa
  per ogni script, qualunque sia il Node installato sulla macchina.
- `allowBuilds` per le dipendenze con script di installazione delle
  applicazioni Next.js, Angular e NestJS: senza, pnpm 12 fallisce con
  `ERR_PNPM_IGNORED_BUILDS` e la devmy CLI installa senza terminale.
- nx 24.0.3 (nx 19 non legge il lockfile di pnpm 12); `affected.defaultBase`
  diventa `defaultBase`.

# 0.1.0+1

- Prima release.
