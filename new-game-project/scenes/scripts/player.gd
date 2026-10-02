extends CharacterBody2D

signal died

@onready var sprite: AnimatedSprite2D = $sprite
@onready var player_hitbox: Area2D = $player_hitbox

@export var movement_speed := 80.0  # pixels per second
@export var max_health := 100
@export var attack_damage := 25
@export var attack_cooldown := 0.4  # seconds between swings

var character_direction : Vector2

var health := 100
var alive := true
var can_attack := true

var _flash_tween: Tween

func _ready() -> void:
	health = max_health
	_ensure_attack_action()

# Adds an "attack" input (left click / J) if you haven't made one in the Input Map yet.
# Once you add your own "attack" action in Project Settings, this does nothing.
func _ensure_attack_action() -> void:
	if InputMap.has_action("attack"):
		return
	InputMap.add_action("attack")
	var click := InputEventMouseButton.new()
	click.button_index = MOUSE_BUTTON_LEFT
	InputMap.action_add_event("attack", click)
	var key := InputEventKey.new()
	key.physical_keycode = KEY_J
	InputMap.action_add_event("attack", key)

func _physics_process(_delta: float):
	if not alive:
		return

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

	if Input.is_action_just_pressed("attack") and can_attack:
		attack()

func attack() -> void:
	can_attack = false

	# Hit every enemy currently inside the player_hitbox circle
	for body in player_hitbox.get_overlapping_bodies():
		if body.is_in_group("enemy") and body.has_method("take_damage"):
			body.take_damage(attack_damage, global_position)

	# Quick "punch" so the swing is visible (there's no attack animation yet)
	sprite.scale = Vector2(1.35, 1.35)
	create_tween().tween_property(sprite, "scale", Vector2.ONE, 0.15)

	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func take_damage(damage: int) -> void:
	if not alive:
		return
	health -= damage
	print("Player took ", damage, " damage, health: ", health)
	_flash_red()
	if health <= 0:
		die()

func _flash_red() -> void:
	if _flash_tween:
		_flash_tween.kill()
	sprite.modulate = Color(1, 0.3, 0.3)
	_flash_tween = create_tween()
	_flash_tween.tween_property(sprite, "modulate", Color.WHITE, 0.15)

func die() -> void:
	alive = false
	velocity = Vector2.ZERO
	died.emit()
	$collision.set_deferred("disabled", true)

	if _flash_tween:
		_flash_tween.kill()
	var t := create_tween().set_parallel(true)
	t.tween_property(sprite, "rotation", PI / 2.0, 0.4)
	t.tween_property(sprite, "modulate", Color(1, 0.3, 0.3, 0.0), 1.0)
	await t.finished

	await get_tree().create_timer(0.5).timeout
	get_tree().reload_current_scene()  # restart; swap for a game over screen later

# These are still connected to player_hitbox in Player.tscn, so they stay
# (harmless). You can delete them and the connections later.
func _on_player_hitbox_body_entered(_body: Node2D) -> void:
	pass

func _on_player_hitbox_body_exited(_body: Node2D) -> void:
	pass