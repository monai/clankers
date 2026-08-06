# sandbox

Debian `trixie-slim` coding-agent container.

## Build

```sh
docker build -t sandbox .
```

## Run

```sh
docker run --rm -it -v "$PWD:/workspace" sandbox
```

```sh
docker run --rm -it -v agent-home:/home/agent -v "$PWD:/workspace" sandbox
```

```sh
docker run --rm -it -e TERM_PROGRAM=$TERM_PROGRAM -v "$PWD:/workspace" sandbox
```
