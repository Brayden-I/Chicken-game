extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $sprite

@export var movement_speed := 80.0  # pixels per second
var character_direction : Vector2

var entity_inrange = false
var attack_in_cooldown = true

var health = 100
var alive = true

func _physics_process(delta: float):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	
	#flip
	if character_direction.x > 0: sprite.flip_h = false
	elif character_direction.x < 0: sprite.flip_h = true
	
	# If the player is moving
	if character_direction:
		velocity = character_direction * movement_speed
		sprite.play("walk")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, movement_speed)
		sprite.play("idle")
		
	move_and_slide()


func _on_player_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		entity_inrange = true

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		entity_inrange = false

func take_damage(damage):
	if entity_inrange:
		health = health - damage
		print("Player took ", damage, " damage")