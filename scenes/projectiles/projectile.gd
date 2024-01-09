class_name Projectile extends Node2D

# Note: What exactly is the consequence of not setting defaults? What is the benefit?
var attack: Attack
var speed: float
var direction: Vector2
@export var time_alive: float = 2.0

func _ready() -> void:
	get_tree().create_timer(time_alive).connect("timeout", func(): queue_free())

func _physics_process(delta: float) -> void:
	# for development, the direction should always be a normalized vector
	# Note: it may be better to assert this in the "setter" for direction,
	# but I haven't decided if I want to use properties yet.
	assert(
		direction == Vector2(0, 0) or direction.is_normalized(),
		"direction must be a normalized vector or the vector (0, 0)")

	# assert doesn't work in production build, so lets just normalize it and hope everything
	# works out
	direction = direction.normalized()

	var velocity = direction * speed
	position += velocity * delta

func get_size():
	return $Sprite2D.get_rect().size * scale
