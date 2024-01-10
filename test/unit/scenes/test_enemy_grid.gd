extends GutTest

func test_enemy_position_lower_boundary():
	const row_idx = 0
	const col_idx = 0
	const enemy_size = Vector2(10, 10)
	const gap_size = Vector2(3, 3)

	var enemy_position = EnemyGrid.enemy_position(row_idx, col_idx, enemy_size, gap_size)

	assert_eq(enemy_position, Vector2(enemy_size.x / 2, enemy_size.y / 2))

func test_enemy_position():
	const row_idx = 1
	const col_idx = 1
	const enemy_size = Vector2(10, 10)
	const gap_size = Vector2(3, 3)

	var enemy_position = EnemyGrid.enemy_position(row_idx, col_idx, enemy_size, gap_size)

	assert_eq(enemy_position, Vector2(18, 18))

