import { showHUD } from "@raycast/api";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { adderallBin } from "./adderall";

const run = promisify(execFile);
const BIN = adderallBin();

export default async function Command() {
  try {
    await run(BIN, ["on"]);
    await showHUD("💊 Adderall ON — staying awake");
  } catch {
    await showHUD("⚠️ Couldn't turn Adderall on (is it installed?)");
  }
}
