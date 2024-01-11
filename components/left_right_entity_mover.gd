@tool
class_name LeftRightEntityMover extends Node2D

enum move_direction { left, right }
enum anchor_point { upper_left, center }

## The entity that will be moved by the LeftRightEntityMover
@export var entity: Node2D

## The width of the bounding box for the LeftRightEntityMover. When an entity hits the edge
## of the bounding box, its position is reversed.
@export var boundary_value: float = 0

# TODO: implement logic for this
@export var entity_starting_pos: float = 0

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

	if not entity:
		message.append("You have not specified an entity to move.")

	if entity and not entity.has_method("boundary"):
		message.append("Entity must have a boundary() method that returns a Vector2 representing
		the node's bounding box")

	if entity and boundary_value <= entity.boundary().x:
		message.append("The boundary value must be greater than the width of the entity.")

	if vertical_step < 0:
		message.append("The vertical step must be greater than or equal to 0.")

	if speed < 0:
		message.append("The speed must be greater than or equal to 0.")

	return message

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	entity.position.x += direction * speed * delta

	if anchor == anchor_point.upper_left:

		# TODO: Extract into a function and test it.
		# Also, boundary() ends up being called with no children once all the enemies in the grid are dead.
		if entity.position.x < 0:
			direction *= -1
			entity.position.y += vertical_step
		elif entity.position.x + entity.boundary().x > boundary_value:
			direction *= -1
			entity.position.y += vertical_step
	else:
		# TODO: handle anchor point == center.
		pass

