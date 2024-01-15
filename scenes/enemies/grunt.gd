@tool
class_name Grunt extends Enemy

# NOTE: This is temporary code, it willl all be tossed later / moved into different
# places

@export var shot_chance_percentage: float
@export var shot_interval_seconds: float
var rng = RandomNumberGenerator.new()

signal reached_bottom

func _ready():
	if Engine.is_editor_hint():
		return

	var timer = Timer.new()
	timer.wait_time = shot_interval_seconds
	timer.connect("timeout",
		func():
			if rng.randf() <= shot_chance_percentage:
				$GunComponent.shoot(Vector2(0, 1))
	)
	add_child(timer)
	timer.start()

	add_to_group("enemies")

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	check_reached_bottom()

# UNTESTED.
# returns the abstract "bounding box" for the node, it is the space that the
# node occupies on the screen.
# as of now this is really just for the EnemyGrid to use.
func boundary():
	# NOTE: this implementation is likely to change especially if we use animated sprites.
	return $Sprite2D.get_rect().size * scale

func check_reached_bottom() -> void:
	var bottom_coord = get_node("/root").content_scale_size.y - Player.SIZE.y
	if global_position.y + boundary().y * 0.5 >= bottom_coord:
		reached_bottom.emit()
