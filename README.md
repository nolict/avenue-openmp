# Avenue Roleplay

Avenue Roleplay is a Pawn-based roleplay gamemode for SA-MP/open.mp. The project is being maintained as a modular codebase so gameplay features, commands, dialogs, data, and configuration stay easier to develop and review.

## Requirements

- Linux server environment
- open.mp runtime
- `sampctl`
- MySQL server
- Plugins/runtime matching `config.json`

## Setup

Install Pawn dependencies:

```bash
sampctl ensure
```

Create local database configuration:

```bash
cp gamemodes/modules/core/settings/database.pwn.example gamemodes/modules/core/settings/database.pwn
```

Fill `SQL_HOSTNAME`, `SQL_USERNAME`, `SQL_DATABASE`, and `SQL_PASSWORD` for your database.

Build gamemode:

```bash
sampctl build
```

Run open.mp server from project root.

## Configuration

Runtime server configuration lives in `config.json`, including server name, website, port, main script, and legacy plugins.

Database credentials live in `gamemodes/modules/core/settings/database.pwn`. This file is ignored by git. Do not commit real credentials. Use `database.pwn.example` as the shared template.

## Development

- Gamemode entry point: `gamemodes/main.pwn`
- Feature implementation: `gamemodes/modules/`
- Module guide: `docs/structure.md`
- Runtime config: `config.json`

Keep feature logic out of `main.pwn`. Follow existing module patterns and split commands, dialogs, data, logic, settings, and world content by responsibility.

## Contributing

1. Create a branch for your change.
2. Read `docs/structure.md` before adding features.
3. Place new files in the correct module domain.
4. Do not commit credentials, logs, build artifacts, or local-only files.
5. Run `sampctl build` before opening a pull request.
6. Explain what changed and how it was verified.

## License

This project is licensed under the [AGPL-3.0 License](LICENSE).
