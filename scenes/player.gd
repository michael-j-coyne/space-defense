@tool

class_name Player extends Node2D

const SIZE = Vector2(60, 60)

@export var speed: float
var has_gatling_gun = false
var gat_in_recovery_mode := false

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	# I should probably be setting this elsewhere, but...
	PlayerVariables.gun_heat = 0

	scale = SIZE / $Sprite2D.get_rect().size
	speed = PlayerVariables.speed
	has_gatling_gun = PlayerVariables.has_gatling_gun
	$GunComponent.cooldown = PlayerVariables.gun_cooldown
	$GunComponent.penetrations = PlayerVariables.gun_penetrations

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

	handle_shooting(delta)
	handle_movement(delta)

func handle_movement(delta):
	var velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1


	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta

	var screen_width = get_node("/root").content_scale_size.x

	# prevent player from leaving viewport
	if position.x - 0.5 * SIZE.x < 0:
		position.x = 0 + 0.5 * SIZE.x
	elif position.x + 0.5 * SIZE.x > screen_width:
		position.x = screen_width - 0.5 * SIZE.x

func handle_shooting(delta):
	# Gatling gun logic goes here until it becomes a problem.
	# Perhaps later I will create a gatling gun class which is a child of GunComponent
	# or something.
	var direction = Vector2(0, -1).normalized()
	var GAT_MULTIPLIER = 0.2
	var HEAT_GAIN_AMOUNT = 1
	var COOLOFF_RATE = 1.5
	var RECOVERY_TIME = 3.0

	if not has_gatling_gun:
		if Input.is_action_pressed("shoot"):
			$GunComponent.shoot(direction)
		return

	if gat_in_recovery_mode:
		$GunComponent.cooldown = PlayerVariables.gun_cooldown
		if Input.is_action_pressed("shoot"):
			$GunComponent.shoot(direction)
		elif Input.is_action_pressed("shoot_gatling_gun"):
			$GunComponent.shoot(direction)
		return

	var overheated = PlayerVariables.gun_heat > PlayerVariables.max_heat
	if overheated:
		gat_in_recovery_mode = true
		# Prevents us from getting stuck in overheated
		PlayerVariables.gun_heat = PlayerVariables.max_heat
		get_tree().create_timer(RECOVERY_TIME).timeout.connect(
			func(): gat_in_recovery_mode = false
		)
		return

	if Input.is_action_pressed("shoot_gatling_gun"):
		$GunComponent.cooldown = PlayerVariables.gun_cooldown * GAT_MULTIPLIER

		var proj = $GunComponent.shoot(direction)
		if proj: PlayerVariables.gun_heat += HEAT_GAIN_AMOUNT
	else:
		$GunComponent.cooldown = PlayerVariables.gun_cooldown
		PlayerVariables.gun_heat -= COOLOFF_RATE * delta
		if PlayerVariables.gun_heat < 0: PlayerVariables.gun_heat = 0

		if Input.is_action_pressed("shoot"):
			$GunComponent.shoot(direction)

func get_current_health():
	return $HealthComponent.health
