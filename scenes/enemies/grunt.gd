@tool
class_name Grunt extends Enemy

# NOTE: This is temporary code, it willl all be tossed later / moved into different
# places

@export var shot_chance_percentage: float
@export var shot_interval_seconds: float
@export var value := 10
const SIZE: Vector2 = Vector2(60, 60)
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
	scale = SIZE / $Sprite2D.get_rect().size

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return

	scale = SIZE / $Sprite2D.get_rect().size

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

	check_reached_bottom()

# returns the abstract "bounding box" for the node, it is the space that the
# node occupies on the screen.
# boundary() is used by nodes that position other nodes.
func boundary():
	# NOTE: this implementation is likely to change especially if we use animated sprites.
	return $Sprite2D.get_rect().size * scale

func check_reached_bottom() -> void:
	var bottom_coord = get_node("/root").content_scale_size.y - Player.SIZE.y
	if global_position.y + boundary().y * 0.5 >= bottom_coord:
		reached_bottom.emit()

func create_afterimage():
	var afterimage = AfterImage.new(
		$Sprite2D.duplicate(),
		global_position,
		scale,
		0.15
	)

	if Globals.current_level:
		Globals.current_level.add_child(afterimage)
	else:
		get_node("/root").add_child(afterimage)

func _on_tree_exiting() -> void:
	if Engine.is_editor_hint():
		return
	PlayerVariables.money += value
