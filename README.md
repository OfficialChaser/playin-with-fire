# Major Jam 7

A Godot 4.6 game project built in the `MajorJam7` workspace.

## Overview

This repository contains a Godot game project with the main scene configured in `project.godot`. The game uses autoloaded manager scripts to coordinate rules, input, game state, audio, and transitions.

## Engine

- Godot Engine: 4.6
- Project file: `project.godot`
- Main scene: configured in `project.godot` via `run/main_scene`

## Running the Game

1. Open Godot.
2. Select the project folder: `c:\Users\chase\OneDrive\Documents\Godot Games\MajorJam7`
3. Run the project from the editor.

## Controls

- Move: `WASD` or arrow keys
- Spray / action: `Space` or left mouse button
- Restart: `R`
- Pause: `P` or `C`
- Gamepad support is configured via standard joystick axes and buttons

## Project Structure

- `assets/` - sprites, tiles, fonts, sound imports, and other media
- `scenes/` - Godot scenes for UI, player, fire, water, tiles, and audio
- `scripts/` - game logic and managers
- `sounds/` - sound assets and imports
- `misc/` - curves, shaders, rules, and utility resources

## Useful Files

- `project.godot` - Godot project configuration and input mappings
- `scripts/main.gd` - start logic for the main scene
- `scripts/Managers/game_manager.gd` - game state and flow control
- `assets/fire_fx_v1.0/readme.TXT` - included fire effect documentation

## Notes

- Input mappings include keyboard, mouse, and gamepad controls.
- The game is set to a viewport size of `480x360` with viewport stretching enabled.

## License

No license file is included in this repository. Add a `LICENSE` file if you want to specify usage terms.
