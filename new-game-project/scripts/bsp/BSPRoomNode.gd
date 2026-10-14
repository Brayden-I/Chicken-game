class_name BSPRoomNode extends Resource

@export var room_info: Rect2
@export var sub_division: Array[BSPRoomNode]

# Default argument so Godot can create this Resource without arguments (e.g. when loading/inspecting it).
func _init(_room_info: Rect2 = Rect2()):
	room_info = _room_info
	sub_division = []
