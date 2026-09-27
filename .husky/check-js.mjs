// Hook pre-commit: i JavaScript in assets/js devono essere leggibili da uglify-es 3.3.9, il minificatore
// che jekyll-minifier usa nel deploy. Se non lo sono, il deploy fallisce solo dopo il push (è successo con
// `catch {` senza parametro): meglio fermare il commit. Niente sintassi ES2019+ (`catch {`, `?.`, `??`).
import { execFileSync } from "node:child_process";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);
let uglify;
try {
  uglify = require("uglify-es");
} catch {
  console.error("uglify-es non è installato: esegui npm install nella cartella del sito e riprova.");
  process.exit(1);
}

const staged = execFileSync("git", ["diff", "--cached", "--name-only", "--diff-filter=ACMR", "-z"], { encoding: "utf8" })
  .split("\0")
  .filter((file) => /^assets\/js\/.*\.js$/.test(file) && !file.endsWith(".min.js"));

let failed = false;
for (const file of staged) {
  const code = execFileSync("git", ["show", `:${file}`], { encoding: "utf8" }); // versione in staging
  const result = uglify.minify(code);
  if (result.error) {
    failed = true;
    console.error(`${file}:${result.error.line}:${result.error.col} ${result.error.message}`);
  }
}
if (failed) {
  console.error("\nCommit interrotto: il minificatore del deploy (uglify-es 3.3.9) non accetta questa sintassi.");
  process.exit(1);
}
