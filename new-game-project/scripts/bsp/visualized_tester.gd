extends Node2D

@onready var bsp_generator: BSPGenerator = $BSPGenerator
@onready var dungeon_draw_timer: Timer = $DungeonDrawTimer

var dungeon_info: BSPDungeonInfo
# Each entry is an Array[Rect2] (one split). GDScript can't nest typed arrays, so this stays untyped.
var draw_queue: Array = []
# Everything revealed so far; _draw() clears the canvas every redraw, so we redraw it all each time.
var drawn_rects: Array[Rect2] = []
var drawn_colors: Array[Color] = []

func _ready() -> void:
	dungeon_info = bsp_generator.generate_rooms(get_viewport_rect().size)

func _draw() -> void:
	for i in drawn_rects.size():
		draw_rect(drawn_rects[i], drawn_colors[i])

func _on_bsp_generator_new_split_made(area: Array[Rect2]) -> void:
	# Leaves that couldn't be split emit an empty array; skip them so timer ticks aren't wasted.
	if not area.is_empty():
		draw_queue.push_back(area)

func _on_dungeon_draw_timer_timeout() -> void:
	if draw_queue.is_empty():
		dungeon_draw_timer.stop()
		return

	var batch: Array = draw_queue.pop_front()
	for rect: Rect2 in batch:
		drawn_rects.push_back(rect)
		drawn_colors.push_back(Color(randf(), randf(), randf()))
	queue_redraw()