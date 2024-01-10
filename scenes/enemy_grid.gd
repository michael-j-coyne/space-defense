@tool
class_name EnemyGrid extends Node2D

@export var num_cols: int = 1
@export var num_rows: int = 1
@export var gap_size: Vector2 = Vector2(0, 0)
@export var enemy: PackedScene

# COUPLING: requires that children implement get_boundary()

# Note: this actually isn't an enemy grid, its a grid that can position any element
# that implements the "get_boundary" method. Can I add a warning to check if
# children implement this method?

func _get_configuration_warnings() -> PackedStringArray:
	if get_child_count() == 0:
		return PackedStringArray(["You should add enemies to the grid"])
	else:
		return PackedStringArray([])

# Note: I'm not sure this method should actually be exposed, but encapsulating it within another node
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
		var pos = EnemyGrid.enemy_position(row_idx, col_idx, enemy.get_boundary(), gap_size)
		enemy.position = pos

func _ready():
	set_enemy_initial_positions()

func _process(_delta):
	if Engine.is_editor_hint():
		set_enemy_initial_positions()
