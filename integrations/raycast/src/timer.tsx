import { Action, ActionPanel, Icon, List, closeMainWindow, showHUD } from "@raycast/api";
import { execFile } from "node:child_process";
import { promisify } from "node:util";
import { homedir } from "node:os";
import { useState } from "react";

const run = promisify(execFile);
const BIN = `${homedir()}/.local/bin/adderall`;
const PRESETS = ["15m", "30m", "1h", "2h", "4h", "8h"];

async function arm(duration: string) {
  await closeMainWindow();
  try {
    await run(BIN, ["on", duration]);
    await showHUD(`💊 Adderall ON — auto-off in ${duration}`);
  } catch {
    await showHUD(`⚠️ Invalid duration: ${duration}`);
  }
}

export default function Command() {
  const [text, setText] = useState("");
  const custom = text.trim();
  const showCustom = custom.length > 0 && !PRESETS.includes(custom);

  return (
    <List searchBarPlaceholder="Pick a duration, or type one (2h, 45m, 90s)…" onSearchTextChange={setText}>
      {showCustom && (
        <List.Section title="Custom">
          <List.Item
            icon={Icon.Clock}
            title={custom}
            subtitle="Keep awake for this duration"
            actions={
              <ActionPanel>
                <Action title={`Keep Awake for ${custom}`} icon={Icon.Clock} onAction={() => arm(custom)} />
              </ActionPanel>
            }
          />
        </List.Section>
      )}
      <List.Section title="Presets">
        {PRESETS.map((p) => (
          <List.Item
            key={p}
            icon={Icon.Clock}
            title={p}
            subtitle="auto-off after"
            actions={
              <ActionPanel>
                <Action title={`Keep Awake for ${p}`} icon={Icon.Clock} onAction={() => arm(p)} />
              </ActionPanel>
            }
          />
        ))}
      </List.Section>
    </List>
  );
}
