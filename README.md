# goose-cli

Goose CLI with some extra packages.

## Usage

The image default workdir is an empty `/workspace` directory that can be mounted.

Configure it via environment variables for easier set up.

Example: Google provider:

```sh
export GOOGLE_API_KEY="Yourkeyhere"
export GOOSE_PROVIDER="google"
export GOOSE_MODEL="gemini-3-pro-preview"
export GOOSE_MODE="auto"
```

```sh
docker run \
    --rm \
    --interactive \
    --tty \
    --env GOOSE_PROVIDER \
    --env GOOSE_MODEL \
    --env GOOSE_MODE \
    --env GOOGLE_API_KEY \
    --volume "$(pwd):/workspace" \
    andreswebs/goose-cli run \
        --with-builtin developer \
        --text "are you operational?"
```

## Authors

**Andre Silva** - [@andreswebs](https://github.com/andreswebs)

## License

This project is licensed under the [Unlicense](UNLICENSE).
