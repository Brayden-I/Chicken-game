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
	# Case 1: area does not meet minimum requirements
	if area.size.x < 2 * minimum_room_size.x || area.size.y < 2 * minimum_room_size.y:
		# the area cannot be split
		return []
	
	var result: Array[Rect2] = []
	var is_split_vertical: bool = randi_range(0,1) == 0
	if is_split_vertical:
		var split_x_position: int = randi_range(minimum_room_size.x, area.size.x - minimum_room_size.x)
		result.push_back(Rect2(area.position, Vector2(split_x_position, area.size.y)))
		result.push_back(Rect2(area.position + Vector2(split_x_position, 0), Vector2(split_x_position - split_x_position, area.size.y)))
	else:
		var split_y_position: int = randi_range(minimum_room_size.y, area.size.y - minimum_room_size.y)
		result.push_back(Rect2(area.position, Vector2(area.size.y, split_y_position)))
		result.push_back(Rect2(area.position + Vector2(0, split_y_position), Vector2(area.size.y, split_y_position - split_y_position)))
	return result
