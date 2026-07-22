# Self-hosted LLMs for development, on Windows

This readme aims to teach you how to:
- self-host LLM models
- configure an agentic coding helper via opencode

## Installation

### LM Studio

LM Studio will be used to download, configure and run the LLM models of your choice. 

1. Install: https://lmstudio.ai/
2. Download a model, for example `mistralai/devstral-small-2-2512`

### Windows Sub-system for Linux

WSL will be used to run 

##### Install WSL ([docs](https://learn.microsoft.com/en-us/windows/wsl/install))

```bash
wsl --install
```
##### Configure networking

This is required to be able to access LM Studio via `localhost` from inside WSL.

Set up mirrored networking mode ([docs](https://learn.microsoft.com/en-us/windows/wsl/networking)) by creating a `.wslconfig` file in the `%USERPROFILE%` directory with the following content:

```
[wsl2]
networkingMode=mirrored
```

Restart WSL:

```bash
wsl --shutdown
```

Wait a few seconds, then start WSL again:

```bash
wsl
```

Try to access LM Studio from WSL:

```bash
curl http://localhost:1234/v1/models
```

You should see something like:

```json
{
  "data": [
    {
      "id": "qwen/qwen3.6-27b",
      "object": "model",
      "owned_by": "organization_owner"
    },
    {
      "id": "text-embedding-nomic-embed-text-v1.5",
      "object": "model",
      "owned_by": "organization_owner"
    }
  ],
  "object": "list"
}
```

### opencode

##### Install inside WSL ([docs](https://opencode.ai/docs/windows-wsl)):

```bash
curl -fsSL https://opencode.ai/install | bash
```
##### Configure LM Studio as a provider

Run opencode:

```bash
opencode
```

Connect to a provider by typing `/connect`, and search for `LMStudio`. Enter `anything` when prompted for the API key.

```bash
/connect
```

You can prompt now. Regardless of what model you select, whatever is loaded in your LM Studio server will answer.