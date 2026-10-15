class_name SpawnPoint extends Marker2D

@export var enemy_scene: PackedScene
@export var possible_types: Array[EnemyData]  # picks one at random if more than one
@export var spawn_on_ready: bool = false

func spawn(container: Node) -> Enemy:
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.data = possible_types.pick_random()
	enemy.global_position = global_position
	container.add_child.call_deferred(enemy)
	return enemy
