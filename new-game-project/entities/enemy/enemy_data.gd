class_name EnemyData extends Resource

@export var display_name: String = "Soldier"
@export var max_health: int = 100
@export var move_speed: float = 80.0
@export var detection_radius: float = 200.0
@export var attack_damage: int = 10
## Needs "idle", "walk" and "fire" animations, because enemy.gd plays those by name.
@export var sprite_frames: SpriteFrames