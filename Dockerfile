FROM mcr.microsoft.com/devcontainers/base:jammy
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive

# set default shell for vscode
RUN usermod --shell /usr/bin/zsh vscode

# give sudo access to vscode
RUN echo vscode ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/vscode && chmod 0440 /etc/sudoers.d/vscode

USER vscode

# https://github.com/Schniz/fnm/issues/1203
ARG NODE_VERSION=22

# install fnm (and node)
RUN curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
RUN echo '\nexport PATH="/home/vscode/.local/share/fnm:$PATH"\neval "$(fnm env --corepack-enabled --use-on-cd --shell zsh)"' >> /home/vscode/.zshrc
RUN mkdir -p /home/vscode/.oh-my-zsh/completions \
  && /home/vscode/.local/share/fnm/fnm completions --shell zsh > /home/vscode/.oh-my-zsh/completions/_fnm \
  && /home/vscode/.local/share/fnm/fnm install --corepack-enabled $NODE_VERSION \
  && /home/vscode/.local/share/fnm/fnm default $NODE_VERSION

# install deno
RUN curl -fsSL https://deno.land/install.sh | sh
RUN echo '\nexport DENO_INSTALL="/home/vscode/.deno"\nexport PATH="$DENO_INSTALL/bin:$PATH"' >> /home/vscode/.zshrc

# install bun
RUN curl -fsSL https://bun.sh/install | bash
