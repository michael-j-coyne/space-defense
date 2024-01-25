class_name Projectile extends Node2D

# NOTE: What exactly is the consequence of not setting defaults? What is the benefit?
var attack: Attack
var speed: float
var direction: Vector2
var penetrations: int = 1
@export var time_alive: float = 2.0

func _ready() -> void:
	get_tree().create_timer(time_alive).connect("timeout", func(): queue_free())

func _physics_process(delta: float) -> void:
	# for development, the direction should always be a normalized vector
	# NOTE: it may be better to assert this in the "setter" for direction,
	# but I haven't decided if I want to use properties yet.
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
		queue_free()

func get_size():
	return $Sprite2D.get_rect().size * scale
