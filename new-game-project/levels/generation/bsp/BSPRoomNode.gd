class_name BSPRoomNode extends Resource

@export var room_info: Rect2
@export var sub_division: Array[BSPRoomNode]

# New enum
enum RoomType { BUILDING, PATH, ARENA, LOOT }

@export var type: RoomType = RoomType.BUILDING

func _init(_room_info: Rect2 = Rect2(), _type: RoomType = RoomType.BUILDING):
	room_info = _room_info
	type = _type
	sub_division = []