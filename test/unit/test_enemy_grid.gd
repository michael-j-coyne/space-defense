extends GutTest

class TestEnemyPosition:
	extends GutTest

	func test_start():
		var result = EnemyGrid._enemy_position(0, 0)
		assert_eq(Vector2(EnemyGrid.ENEMY_SIZE.x, EnemyGrid.ENEMY_SIZE.y) * Vector2(0.5, 0.5), result)

	func test_end():
		var result = EnemyGrid._enemy_position(EnemyGrid.NUM_ENEMIES.y - 1, EnemyGrid.NUM_ENEMIES.x - 1)
		assert_eq(
			Vector2(
				EnemyGrid.ENEMY_GROUP_SIZE.x - (0.5 * EnemyGrid.ENEMY_SIZE.x),
				EnemyGrid.ENEMY_GROUP_SIZE.y - (0.5 * EnemyGrid.ENEMY_SIZE.y)),
			result)

	func test_middle():
		if EnemyGrid.NUM_ENEMIES.x < 1 or EnemyGrid.NUM_ENEMIES.y < 1:
			return

		var result = EnemyGrid._enemy_position(1, 1)
		assert_eq(
			Vector2(
				EnemyGrid.ENEMY_SIZE.x + (0.5 * EnemyGrid.ENEMY_SIZE.x) + EnemyGrid.GAP_SIZE.x,
				EnemyGrid.ENEMY_SIZE.y + (0.5 * EnemyGrid.ENEMY_SIZE.y) + EnemyGrid.GAP_SIZE.y),
			result)
