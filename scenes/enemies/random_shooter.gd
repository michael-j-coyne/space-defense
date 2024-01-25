@tool
class_name RandomShooter extends Enemy

# NOTE: This is temporary code, it willl all be tossed later / moved into different
# places

@export var shot_chance_percentage: float
@export var shot_interval_seconds: float
var rng = RandomNumberGenerator.new()


func _ready():
	if Engine.is_editor_hint():
		return

	super()

	var timer = Timer.new()
	timer.wait_time = shot_interval_seconds
	timer.connect("timeout",
		func():
			if rng.randf() <= shot_chance_percentage:
				$GunComponent.shoot(Vector2(0, 1))
	)
	add_child(timer)
	timer.start()