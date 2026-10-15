extends CharacterBody2D

signal died

@onready var sprite: AnimatedSprite2D = $sprite
@onready var enemy_hitbox: Area2D = $enemy_hitbox

@export var movement_speed := 80.0  # pixels per second
@export var health := 100
@export var attack_damage := 10
@export var attack_cooldown := 1.0  # seconds between attacks
@export var attack_windup := 0.3    # delay before the hit lands (matches the "fire" animation)

var alive := true
var attacking := false
var attack_timer := 0.0
var knockback := Vector2.ZERO

var entity: Node2D = null

var _flash_tween: Tween

func _physics_process(delta: float) -> void:
	if not alive:
		return

	attack_timer = max(attack_timer - delta, 0.0)

	# Stop chasing once the player is dead
	if entity and entity.get("alive") == false:
		entity = null

	var in_range := _player_in_attack_range()
	if in_range and attack_timer <= 0.0 and not attacking:
		_attack()

	var moving := entity != null and not attacking and not in_range
	if moving:
		var direction := global_position.direction_to(entity.global_position)
		sprite.play("walk")
		velocity = direction * movement_speed

		#flip
		if direction.x > 0: sprite.flip_h = false
		elif direction.x < 0: sprite.flip_h = true
	else:
		velocity = Vector2.ZERO
		if not attacking:
			sprite.play("idle")

	# Knockback from being hit fades out over time
	velocity += knockback
	knockback = knockback.move_toward(Vector2.ZERO, 600.0 * delta)

	move_and_slide()

func _player_in_attack_range() -> bool:
	for body in enemy_hitbox.get_overlapping_bodies():
		if body.is_in_group("player") and body.get("alive") == true:
			return true
	return false

func _attack() -> void:
	attacking = true
	attack_timer = attack_cooldown

	if entity:
		sprite.flip_h = entity.global_position.x < global_position.x
	sprite.play("fire")

	await get_tree().create_timer(attack_windup).timeout
	if not alive:
		return

	# Only hurts the player if they're still in range when the hit lands
	for body in enemy_hitbox.get_overlapping_bodies():
		if body.is_in_group("player") and body.has_method("take_damage"):
			body.take_damage(attack_damage)

	await get_tree().create_timer(0.2).timeout
	attacking = false

func take_damage(damage: int, from_position := Vector2.INF) -> void:
	if not alive:
		return
	health -= damage
	if from_position != Vector2.INF:
		knockback = (global_position - from_position).normalized() * 220.0
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
	remove_from_group("enemy")
	$CollisionShape2D.set_deferred("disabled", true)
	enemy_hitbox.set_deferred("monitoring", false)
	died.emit()

	if _flash_tween:
		_flash_tween.kill()
	var t := create_tween()
	t.tween_property(sprite, "modulate", Color(1, 0.3, 0.3, 0.0), 0.5)
	t.tween_callback(queue_free)

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		entity = body

func _on_detection_area_body_exited(body):
	if body == entity:
		entity = null

# Kept in case you've connected enemy_hitbox signals in the editor
# (they weren't connected in the committed scene). Safe to delete otherwise.
func _on_enemy_hitbox_body_entered(_body: Node2D) -> void:
	pass

func _on_enemy_hitbox_body_exited(_body: Node2D) -> void:
	pass
