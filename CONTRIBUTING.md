# Contributing to Chicken-game

Thanks for helping out! Chicken-game is a 2D top-down game made in **Godot 4.7** (Forward Plus renderer) with **GDScript**. This guide covers how to set the project up, how we use Git, and the conventions that keep the project easy to work on.

## Getting started

1. Install **Godot 4.7** (the standard, non-.NET build is enough for the GDScript code).
2. Clone the repository:
   ```bash
   git clone https://github.com/Brayden-I/Chicken-game.git
   ```
3. In Godot's Project Manager, choose **Import** and select `new-game-project/project.godot`.
   The Godot project lives in the `new-game-project/` folder, not the repository root.
4. Let Godot finish importing assets the first time (it creates a local `.godot/` folder, which is not committed).
5. Press **F5** to run the main scene and make sure everything works before you change anything.

## Project layout

```
new-game-project/
├── assets/            Raw art and audio only (no scenes or scripts)
├── autoload/          Global singletons (e.g. global.gd)
├── entities/
│   ├── player/        Player scene + script
│   └── enemies/       Enemy base scene, EnemyData resource, types/, spawning/
├── levels/
│   ├── main.tscn
│   └── generation/    BSP map generation
├── dev/               Test scenes that are not shipped (e.g. visualized tester)
├── ui/
└── project.godot
```

Keep each feature's scene, script and data together in its own folder instead of splitting scenes and scripts into separate top-level folders.

## Branches and workflow

`master` should always run. Never commit unfinished work directly to it.

1. Start from an up-to-date `master`:
   ```bash
   git switch master
   git pull
   git switch -c feature/short-description
   ```
2. Make small, focused commits on your branch.
3. Push your branch and open a **pull request** into `master`.
4. Merge once the game runs and the checklist below is done, then delete the branch.

**Branch names:** lowercase words joined with hyphens, with one of these prefixes:

| Prefix | Use for | Example |
|---|---|---|
| `feature/` | New functionality | `feature/enemy-types` |
| `fix/` | Bug fixes | `fix/enemy-chase` |
| `chore/` | Cleanup, restructuring, tooling | `chore/restructure-files` |
| `docs/` | Documentation only | `docs/contributing` |

Keep one purpose per branch. If you need to do something unrelated, make a separate branch.

**If your branch depends on another unmerged branch,** say so in the pull request, and merge them in order.

## Commit messages

- Write a short summary in the imperative mood: `Add ranged enemy scene`, `Fix zero-size BSP rooms`.
- Keep the first line under about 70 characters; add detail on following lines if needed.
- Don't mix unrelated changes in one commit. In particular, do file moves and renames in their own commit so Git can track them as renames.

## Code style (GDScript)

- **Files and folders:** `snake_case` (`bsp_generator.gd`, `enemy.tscn`). Linux is case-sensitive, so exact casing matters.
- **Classes** (`class_name`): `PascalCase` (`BSPGenerator`, `EnemyData`).
- **Variables and functions:** `snake_case`; **constants:** `UPPER_SNAKE_CASE`; **signals:** past tense (`generation_finished`).
- Use **static types** where you can (`var health: int = 3`, `func spawn() -> Enemy:`).
- Expose tunable values with `@export` and group them with `@export_group`. Add `##` doc comments so they show up as tooltips in the Inspector.
- Prefer signals and exported references over hard-coded `get_node("../../Thing")` paths.
- Move with `velocity` and `move_and_slide()` for `CharacterBody2D`, not by setting `position` directly, so collisions work.
- Don't leave `print()` debugging in code you submit.

## Working with Godot files in Git

- **Commit `.uid` files** that sit next to scripts and resources. They keep references working across branches and machines.
- **Don't commit `.godot/`**. It is in `.gitignore` and is regenerated locally.
- **Move, rename or delete files inside Godot's FileSystem dock**, not in your file manager, so Godot updates `res://` references for you.
- **Avoid editing the same `.tscn` scene on two branches at once.** Scene files are text, but merge conflicts in them are hard to resolve. Coordinate or merge one branch first.
- Keep original third-party asset packs unmodified in `assets/`, along with their README or license files.

## Assets and licenses

Only add art, audio and fonts that you made or that you have permission to use. Put the source and license terms (a README or license file) next to the asset, and respect the pack's terms, including any credit requirements.

## Before you open a pull request

- [ ] The project opens with no errors in the Output or Debugger panels.
- [ ] The main scene runs and the feature works as intended (F5).
- [ ] No leftover debug prints or commented-out code.
- [ ] New scripts have their `.uid` files committed.
- [ ] No `.godot/` folder or other generated files are included.
- [ ] The pull request describes what changed and how to test it, and notes any dependency on another branch.

## Reporting bugs and suggesting features

Open a GitHub issue. For bugs, include:

- what you expected and what happened instead,
- steps to reproduce it,
- your Godot version and operating system,
- any error text from Godot's Output or Debugger panel.

For feature ideas, describe the goal first, and then any approach you have in mind.
