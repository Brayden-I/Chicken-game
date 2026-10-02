extends CharacterBody2D
@onready var sprite: AnimatedSprite2D = $sprite

@export var movement_speed := 80.0  # pixels per second
@export var health = 100

var player_inrange = false

var entity: Node2D = null

func _physics_process(_delta: float) -> void:
	take_damage(20)
	
	if entity:
		var direction := global_position.direction_to(entity.global_position)
		sprite.play("walk")
		velocity = direction * movement_speed

		#flip
		if direction.x > 0: sprite.flip_h = false
		elif direction.y < 0: sprite.flip_h = true
	else:
		sprite.play("idle")
		velocity = Vector2.ZERO
		
	move_and_slide()

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		entity = body

func _on_detection_area_body_exited(body):
	if body == entity:
		entity = null


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inrange = true

func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_inrange = false

func take_damage(damage):
	if player_inrange and Global.player_on_cooldown == false:
		health = health - damage