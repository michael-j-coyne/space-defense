@tool
class_name RandomShooter extends Enemy

@export var shot_chance_percentage: float
@export var shot_interval_seconds: float
@export var start_shooting_delay := 0.0
var rng = RandomNumberGenerator.new()
@onready var gun := $GunComponent as GunComponent

func _ready():
	if Engine.is_editor_hint():
		return

	super()

	var timer = Timer.new()
	timer.wait_time = shot_interval_seconds
	timer.connect("timeout",
		func():
			if rng.randf() <= shot_chance_percentage:
				gun.shoot(Vector2(0, 1))
	)
	add_child(timer)
	get_tree().create_timer(start_shooting_delay).timeout.connect(timer.start)
