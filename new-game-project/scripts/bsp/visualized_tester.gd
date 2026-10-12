extends Node2D

@onready var bsp_generator: BSPGenerator = $BSPGenerator
@onready var dungeon_draw_timer: Timer = $DungeonDrawTimer

var dungeon_info: BSPDungeonInfo
var draw_queue: Array[Rect2]

func _ready() -> void:
	dungeon_info = bsp_generator.generate_rooms(DisplayServer.window_get_size())
	
func _draw() -> void:
	if draw_queue.is_empty():
		return
	
	for Rect in draw_queue.pop_front() as Array[Rect2]:
		draw_rect(Rect, Color(randf(), randf(), true))

func _on_bsp_generator_new_split_made(area: Array[Rect2]) -> void:
	draw_queue.push_back(area)

func _on_dungeon_draw_timer_timeout() -> void:
	queue_redraw()
