class_name EnemyGrid extends Node2D

@export var num_cols: int = 1
@export var num_rows: int = 1
@export var enemy: PackedScene

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

static func row_idx(enemy_idx: int, num_cols: int) -> int:
	assert(num_cols > 0, "num_cols must be positive")
	assert(enemy_idx >= 0, "enemy_idx must be non-negative")
	return enemy_idx / num_cols
