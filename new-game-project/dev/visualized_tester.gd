extends Node2D

@onready var bsp_generator: BSPGenerator = $BSPGenerator
@onready var dungeon_draw_timer: Timer = $DungeonDrawTimer

## A room counts as a square when its long side is at most this many times its short side.
const SQUARE_RATIO := 1.25
const LABEL_FONT_SIZE := 16

var dungeon_info: BSPDungeonInfo
# Each entry is an Array[Rect2] (one split) and an Array[BSPRoomNode.RoomType] (one split). GDScript can't nest typed arrays, so this stays untyped.
var draw_queue: Array = []
# Everything revealed so far; _draw() clears the canvas every redraw, so we redraw it all each time.
var drawn_rects: Array[Rect2] = []
var drawn_colors: Array[Color] = []
var drawn_labels: Array[String] = []

# Rect2 -> BSPRoomNode lookup, built once after generation.
var _room_lookup: Dictionary = {}

func _ready() -> void:
	# Connect the ready signal to a custom function
	call_deferred("_generate_dungeon")

func _generate_dungeon() -> void:
	dungeon_info = bsp_generator.generate_rooms(get_viewport_rect().size)
	_build_room_lookup(dungeon_info.root)

func _draw() -> void:
	var font := ThemeDB.fallback_font
	for i in drawn_rects.size():
		var rect := drawn_rects[i]
		# Drawn in order, so a child room covers its parent's rectangle and label.
		draw_rect(rect, drawn_colors[i])

		var text_color := Color.BLACK if drawn_colors[i].get_luminance() > 0.5 else Color.WHITE
		# draw_string places text by its baseline, so offset to center it vertically.
		var baseline_y := rect.position.y + rect.size.y / 2.0 \
				+ (font.get_ascent(LABEL_FONT_SIZE) - font.get_descent(LABEL_FONT_SIZE)) / 2.0

		draw_string(font, Vector2(rect.position.x, baseline_y), drawn_labels[i],
				HORIZONTAL_ALIGNMENT_CENTER, rect.size.x, LABEL_FONT_SIZE, text_color)

func _on_bsp_generator_new_split_made(area: Array[Rect2]) -> void:
	# Leaves that couldn't be split emit an empty array; skip them so timer ticks aren't wasted.
	if not area.is_empty():
		var room_types: Array[BSPRoomNode.RoomType] = []
		for room in area:
			# O(1) dict lookup instead of recursive tree walk.
			var node: BSPRoomNode = _room_lookup.get(room, null)
			if node:
				room_types.append(node.type)
			else:
				print("Warning: No node found for room", room)
		draw_queue.push_back({"rects": area, "types": room_types})
		print("Added batch with", area.size(), "rects and", room_types.size(), "room_types")

func _on_dungeon_draw_timer_timeout() -> void:
	if draw_queue.is_empty():
		dungeon_draw_timer.stop()
		return

	var batch: Dictionary = draw_queue.pop_front()
	var rects: Array[Rect2] = batch["rects"]
	var room_types: Array[BSPRoomNode.RoomType] = batch["types"]

	if rects.is_empty() or room_types.is_empty() or rects.size() != room_types.size():
		print("Error: rects or room_types is empty or mismatched sizes")
		return

	for i in rects.size():
		var rect := rects[i]
		var room_type := room_types[i]
		var long_side := maxf(rect.size.x, rect.size.y)
		var short_side := minf(rect.size.x, rect.size.y)
		var is_square := long_side <= short_side * SQUARE_RATIO

		drawn_rects.push_back(rect)
		drawn_labels.push_back(("SQUARE" if is_square else "RECT") + " - " + BSPRoomNode.RoomType.find_key(room_type))

		# Warm = squarish, cool = elongated.
		var hue := randf_range(0.0, 0.15) if is_square else randf_range(0.5, 0.7)
		drawn_colors.push_back(Color.from_hsv(hue, 0.6, 0.9))
	queue_redraw()

# Build a flat Rect2 -> BSPRoomNode map by walking the tree once.
func _build_room_lookup(node: BSPRoomNode) -> void:
	_room_lookup[node.room_info] = node
	for child in node.sub_division:
		_build_room_lookup(child)   