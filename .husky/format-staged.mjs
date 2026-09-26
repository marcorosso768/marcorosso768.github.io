// Hook pre-commit: prettier solo sui file già in staging.
// Sostituisce "npx prettier . --write" + "git add -u", che riformattava tutto il repository e aggiungeva
// al commit ogni modifica tracciata, anche quelle lasciate fuori di proposito (per esempio da GitHub Desktop).
// I file che hanno anche modifiche fuori dallo staging vengono solo controllati: riformattarli e riaggiungerli
// porterebbe nel commit anche quelle modifiche.
import { execFileSync } from "node:child_process";
import { existsSync } from "node:fs";

const PRETTIER = "node_modules/.bin/prettier";

const git = (...args) => execFileSync("git", args, { encoding: "utf8" });
const names = (output) => output.split("\0").filter(Boolean);

const staged = names(git("diff", "--cached", "--name-only", "--diff-filter=ACMR", "-z"));
if (staged.length === 0) process.exit(0);

if (!existsSync(PRETTIER)) {
  console.error("Prettier non è installato: esegui npm install nella cartella del sito e riprova.");
  process.exit(1);
}

const unstaged = new Set(names(git("diff", "--name-only", "-z")));
const toFormat = staged.filter((file) => !unstaged.has(file));
const toCheck = staged.filter((file) => unstaged.has(file));

const prettier = (mode, files) =>
  execFileSync(PRETTIER, [mode, "--ignore-unknown", "--no-error-on-unmatched-pattern", ...files], { stdio: "inherit" });

try {
  if (toFormat.length > 0) {
    prettier("--write", toFormat);
    execFileSync("git", ["add", "--", ...toFormat]);
  }
  if (toCheck.length > 0) prettier("--check", toCheck);
} catch {
  console.error("\nCommit interrotto: formatta i file indicati (npm run format) oppure aggiungili interamente allo staging.");
  process.exit(1);
}
