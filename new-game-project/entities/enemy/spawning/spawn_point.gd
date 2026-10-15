class_name SpawnPoint extends Marker2D

signal enemy_spawned(enemy: Enemy)

@export var enemy_scene: PackedScene
## One is picked at random. Leave empty to use the scene's own stats.
@export var possible_types: Array[EnemyData]
@export var spawn_on_ready: bool = false

func _ready() -> void:
	add_to_group("spawn_point")
	if spawn_on_ready:
		spawn.call_deferred()  # the parent is still setting up its children here

func spawn(container: Node = null) -> Enemy:
	if enemy_scene == null:
		push_warning("%s has no enemy_scene set." % name)
		return null
	var enemy := enemy_scene.instantiate() as Enemy
	if not possible_types.is_empty():
		enemy.data = possible_types.pick_random()
	var parent: Node = container if container else get_tree().current_scene
	parent.add_child(enemy)
	enemy.global_position = global_position  # set after add_child so the container's offset is handled
	enemy_spawned.emit(enemy)
	return enemy