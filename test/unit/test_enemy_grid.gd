extends GutTest

class TestEnemyPosition:
	extends GutTest

	var enemy_grid

	func before_each():
		enemy_grid = EnemyGrid.new()

	func after_each():
		enemy_grid.free()

	func test_start():
		var result = EnemyGrid._enemy_position(0, 0)
		assert_eq(Vector2(EnemyGrid.ENEMY_SIZE.x, EnemyGrid.ENEMY_SIZE.y) * Vector2(0.5, 0.5), result)

	func test_end():
		var result = EnemyGrid._enemy_position(enemy_grid.NUM_ENEMIES.y - 1, enemy_grid.NUM_ENEMIES.x - 1)
		assert_eq(
			Vector2(
				enemy_grid.ENEMY_GROUP_SIZE.x - (0.5 * EnemyGrid.ENEMY_SIZE.x),
				enemy_grid.ENEMY_GROUP_SIZE.y - (0.5 * EnemyGrid.ENEMY_SIZE.y)),
			result)

	func test_middle():
		if enemy_grid.NUM_ENEMIES.x < 1 or enemy_grid.NUM_ENEMIES.y < 1:
			return

		var result = EnemyGrid._enemy_position(1, 1)
		assert_eq(
			Vector2(
				EnemyGrid.ENEMY_SIZE.x + (0.5 * EnemyGrid.ENEMY_SIZE.x) + EnemyGrid.GAP_SIZE.x,
				EnemyGrid.ENEMY_SIZE.y + (0.5 * EnemyGrid.ENEMY_SIZE.y) + EnemyGrid.GAP_SIZE.y),
			result)
