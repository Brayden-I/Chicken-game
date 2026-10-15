class_name EnemySpawner extends Node2D

signal enemy_died(enemy: Enemy)

## Where enemies are added. Leave empty to use this node's parent (the level).
@export var enemy_container: Node
@export var max_alive: int = 8
@export var spawn_interval: float = 3.0
@export var min_distance_from_player: float = 150.0

var _alive_count: int = 0
var _timer := Timer.new()

func _ready() -> void:
	_timer.wait_time = spawn_interval
	_timer.timeout.connect(_spawn_one)
	add_child(_timer)
	_timer.start()

func _spawn_one() -> void:
	if _alive_count >= max_alive:
		return
	var player := get_tree().get_first_node_in_group("player") as Node2D
	var points: Array = get_children().filter(
			func(child: Node) -> bool:
				return child is SpawnPoint and (player == null or child.global_position.distance_to(player.global_position) >= min_distance_from_player)
	)
	if points.is_empty():
		return
	var point: SpawnPoint = points.pick_random()
	var enemy := point.spawn(enemy_container if enemy_container else get_parent())
	if enemy == null:
		return
	_alive_count += 1
	enemy.died.connect(_on_enemy_died.bind(enemy), CONNECT_ONE_SHOT)

func _on_enemy_died(enemy: Enemy) -> void:
	_alive_count -= 1
	enemy_died.emit(enemy)