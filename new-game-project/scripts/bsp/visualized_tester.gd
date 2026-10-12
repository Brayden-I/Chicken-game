extends Node2D

@onready var bsp_generator: BSPGenerator = $BSPGenerator

var dungeon_info: BSPDungeonInfo

func _ready() -> void:
	var dungeon_info = bsp_generator.generate_rooms(DisplayServer.window_get_size())
	
	
func _draw() -> void:
	if !dungeon_info:
		return


func _on_bsp_generator_new_split_made(area: Array[Rect2]) -> void:
	pass # Replace with function body.
