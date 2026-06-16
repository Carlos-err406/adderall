import { existsSync } from "node:fs";
import { homedir } from "node:os";

/**
 * Resolve the `adderall` binary across install methods. Raycast runs with a
 * minimal PATH, so check the common locations explicitly before falling back to
 * the bare name (PATH lookup).
 */
export function adderallBin(): string {
  const candidates = [
    `${homedir()}/.local/bin/adderall`,
    "/opt/homebrew/bin/adderall",
    "/usr/local/bin/adderall",
  ];
  return candidates.find((p) => existsSync(p)) ?? "adderall";
}
