@tool
class_name Enemy extends Node2D

@export var value := 10
const SIZE: Vector2 = Vector2(60, 50)

signal reached_bottom
signal died(value: int)

func _ready():
	if Engine.is_editor_hint():
		return

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
	return $Sprite2D.get_rect().size * scale + Vector2(0, 10)

func check_reached_bottom() -> void:
	var bottom_coord = get_node("/root").content_scale_size.y - Player.SIZE.y
	if global_position.y + boundary().y * 0.5 > bottom_coord:
		reached_bottom.emit()

func create_afterimage():
	var afterimage = AfterImage.new(
		$Sprite2D.duplicate(),
		global_position,
		scale,
		0.15
	)

	if is_instance_valid(Globals.current_level):
		Globals.current_level.add_child(afterimage)
	else:
		get_node("/root").add_child(afterimage)

# Will you be able to get money from an enemy multiple times in some cases?
func die() -> void:
	PlayerVariables.money += value
	died.emit(value)
	queue_free()
