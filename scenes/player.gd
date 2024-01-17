@tool

class_name Player extends Node2D

const SIZE = Vector2(60, 60)

@export var speed: float

func _ready() -> void:
	scale = SIZE / $Sprite2D.get_rect().size
	speed = PlayerVariables.speed
	$GunComponent.cooldown = PlayerVariables.gun_cooldown

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return

	var viewport_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	position.y = viewport_height - 0.5 * SIZE.y

	scale = SIZE / $Sprite2D.get_rect().size

# NOTE: if we are really being sticklers, we could extract the input handling
# into its own component.
func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	var velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_accept"):
		# NOTE: in the future we may want to be able to shoot in a particular direction
		var direction = Vector2(0, -1).normalized()
		$GunComponent.shoot(direction)

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta

	var screen_width = get_node("/root").content_scale_size.x

	# prevent player from leaving viewport
	if position.x - 0.5 * SIZE.x < 0:
		position.x = 0 + 0.5 * SIZE.x
	elif position.x + 0.5 * SIZE.x > screen_width:
		position.x = screen_width - 0.5 * SIZE.x

func get_current_health():
	return $HealthComponent.health
