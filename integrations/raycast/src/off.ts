import { showHUD } from "@raycast/api";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { homedir } from "node:os";

const run = promisify(execFile);
const BIN = `${homedir()}/.local/bin/adderall`;

export default async function Command() {
  try {
    await run(BIN, ["off"]);
    await showHUD("😴 Adderall OFF — normal sleep restored");
  } catch {
    await showHUD("⚠️ Couldn't turn Adderall off (is it installed?)");
  }
}
