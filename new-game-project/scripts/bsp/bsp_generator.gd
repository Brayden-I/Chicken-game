extends Node2D

@export var minimum_room_size: Vector2
@export var maximum_room_size: Vector2

func generate_rooms(size: Vector2) -> BSPDungeonInfo: # TODO: Add a resource script
	pass

## Given an area of a dungeon split into 2 parts using a minimum and a maximum
func split(area: Rect2) -> Array[Rect2]:
	return [Rect2(Vector2(0,0), Vector2(10,10))]
