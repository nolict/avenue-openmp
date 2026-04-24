# Gamemode Structure

Compact guide for placing code in `gamemodes/`. No tree required.

## Quick Rules

| Rule | Use |
| --- | --- |
| Keep `main.pwn` thin | Includes, global declarations, module loaders, `main()` only |
| Pick one owner module | Put feature code in domain that owns behavior |
| Split by role | Commands in `commands`, dialogs in `dialogs`, state in `data`, behavior in `logic` |
| Avoid global helpers | Use `core` only for shared infrastructure |
| Build before PR | Run `sampctl build` |

## Where To Put Code

| Feature type | Module |
| --- | --- |
| Server config, constants, database callbacks, shared helpers, admin basics | `core` |
| Login, register, character, spawn, player runtime, player commands | `player` |
| Houses, businesses, entrances, property storage, ownership | `property` |
| Dynamic vehicles, dealership, fuel, tuning, impound, vehicle events | `vehicle` |
| Factions, ranks, lockers, gates, arrest, enforcement flows | `faction` |
| Jobs, job dialogs, job runtime, job rewards | `job` |
| Inventory, items, phone, crates, plants, ATM, vendors, backpacks | `system` |
| Textdraws, dialog UI, click handling, model selection | `interface` |
| World objects, locations, GPS/navigation, map icons | `mapping` |
| Admin-created dynamic world entities and CRUD flows | `dynamic` |
| Banking, tax, payments, lottery, money flow | `economy` |

## Folder Roles

| Folder | Purpose |
| --- | --- |
| `commands` | Command handlers |
| `dialogs` | Dialog response handlers and UI routing |
| `data` | Enums, arrays, static domain state |
| `logic` | Main gameplay functions and domain behavior |
| `settings` | Domain configuration |
| `constants` | Shared fixed values |
| `macros` | Macro helpers |
| `database` | Shared SQL callbacks and query helpers |
| `textdraws` | Global/player textdraw creation |
| `world` | Static objects, pickups, labels, map placement |

## Feature Workflow

1. Choose owner module from table above.
2. Check existing files in that module.
3. Put command/dialog/data/logic in matching folder.
4. Include new file through existing module loader.
5. Add header comment for new top-level functions:

```pawn
// ====== FunctionName ======
FunctionName()
{
    return 1;
}
```

6. Run:

```bash
sampctl build
```

## Contribution Guardrails

| Do | Avoid |
| --- | --- |
| Follow existing naming and include order | New feature logic in `main.pwn` |
| Keep domain ownership clear | Mixing unrelated modules |
| Keep credentials local | Committing `database.pwn` |
| Update docs when setup/structure changes | Silent structure changes |
| Build before PR | Unverified changes |
