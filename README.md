![K Means AI Maestro™](docs/images/maestro.png)

# K Means AI Maestro™ Releases

Public download repository for K Means AI Maestro™ binaries, release notes, checksums, and user-facing setup documentation.

K Means AI Maestro™ is the terminal-based multi-LLM collaboration app in the K Means AI Symphony™ suite. It lets you run a shared conversation across several language models, compare their responses, assign roles, preserve useful context, and use an optional integrator model to summarize, synthesize, vote, and compact long-running chats.

Maestro is lightweight, portable, and provider-agnostic. It runs from a local terminal, supports OpenAI, OpenAI-compatible, Anthropic, and Google Gemini chat providers, keeps orchestration logic outside the providers, and can operate in environments where browser-based workflows, hosted control planes, or heavyweight collaboration suites are not a good fit.

Use Maestro when you need several independent reasoning passes over the same material, a durable transcript of how conclusions were reached, or a repeatable command-line workflow for analysis, review, planning, incident response, product strategy, policy exploration, or mission-sensitive decision support.

Learn more at [kmeans.ai](https://kmeans.ai).

The source code is maintained separately. This repository is intended for users who want to download and run Maestro without cloning or building the private source repository. Keep credentials, private configuration, and local transcripts out of this public repository.

## License Notice

K Means AI Maestro™ is proprietary software.

Copyright (C) K MEANS AI LLC. All rights reserved.

Binaries in this repository are provided for evaluation and use according to the terms supplied by K MEANS AI LLC. No source-code license is granted.

## Highlights

- Run multiple chat models in one shared conversation.
- Enable or disable models while the conversation is running.
- Use an integrator model for private synthesis, voting, and long-context compaction.
- Attach files to a turn.
- Save, load, stash, and restore full conversation sessions.
- Keep persistent memory and per-model roles during a session.
- Display Markdown-formatted model responses directly in the console.
- Export clean chat output as text or styled HTML.
- Auto-compact long model histories to reduce context-limit failures.

Integrators are designed to function as unbiased observers. They do not actively participate as regular members in the multi-model chat context; instead, they watch from the operator layer and provide synthesis, voting, compaction, and private administrative reasoning when explicitly enabled.

## Release Notes

Current release summary:

**K Means AI Maestro™ initial production release**

- Terminal-native multi-model chat for OpenAI, OpenAI-compatible, Anthropic, and Google Gemini providers.
- Private integrator layer for synthesis, voting, admin mode, and long-context compaction.
- Polished console experience with startup preflight, Markdown rendering, model mention highlighting, command history, and safer terminal color fallback.
- Session save/load, clean text and HTML export, diagnostics, support bundles, and release smoke-test scripts.
- Experimental attachment handling with capability-gated delivery and clear user warnings.

Each published GitHub release should include runtime-specific archives and matching checksums.

## Download

Use the archive that matches your operating system and CPU architecture. Download the latest archive from this repository's GitHub Releases page.

Recommended archive names:

```text
maestro-osx-arm64.zip
maestro-osx-x64.zip
maestro-linux-x64.zip
maestro-win-x64.zip
```

Each archive includes the Maestro executable and the required runtime assets:

```text
maestro executable
maestro.settings.json
maestro.telemetry.settings.xml
maestro.settings.schema.json
PromptTemplates/
demo/
README.md
```

## Quick Start

1. Download the release archive for your system.
2. Extract the archive to a local folder.
3. Open `maestro.settings.json` and configure your model providers, endpoints, and credentials.
4. Set any environment variables referenced by `env:...` credentials. Environment variables are recommended for API keys.
5. Run the `maestro` executable from the extracted folder.

macOS/Linux:

```bash
./maestro
```

Windows PowerShell:

```powershell
.\maestro.exe
```

You can also point Maestro at a specific settings file:

```bash
./maestro --config path/to/maestro.settings.json
```

Validate the install before a live session:

```bash
./maestro --version
./maestro --doctor --config path/to/maestro.settings.json
./maestro --validate-config --config path/to/maestro.settings.json
```

Keep `PromptTemplates/`, telemetry settings, schema, and other bundled artifacts beside the executable unless you intentionally use `--config` with another settings folder.

## Verify Downloads

When checksums are provided, compare the downloaded archive against the matching checksum in `checksums/` before running Maestro.

macOS/Linux example:

```bash
shasum -a 256 maestro-osx-arm64.zip
```

Windows PowerShell example:

```powershell
Get-FileHash .\maestro-win-x64.zip -Algorithm SHA256
```

## Configuration

Maestro uses `maestro.settings.json` to define model participants, integrators, providers, prompts, colors, startup input, and CLI behavior.

The `Models` array has two groups:

1. Integrators/operators
2. Regular chat models/members

Example:

```json
{
  "Models": [
    [
      {
        "Alias": "ops",
        "Name": "gpt-5.2",
        "Endpoint": "https://api.openai.com/v1",
        "Credential": "env:OPENAI",
        "Provider": "OpenAI",
        "SystemPrompt": "file:KM.Maestro.Integrator.System.prompt",
        "Prompt": "file:KM.Maestro.Integrator.Protocol.prompt",
        "Participating": false,
        "Capabilities": {
          "Attachments": "experimental"
        },
        "ChatColor": ""
      }
    ],
    [
      {
        "Alias": "gpt",
        "Name": "gpt-5.2",
        "Endpoint": "https://api.openai.com/v1",
        "Credential": "env:OPENAI",
        "Provider": "OpenAI",
        "SystemPrompt": "file:KM.Maestro.System.prompt",
        "Prompt": "file:KM.Maestro.Protocol.prompt",
        "Participating": true,
        "Capabilities": {
          "Attachments": "experimental"
        },
        "ChatColor": "156;132;212"
      }
    ]
  ],
  "Administrator": "you",
  "Verbosity": 1,
  "Cursor": "line",
  "Prompt": " %",
  "ConsoleVisuals": true
}
```

### API Key Shortcuts

Example environment variables:

```bash
export OPENAI="your-openai-key"
export AZURE="your-azure-key"
export ANTHROPIC="your-anthropic-key"
export GOOGLE="your-google-key"
```

In `maestro.settings.json`, `Credential` supports two shortcut formats:

```json
"Credential": "env:OPENAI"
```

`env:OPENAI` reads the API key from the `OPENAI` environment variable.

```json
"Credential": "key:sk-your-api-key"
```

`key:sk-your-api-key` uses the literal key value from the settings file.

The shortcut prefix is case-insensitive, so `ENV:OPENAI`, `env:OPENAI`, `KEY:...`, and `key:...` are accepted. Environment variables are recommended because they keep secrets out of configuration files.

### Model Fields

- `Alias`: Short name used in commands, for example `#gpt`. Aliases cannot use reserved special token names such as `date`, `models`, or `integrator`.
- `Name`: Provider model name.
- `Endpoint`: Provider endpoint URL.
- `Credential`: Either `env:VARIABLE_NAME` or `key:actual-api-key`.
- `Provider`: Completion provider. Supported values are `OpenAI`, `OpenAICompatible`, `Anthropic`, and `GoogleGemini`. If omitted, Maestro defaults to `OpenAI`.
- `SystemPrompt`: Prompt text or `file:template-name`.
- `Prompt`: Protocol prompt text or `file:template-name`.
- `Participating`: Whether the model starts active.
- `Capabilities.Attachments`: Native attachment capability for this model: `supported`, `partial`, `experimental`, or `unsupported`.
- `ChatColor`: Optional RGB terminal color string such as `156;132;212`. Omit it or leave it blank to use the terminal's default foreground color. Invalid values are ignored. Avoid `0;0;0` unless your terminal uses a light background.

Provider guidance:

| Provider | Use for |
| --- | --- |
| `OpenAI` | OpenAI API models. |
| `OpenAICompatible` | OpenAI-compatible endpoints such as Azure OpenAI-compatible deployments or other compatible gateways. |
| `Anthropic` | Anthropic Claude models through the native Anthropic provider path. |
| `GoogleGemini` | Google Gemini models through the native Gemini provider path. |

Prompt files are resolved from Maestro's `PromptTemplates` folder when using `file:name`.

Top-level display setting:

- `ConsoleVisuals`: Boolean setting for decorative console presentation such as startup mascot artwork. Missing or `false` hides the mascot and keeps the startup panel minimal.

At startup, Maestro runs a live preflight for participating chat models before showing the prompt. Models that fail startup are paused with a clear error. If an enabled integrator fails, normal member chat still starts, but integrator-only features such as synthesis, compaction, and admin mode remain unavailable until an integrator is enabled successfully.

## Enterprise Readiness

Run `--doctor` before first use, after editing `maestro.settings.json`, and before sharing a release internally. It checks settings, model aliases, providers, endpoints, credential references, prompt files, input scripts, telemetry, logs, schema presence, compaction, attachment capability declarations, active models, integrator state, and proxy-related environment variables.

Inside Maestro, use:

```text
/version
/doctor
/support bundle
```

`/support bundle` creates a sanitized ZIP under `logs/support/` unless you provide a path. It includes diagnostic metadata, redacted settings, and a redacted telemetry log tail when available. Review the bundle before sharing externally. It intentionally does not include chat transcripts, stash files, attached file contents, exported conversations, or prompt artifacts.

### Exit Codes

| Code | Meaning |
| --- | --- |
| `0` | Success. |
| `1` | Diagnostic errors found by `--doctor` or `--validate-config`. |
| `2` | Settings/configuration error before startup. |
| `3` | Startup completed config load but no active member model was available. |
| `10` | Reserved for unexpected startup/runtime failures. |

### Release Smoke Tests

If the release includes the `scripts/` folder, validate an extracted binary with:

```bash
scripts/smoke-test.sh ./maestro ./maestro.settings.json
```

```powershell
.\scripts\smoke-test.ps1 -AppPath .\maestro.exe -ConfigPath .\maestro.settings.json
```

The smoke scripts run `--version` and `--doctor`. They expect required environment variables in `maestro.settings.json` to be set.

### Corporate Networks and Proxies

Maestro uses .NET HTTP clients and provider SDKs underneath the shared chat-completion layer. In managed networks, make sure outbound HTTPS is allowed to each configured provider endpoint. Standard proxy variables such as `HTTPS_PROXY`, `HTTP_PROXY`, and `NO_PROXY` are detected by diagnostics and are commonly honored by .NET networking, but provider-specific SDK behavior can vary.

If your environment uses TLS inspection or private certificate authorities, validate trust at the OS/runtime level before starting Maestro. Use `--doctor` first, then run normal startup preflight to verify live provider access.

## Prompt Templates

Prompt templates are critical runtime files. You can edit them, but changes can significantly alter model behavior or break Maestro's expected protocol. Keep backup copies before experimenting.

## Integrators

Integrator models are private operator models. They can be used for:

- Startup coordination
- Manual synthesis
- Voting prompts
- Compacting long histories
- Admin/operator mode

Enable an integrator before using synthesis or compaction:

```text
/integrator enable #ops
```

List integrators:

```text
/integrator
```

## Basic Use

Type a message and press Enter. Active regular models respond in sequence, and Markdown-formatted output is rendered directly in the console.

You can mention models by alias in your messages. Model mentions such as `#gpt` are highlighted in model output when that model has a valid `ChatColor` configured:

```text
What do you think about this plan, #gpt?
```

## Special Input Tokens

Special tokens expand only when used as standalone tokens, so normal words such as `#nowhere` are left alone. Model aliases cannot use these reserved names.

| Token | Expands to |
| --- | --- |
| `#date` | Current long date. |
| `#today` | Same as `#date`. |
| `#time` | Current long time. |
| `#datetime` | Current long date and time. |
| `#now` | Same as `#datetime`. |
| `#ip` | Local IP address, or `unknown` if unavailable. |
| `#cwd` | Current working directory. |
| `#user` | Configured `Administrator` value. |
| `#models` | Active member model aliases with `#` prefixes, or `none`. |
| `#integrator` | Active integrator alias with a `#` prefix, or `none`. |
| `#mode` | Current session mode. |
| `#memory` | Session memory joined with semicolons, or `none`. |
| `#attachments` | Pending attachment descriptions, or `none`. |
| `#roles` | Assigned model roles, or `none`. |
| `#compact` | Compaction state: auto mode, threshold, keep count, and active integrator. |

Typing `...` expands to `continue`.

## URL Handling

Maestro does not fetch webpage content from URLs automatically. Chat providers usually treat URLs as plain text, so for reliable analysis you should paste the relevant page text or attach a local extracted document.

## Commands

Commands start with `/`.

Use `/help` inside Maestro to see commands grouped by area. Use `/doctor` to check enterprise readiness and `/support bundle` to create a sanitized support package.
In interactive sessions, use the up and down arrow keys to move through recent input history.

### Model Commands

```text
/model
/model list
/model status #alias
/model enable #alias
/model disable #alias
/model reset #alias
```

Integrator commands use the same shape:

```text
/integrator
/integrator enable #alias
/integrator disable #alias
/integrator reset #alias
```

### Conversation State

```text
/status
/version
/doctor
/support bundle
/history
/history #alias
/history #alias 10
/retry #alias
/retry all
/purge
```

`purge` resets conversation history back to the first assistant message for each model.

### Synthesis and Voting

```text
/synthesis on
/synthesis off
/synthesis now
/vote your question here
```

Synthesis requires an enabled integrator.

### Compaction

Compaction uses an enabled integrator to summarize older chat history while keeping recent messages intact.

```text
/compact
/compact #alias
/compact shared
/compact all
/compact status
/compact auto on
/compact auto off
/compact threshold 60
/compact keep 12
```

Recommended flow:

```text
/integrator enable #ops
/compact auto on
```

If a model hits a context limit, compact and retry:

```text
/compact #gpt
/retry #gpt
```

When auto compaction is enabled and an integrator is active, Maestro will guide you to retry after the automatic compaction pass.

### Memory, Roles, and Artifacts

```text
/remember important project fact
/memory
/forget 1
/forget all
```

```text
/role #alias
/role #alias reviewer
```

```text
/artifact
/artifact list
/artifact name
/artifact name content
/artifact append name content
/artifact show name
```

Memory and role information is inserted into future user turns.

### Attachments

Attachments are experimental. Chat providers do not standardize file, image, audio, and document semantics consistently, so Maestro uses capability-gated delivery and clear warnings instead of assuming every model can receive every attachment.

```text
/pwd
/cd path/to/folder
/cd -
/ls
/ls path/to/folder
/attach path/to/file
/attachments
/detach path/to/file
/detach *
```

Attachments are included on the next user turn and then cleared after the turn.
Relative attachment paths resolve from Maestro's file directory, which starts beside your active settings file. Use `/pwd` to show the current directory, `/cd` to change it, `/cd -` to return to the previous folder, and `/ls` to inspect files before attaching them.
You can detach by full path, relative path, or by file name. Attachments are limited to 25 MB each.
Supported types: `png`, `jpg`, `jpeg`, `gif`, `mp3`, `wav`, `pdf`, `doc`, `docx`, `txt`, `md`, `markdown`, `csv`, `json`, and `log`.

Maestro chooses one delivery mode for all active recipients. It sends native attachment parts only when active model capabilities allow it, falls back to shared text context when equivalent text can be extracted, and blocks the turn when the attachment cannot be shared fairly across active models.

### Save, Restore, and Export

```text
/stash "label"
/stash "label" custom-id
/pop latest
/pop custom-id
/drop custom-id
/list
```

Convenience aliases:

```text
/save name
/load name
```

Stashes and saved sessions restore the shared transcript, model histories across all groups, active model state, mode, memory, roles, artifacts, and compaction settings. Pending attachment references are not restored automatically; reattach files intentionally after loading. User turns with attachment content are preserved in model histories, so `.chat` files can contain encoded file content from attached turns.

Export shared conversation output:

```text
/generate text
/generate html
```

Exports are intended for sharing: they remove Maestro's internal session context from user turns and write either plain text or a complete HTML document.

### Admin Mode

```text
/admin
```

Admin mode switches between regular member chat and private integrator/operator chat. It requires an enabled integrator.

### Exit

```text
/quit
/exit
```

## Long-Running Conversations

For long sessions, enable an integrator and turn on auto compaction:

```text
/integrator enable #ops
/compact auto on
```

Maestro warns when model histories are growing large. Auto compaction runs after user turns when histories exceed the configured threshold.

Useful defaults:

```text
/compact threshold 60
/compact keep 12
```

`threshold` is the message count that triggers compaction. `keep` is the number of recent messages preserved exactly.

## Input Files and Session Automation

The `Input` setting can point to a plain-text file and run it as an automated Maestro session:

```json
"Input": "file:demo/symphony-technical-incident-lab.input"
```

Each non-empty line is typed into Maestro as if a user entered it at the prompt. Input files can mix regular chat turns with slash commands, so they are useful for repeatable setup, scripted analysis, demos, training runs, evaluations, regression checks, or any workflow where you want the same multi-model session to run consistently.

Maestro uses this subsystem for guided demos, but it is also a practical automation feature. A script can enable or disable models, switch modes, assign roles, attach context, navigate folders, load artifacts, run synthesis, export results, and then exit when the final scripted line completes.

Typing speed for scripted input is controlled by `KeyRate` and `KeyDelay` in `maestro.settings.json`. `KeyRate` is the base per-character rhythm, while Maestro adds proportional pauses around spaces, punctuation, symbols, and sentence boundaries so automated sessions still feel readable and natural.

## Troubleshooting

### Bad Credentials

If a model reports a credential error, check:

- The `Credential` setting
- The environment variable name
- The endpoint URL
- Whether the provider supports the configured model name

### No Integrator Enabled

Commands like synthesis, voting, compaction, and admin mode require an enabled integrator:

```text
/integrator enable #alias
```

### Context Limit Exceeded

Compact the affected model and retry:

```text
/compact #alias
/retry #alias
```

### Model Not Responding

Check whether it is active:

```text
/model status #alias
```

Then enable or retry:

```text
/model enable #alias
/retry #alias
```

## Support

If Maestro cannot start, first check:

- `maestro.settings.json` exists next to the executable.
- API key environment variables are set in the same shell used to launch Maestro.
- Model names, endpoints, and credentials match your provider.
- At least one chat model is enabled.

For command help inside Maestro, run:

```text
/help
```

## Notes

Maestro is intended for local, terminal-based multi-model workflows. Be careful with sensitive data: prompts, attached files, stashed sessions, generated exports, and conversation content may contain information that is sent to whichever model providers you configure.
