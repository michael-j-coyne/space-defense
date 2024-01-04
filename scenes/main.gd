class_name Main extends Node

const enemy_scene = preload("res://scenes/Enemy.tscn")

# TODO: this is not actually connected to the enemy itself,
# so the enemy could change size and this would be wrong.
# I need a **single point of control** for the enemy size.
const ENEMY_SIZE = Vector2(100, 100)
const ENEMY_GROUP_SIZE = Vector2(1200, 600)
const NUM_ENEMIES = Vector2i(10, 5)
const NUM_GAPS = Vector2i(NUM_ENEMIES.x - 1, NUM_ENEMIES.y - 1)
const GAP_SIZE = Vector2(
	(ENEMY_GROUP_SIZE.x - NUM_ENEMIES.x * ENEMY_SIZE.x) / NUM_GAPS.x,
	(ENEMY_GROUP_SIZE.y - NUM_ENEMIES.y * ENEMY_SIZE.y) / NUM_GAPS.y)

var enemies: Array[Enemy] = []

func create_enemy_grid() -> void:
	for row_idx in range(NUM_ENEMIES.y):
		for col_idx in range(NUM_ENEMIES.x):
			var enemy = enemy_scene.instantiate()
			enemy.set_position(Main.enemy_position(row_idx, col_idx) + $EnemySpawn.position)
			enemies.append(enemy)
			add_child(enemy)

static func enemy_position(row_idx: int, col_idx: int) -> Vector2:
	var pos_x = 0.5 * ENEMY_SIZE.x + col_idx * (ENEMY_SIZE.x + GAP_SIZE.x)
	var pos_y = 0.5 * ENEMY_SIZE.y + row_idx * (ENEMY_SIZE.y + GAP_SIZE.y)

	return Vector2(pos_x, pos_y)

func _ready() -> void:
	create_enemy_grid()
