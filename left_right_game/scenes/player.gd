class_name Player extends Node2D

@export var speed: float

func _physics_process(delta: float) -> void:
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_just_released("ui_accept"):
		# Note: in the future we may want to be able to shoot in a particular direction
		var direction = Vector2(0, -1).normalized()
		$GunComponent.shoot(direction)

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
