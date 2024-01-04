class_name EnemyGrid extends Node2D

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

@onready var SCREEN_SIZE = get_tree().root.content_scale_size
var velocity = Vector2(-100, 0)

func _create_enemy_grid() -> void:
	for row_idx in range(NUM_ENEMIES.y):
		for col_idx in range(NUM_ENEMIES.x):
			var enemy = enemy_scene.instantiate()
			enemy.set_position(EnemyGrid._enemy_position(row_idx, col_idx))
			add_child(enemy)

static func _enemy_position(row_idx: int, col_idx: int) -> Vector2:
	var pos_x = 0.5 * ENEMY_SIZE.x + col_idx * (ENEMY_SIZE.x + GAP_SIZE.x)
	var pos_y = 0.5 * ENEMY_SIZE.y + row_idx * (ENEMY_SIZE.y + GAP_SIZE.y)

	return Vector2(pos_x, pos_y)

func spawn_enemies() -> void:
	_create_enemy_grid()

func _physics_process(delta: float) -> void:
	if position.x < 0:
		velocity.x *= -1
		position.x = 0
		position.y += ENEMY_SIZE.y
	elif position.x + ENEMY_GROUP_SIZE.x > SCREEN_SIZE.x:
		velocity.x *= -1
		position.x = SCREEN_SIZE.x - ENEMY_GROUP_SIZE.x
		position.y += ENEMY_SIZE.y

	position += velocity * delta
