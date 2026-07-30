# What is this

This repository is a rough demo version of my opencode setup. 

It is not meant to be perfect, it's just meant to illustrate the idea behind the workflow.

# Setup

I run this in a Docker container on an Ubuntu server in my WSL, and use it via [Windows Terminal](https://aka.ms/terminal) from Windows 11.

The rest of this guide assumes you have WSL installed. ([docs](https://learn.microsoft.com/en-us/windows/wsl/install))

## Configure

Change what folder is being mounted to `/workspace` in the `docker-compose.yaml` file:

```yaml
services:

  opencode:
    // ...
    volumes:
      // ...
      - C:/git/your-workspace:/workspace
```

In the context of this demo, this is meant to be the folder containing your dotnet solution.

## Build & run

```bash
docker compose build && docker compose run --remove-orphans opencode
```

# Self-hosting LLMs

This section will show you how to self-host LLMs on Windows, via LM Studio.

As a side note, this should probably be containerized too, but I just tried this as an experiment and not willing to put more time into it at the moment.

## LM Studio

LM Studio will be used to download, configure and run the LLM models of your choice. 

1. Install: https://lmstudio.ai/
2. Download a model, for example `mistralai/devstral-small-2-2512`
3. In `Developer > Local server`, run the server, and load your model

You can also download models from [Hugging Face](https://huggingface.co/), but do not forget to read the readmes, and properly configure settings. This guide will not go into details about this.

## Configure networking in WSL

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

At this point, you could connect from opencode by typing `/connect`, and searching for `LMStudio`. Enter literally anything when prompted for the API key. But I do recommend setting this up via the configuration file.

### Connect from opencode

#### Via the configuration file

Edit the `opencode.jsonc` file, and add LM Studio as a provider, including any models you might be running in it:

```jsonc
{
  "$schema": "https://opencode.ai/config.json",
  "provider": {
    "lmstudio": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LM Studio (local)",
      "options": {
        "baseURL": "http://host.docker.internal:1234/v1"
      },
      "models": {
        "qwen/qwen3.5-9b": {
          "name": "qwen/qwen3.5-9b (local)"
        },
        "qwen/qwen3.6-27b": {
          "name": "qwen/qwen3.6-27b (local)"
        },
        "qwen3.6-35b-a3b-mtp": {
          "name": "qwen3.6-35b-a3b-mtp (local)"
        },
        "mistralai/devstral-small-2-2512": {
          "name": "mistralai/devstral-small-2-2512 (local)"
        }
      }
    }
  },
  // etc
```

You can now select models via the `/model` command.

If you enable "Just-in-Time Model Loading" in LM Studio (under `Developer > Local server`), it will automatically load whatever model is selected in opencode.