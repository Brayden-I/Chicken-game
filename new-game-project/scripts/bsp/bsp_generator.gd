@tool
class_name BSPGenerator extends Node2D

signal new_split_made(area: Array[Rect2])
signal generation_finished(dungeon: BSPDungeonInfo)

@export_group("Dungeon")
## Total area to subdivide, in pixels.
@export var dungeon_size: Vector2 = Vector2(1152, 648)
## Smallest allowed room. Clamped to at least 1 so splitting always ends.
@export var minimum_room_size: Vector2 = Vector2(100, 100):
	set(value):
		minimum_room_size = value.max(Vector2.ONE)

@export_group("Randomness")
## When on, every run picks a new seed and writes it to Rng Seed so you can reuse it.
@export var use_random_seed: bool = true
@export var rng_seed: int = 0

@export_group("Run")
@export var generate_on_ready: bool = false
## Button in the Inspector (Godot 4.4+) that generates inside the editor.
@export_tool_button("Generate") var generate_button: Callable = generate

@export_group("Split shape")
## Splits the longer side when it is this many times longer than the other side.
## 1.0 = always cut the longer side; higher = more random.
@export_range(1.0, 3.0, 0.05) var aspect_bias: float = 1.25
## How far from an edge a cut may land, as a fraction of that side.
## 0.5 = always the exact middle; lower = more varied.
@export_range(0.1, 0.5, 0.01) var min_split_fraction: float = 0.35

var dungeon_info: BSPDungeonInfo
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	if generate_on_ready and not Engine.is_editor_hint():
		generate()

func generate() -> BSPDungeonInfo:
	return generate_rooms(dungeon_size)

func generate_rooms(size: Vector2) -> BSPDungeonInfo:
	if use_random_seed:
		_rng.randomize()
		rng_seed = _rng.seed
	else:
		_rng.seed = rng_seed

	var result := BSPDungeonInfo.new()
	result.root = BSPRoomNode.new(Rect2(Vector2.ZERO, size))

	var area_queue: Array[BSPRoomNode] = [result.root]
	while !area_queue.is_empty():
		var current: BSPRoomNode = area_queue.pop_front()
		var split_rooms: Array[Rect2] = split(current.room_info)
		for sub_area in split_rooms:
			var node := BSPRoomNode.new(sub_area)
			current.sub_division.push_back(node)
			area_queue.push_back(node)
		new_split_made.emit(split_rooms)

	dungeon_info = result
	generation_finished.emit(result)
	return result

func split(area: Rect2) -> Array[Rect2]:
	var can_split_x: bool = area.size.x >= 2 * minimum_room_size.x
	var can_split_y: bool = area.size.y >= 2 * minimum_room_size.y
	if not can_split_x and not can_split_y:
		return []

	# Pick the axis: favor cutting the longer side, random only when roughly square.
	var split_x: bool
	if not can_split_y:
		split_x = true
	elif not can_split_x:
		split_x = false
	elif area.size.x > area.size.y * aspect_bias:
		split_x = true
	elif area.size.y > area.size.x * aspect_bias:
		split_x = false
	else:
		split_x = _rng.randi_range(0, 1) == 0

	var result: Array[Rect2] = []
	if split_x:
		var x: int = _pick_cut(area.size.x, minimum_room_size.x)
		result.push_back(Rect2(area.position, Vector2(x, area.size.y)))
		result.push_back(Rect2(area.position + Vector2(x, 0), Vector2(area.size.x - x, area.size.y)))
	else:
		var y: int = _pick_cut(area.size.y, minimum_room_size.y)
		result.push_back(Rect2(area.position, Vector2(area.size.x, y)))
		result.push_back(Rect2(area.position + Vector2(0, y), Vector2(area.size.x, area.size.y - y)))
	return result

## Random cut position along a side, kept at least the minimum size and
## min_split_fraction away from both edges.
func _pick_cut(length: float, min_length: float) -> int:
	var low: int = ceili(maxf(min_length, length * min_split_fraction))
	var high: int = maxi(low, floori(length - maxf(min_length, length * min_split_fraction)))
	return _rng.randi_range(low, high)
