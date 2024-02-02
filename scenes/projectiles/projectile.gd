@tool
class_name Projectile extends Node2D

var attack: Attack
var speed: float
var direction: Vector2
var penetrations: int
@export var hitbox: AttackHitboxComponent
@export var time_alive: float = 2.0

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()

	if not hitbox:
		warnings.push_back("Projectile has no hitbox")

	return warnings

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	# these variables must be set by the Gun
	assert(attack != null)
	assert(speed != null)
	assert(direction != null)
	assert(penetrations != null)

	get_tree().create_timer(time_alive).connect("timeout", func(): queue_free())

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	assert(
		direction == Vector2(0, 0) or direction.is_normalized(),
		"direction must be a normalized vector or the vector (0, 0)")

	# assert doesn't work in production build, so lets just normalize it and hope everything
	# works out
	direction = direction.normalized()

	var velocity = direction * speed
	position += velocity * delta

	var translation_amount = Vector2(0, get_size().y / 2)

	# If projectile leaves top of screen, despawn it
	if global_position.y - translation_amount.y < 0:
		queue_free()

func _on_attack_landed():
	penetrations -= 1

	if penetrations < 1:
		hitbox.enabled = false
		queue_free()

func get_size():
	return $Sprite2D.get_rect().size * scale
