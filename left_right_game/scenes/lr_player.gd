class_name LRPlayer extends Node2D

@export var speed: float

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_just_released("ui_accept"):
		# TODO: fix hardcoded Vector2 (which is velocity of projectile)... and figure out how I want to handle this
		$GunComponent.shoot(Vector2(0, 1))

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta

func die():
	queue_free()
