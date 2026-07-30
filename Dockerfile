FROM node:lts-bookworm

# SET UP .NET
# https://learn.microsoft.com/en-us/dotnet/core/tools/dotnet-install-script

ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH="${DOTNET_ROOT}:${PATH}"
ENV DOTNET_NOLOGO=true
ENV DOTNET_CLI_TELEMETRY_OPTOUT=true

RUN curl -fsSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh \
    && chmod +x /tmp/dotnet-install.sh \
    && /tmp/dotnet-install.sh --channel 10.0 --install-dir "${DOTNET_ROOT}" \
    && rm /tmp/dotnet-install.sh

RUN dotnet workload update

# SET UP OPENCODE
# https://opencode.ai/

RUN npm install -g opencode-ai

# SET UP NON-ROOT USER 
# & FOLDER PERMISSIONS

RUN adduser --disabled-password opencode

RUN mkdir -p /home/opencode/.local/share/opencode \
    && mkdir -p /home/opencode/.local/state/opencode \
    && mkdir -p /home/opencode/.config/opencode \
    && chown -R opencode:opencode /home/opencode

# SWITCH TO NON-ROOT USER

USER opencode

# SET UP LSP / LANGUAGE SERVER
# https://github.com/dotnet/roslyn/blob/main/docs/roslyn-language-server-copilot-plugin.md

ENV PATH="/home/opencode/.dotnet/tools:${PATH}"
RUN dotnet tool install -g roslyn-language-server --prerelease

# SET WORKING DIRECTORY

WORKDIR /workspace