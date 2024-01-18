@tool
class_name LeftRightEntityMover extends Node2D

enum move_direction { left, right }
enum anchor_point { upper_left, center }

## The entity that will be moved by the LeftRightEntityMover
@export var entity: Node2D

## The width of the bounding box for the LeftRightEntityMover, as a percentage of the total
## screen width. When an entity hits the edge of the bounding box, its position is reversed.
@export var box_width_percent: float = 0

## How far downward the entity will move when it hits the boundary
@export var vertical_step: float = 0

## The speed at which the entity will move, in pixels / second
@export var speed: float = 0

## The anchor point of the entity being moved.
@export var anchor: anchor_point = anchor_point.upper_left

## The intial x direction that the entity moves
@export var initial_direction: move_direction = move_direction.left

var direction := 1 if initial_direction == move_direction.left else -1

func _get_configuration_warnings() -> PackedStringArray:
	var message = PackedStringArray()
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

	if not entity:
		message.append("You have not specified an entity to move.")

	if entity and not entity.has_method("boundary"):
		message.append("Entity must have a boundary() method that returns a Vector2 representing
		the node's bounding box")

	if entity and screen_width * box_width_percent <= entity.boundary().x:
		message.append("The boundary value must be greater than the width of the entity.")

	if box_width_percent < 0.0 or box_width_percent > 1.0:
		message.append("The box width percentage must be between 0 and 1")

	if vertical_step < 0:
		message.append("The vertical step must be greater than or equal to 0.")

	if speed < 0:
		message.append("The speed must be greater than or equal to 0.")

	return message

func _draw():
	# TODO: Only draw the object when it is selected
	if not Engine.is_editor_hint():
		return

	var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

	var box_start = Vector2(0, 0)
	var box_end = Vector2(box_width_percent * screen_width, screen_height)

	draw_rect(Rect2(box_start, box_end), Color(Color.DARK_OLIVE_GREEN, 0.4))

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return

	queue_redraw()

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	if not entity:
		# NOTE: I'm not sure how this will work if the EntityMover is the child
		# of an Enemy... What if the EntityMover's parent frees itself?
		queue_free()
		return

	# NOTE: Do I want to do this on every loop?
	var screen_width = get_node("/root").content_scale_size.x

	entity.position.x += direction * speed * delta

	if anchor == anchor_point.upper_left:

		var local_pos = to_local(entity.global_position)

		if local_pos.x < 0:
			direction *= -1
			entity.position.y += vertical_step
		elif local_pos.x + entity.boundary().x > box_width_percent * screen_width:
			direction *= -1
			entity.position.y += vertical_step
	else:
		# TODO: handle anchor point == center.
		pass

