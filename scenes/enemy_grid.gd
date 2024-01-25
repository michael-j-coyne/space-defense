@tool
class_name EnemyGrid extends Node2D

enum move_direction { left, right }

@export var num_cols: int = 1
@export var num_rows: int = 1
@export var gap_size: Vector2 = Vector2(0, 0)
@export var clone_first_child: bool = false

## The width of the bounding box for the LeftRightEntityMover, as a percentage of the total
## screen width. When an entity hits the edge of the bounding box, its position is reversed.
@export var box_width_percent: float = 0

@export var enemy_start_pos: float = 0.0

## How far downward the entity will move when it hits the boundary
@export var vertical_step: float = 0

## The speed at which the entity will move, in pixels / second
@export var speed: float = 0

## The intial x direction that the entity moves
@export var initial_direction: move_direction = move_direction.left

var direction := 1 if initial_direction == move_direction.left else -1

var enemy_grid_pos: float

# COUPLING: requires that children implement boundary()

# NOTE: this actually isn't an enemy grid, its a grid that can position any element
# that implements the "boundary" method. Can I add a warning to check if
# children implement this method?

func _get_configuration_warnings() -> PackedStringArray:
	var message = PackedStringArray()

	var children_implement_boundary = true

	for child in get_children():
		if not child.has_method("boundary"):
			children_implement_boundary = false

	if not children_implement_boundary:
		message.append(
			"Children of this node must implement the 'boundary' method and have @tool enabled")
	if get_child_count() == 0:
		message.append("You should add enemies to the grid")
	elif get_child_count() != num_cols * num_rows:
		# TODO: This warning seems a bit buggy. Figure out a fix.
		message.append("The number of children must equal num_cols * num_rows")

	return message

func _ready() -> void:
	set_enemy_initial_positions()
	enemy_grid_pos = enemy_start_pos

# NOTE: I'm not sure this method should actually be exposed, but encapsulating it within another node
# like "position_calculator" doesn't seem right. I suppose I could create a "library"
# but why not just let the "library" functions for the EnemyGrid exist within this class?
static func enemy_position(row_idx: int, col_idx: int, enemy_size: Vector2, gap_size: Vector2) -> Vector2:
	assert(row_idx >= 0 and col_idx >= 0, "row_idx and col_idx must be positive")
	assert(enemy_size.x > 0 and enemy_size.y > 0, "enemy_size must be positive")
	assert(gap_size.x >= 0 and gap_size.y >= 0, "gap_size must be non-negative")

	var pos_x = 0.5 * enemy_size.x + col_idx * (enemy_size.x + gap_size.x)
	var pos_y = 0.5 * enemy_size.y + row_idx * (enemy_size.y + gap_size.y)

	return Vector2(pos_x, pos_y)

# TODO: problem: we could return a value greater than the number of allowed rows
static func row_idx(enemy_idx: int, num_cols: int) -> int:
	assert(num_cols > 0, "num_cols must be positive")
	assert(enemy_idx >= 0, "enemy_idx must be non-negative")
	return enemy_idx / num_cols

static func col_idx(enemy_idx: int, num_cols: int) -> int:
	assert(num_cols > 0, "num_cols must be positive")
	assert(enemy_idx >= 0, "enemy_idx must be non-negative")
	return enemy_idx % num_cols

# This works for positoning the enemies initially but after some enemies are killed their
# index will change. So we can't re-position the enemies using this method.
func set_enemy_initial_positions():
	var enemies = get_children()
	for idx in get_child_count():
		var enemy = enemies[idx]
		var row_idx = EnemyGrid.row_idx(idx, num_cols)
		var col_idx = EnemyGrid.col_idx(idx, num_cols)
		var pos = EnemyGrid.enemy_position(row_idx, col_idx, enemy.boundary(), gap_size)
		enemy.position = pos
		enemy.position.x += enemy_start_pos

static func calculate_grid_size(total_num_rows: int, total_num_cols: int, enemy_size: Vector2, gap_size: Vector2) -> Vector2:
	assert(total_num_rows > 0, "num_rows must be positive")
	assert(total_num_cols > 0, "num_cols must be positive")
	assert(enemy_size.x > 0 and enemy_size.y > 0, "enemy_size must be positive")
	assert(gap_size.x >= 0 and gap_size.y >= 0, "gap_size must be non-negative")

	var grid_width = total_num_cols * enemy_size.x + (total_num_cols - 1) * gap_size.x
	var grid_height = total_num_rows * enemy_size.y + (total_num_rows - 1) * gap_size.y
	return Vector2(grid_width, grid_height)

# TODO: think about this more, do I really want to call get_child(0).boundary()?
# How can I figure out how big the enemies in the grid are?
# Should the grid actually resize them?
func boundary() -> Vector2:
	if get_child_count() < 1:
		return Vector2(0, 0)

	var child_boundary = get_child(0).boundary()
	return EnemyGrid.calculate_grid_size(num_rows, num_cols, child_boundary, gap_size)

func create_afterimage() -> void:
	for enemy in get_children():
		enemy.create_afterimage()

func fill_grid():
	var enemy = get_child(0)
	var new_enemy = enemy.duplicate(DUPLICATE_SCRIPTS)
	add_child(new_enemy)
	new_enemy.set_owner(enemy.get_owner())

func _draw():
	# TODO: Only draw the object when it is selected
	if not Engine.is_editor_hint():
		return

	var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	var screen_width = ProjectSettings.get_setting("display/window/size/viewport_width")

	var box_start = Vector2(0, 0)
	var box_end = Vector2(box_width_percent * screen_width, screen_height)

	draw_rect(Rect2(box_start, box_end), Color(Color.DARK_OLIVE_GREEN, 0.4))

func _process(_delta):
	if Engine.is_editor_hint():
		if clone_first_child and get_child_count() > 0 and get_child_count() < num_rows * num_cols:
			fill_grid()

		# remove children from grid
		if get_child_count() > num_rows * num_cols and get_child_count() > 1:
			remove_child(get_children()[-1])

		set_enemy_initial_positions()
		queue_redraw()
		return

	if OS.is_debug_build() and Input.is_action_just_pressed("ui_text_backspace"):
		for enemy in get_children():
			enemy.queue_free()

	# NOTE: this works for now but I don't know if its good practice. Also, I don't know if
	# its guaranteed that the EnemyGrid will free itself before something tries to call
	# boundary()
	if get_child_count() < 1:
		queue_free()
#
func move_enemies(amount: float):
	for enemy in get_children():
		enemy.position.x += amount

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return

	# NOTE: Do I want to do this on every loop?
	var screen_width = get_node("/root").content_scale_size.x

	var move_amount = direction * speed * delta
	move_enemies(move_amount)
	enemy_grid_pos += move_amount


	if enemy_grid_pos < 0:
		direction *= -1
		create_afterimage()
		position.y += vertical_step
	elif enemy_grid_pos + boundary().x > box_width_percent * screen_width:
		direction *= -1
		create_afterimage()
		position.y += vertical_step
