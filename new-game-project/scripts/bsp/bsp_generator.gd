class_name BSPGenerator extends Node2D

@export var minimum_room_size: Vector2
@export var maximum_room_size: Vector2

# Generate subdivisions of rooms and return BSPDungeonINfo
func generate_rooms(size: Vector2) -> BSPDungeonInfo:

	var starting_area: Rect2 = Rect2(Vector2(0,0), size)
	var result: BSPDungeonInfo = BSPDungeonInfo.new()
	result.root = BSPRoomNode.new(starting_area)
	
	var area_queue: Array[BSPRoomNode] = [result.root]
	# itereate through area queues until there is no more
	while !area_queue.is_empty():
		var current_area: BSPRoomNode = area_queue.pop_front()
		
		for sub_area in split(current_area.room_info):
			var sub_room_node: BSPRoomNode = BSPRoomNode.new(sub_area)
			current_area.sub_division.push_back(sub_room_node)
			area_queue.push_back(sub_area)
	return result

## Given an area of a dungeon split into 2 parts using a minimum and a maximum
func split(area: Rect2) -> Array[Rect2]:
	return [Rect2(Vector2(0,0), Vector2(10,10))]
