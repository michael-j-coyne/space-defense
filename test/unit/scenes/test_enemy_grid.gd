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

func test_row_idx_boundary():
	const enemy_idx = 3
	const num_cols = 4
	var result = EnemyGrid.row_idx(enemy_idx, num_cols)
	assert_eq(result, 0)

func test_row_idx_just_above_boundary():
	const enemy_idx = 4
	const num_cols = 4
	var result = EnemyGrid.row_idx(enemy_idx, num_cols)
	assert_eq(result, 1)

func test_row_idx_just_below_boundary():
	const enemy_idx = 2
	const num_cols = 4
	var result = EnemyGrid.row_idx(enemy_idx, num_cols)
	assert_eq(result, 0)

func test_row_idx_zero():
	const enemy_idx = 0
	const num_cols = 4
	var result = EnemyGrid.row_idx(enemy_idx, num_cols)
	assert_eq(result, 0)

func test_col_idx_boundary():
	const enemy_idx = 3
	const num_cols = 4
	var result = EnemyGrid.col_idx(enemy_idx, num_cols)
	assert_eq(result, 3)

func test_col_idx_just_above_boundary():
	const enemy_idx = 4
	const num_cols = 4
	var result = EnemyGrid.col_idx(enemy_idx, num_cols)
	assert_eq(result, 0)

func test_col_idx_just_below_boundary():
	const enemy_idx = 2
	const num_cols = 4
	var result = EnemyGrid.col_idx(enemy_idx, num_cols)
	assert_eq(result, 2)

func test_col_idx_zero():
	const enemy_idx = 0
	const num_cols = 4
	var result = EnemyGrid.col_idx(enemy_idx, num_cols)
	assert_eq(result, 0)
