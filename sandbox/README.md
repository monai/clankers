# sandbox

Debian `trixie-slim` coding-agent container.

## Build

Images: `base` (core tools, root, no agents) → `slim` (agent user, agents, tmux, vim) → `full` (chromium, compilers, debug tools).

```sh
docker buildx bake            # all
docker buildx bake slim   # one
```

## Run

```sh
docker run --rm -it -v "$PWD:/workspace" sandbox:slim
```

```sh
docker run --rm -it -e TERM_PROGRAM=$TERM_PROGRAM -v agent-home:/home/agent -v "$PWD:/workspace" sandbox:slim
```
