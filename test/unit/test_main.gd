extends GutTest

class TestEnemyPosition:
	extends GutTest

	func test_start():
		var result = Main.enemy_position(0, 0)
		assert_eq(Vector2(Main.ENEMY_SIZE.x, Main.ENEMY_SIZE.y) * Vector2(0.5, 0.5), result)

	func test_end():
		var result = Main.enemy_position(Main.NUM_ENEMIES.y - 1, Main.NUM_ENEMIES.x - 1)
		assert_eq(
			Vector2(
				Main.ENEMY_GROUP_SIZE.x - (0.5 * Main.ENEMY_SIZE.x),
				Main.ENEMY_GROUP_SIZE.y - (0.5 * Main.ENEMY_SIZE.y)),
			result)

	func test_middle():
		if Main.NUM_ENEMIES.x < 1 or Main.NUM_ENEMIES.y < 1:
			return

		var result = Main.enemy_position(1, 1)
		assert_eq(
			Vector2(
				Main.ENEMY_SIZE.x + (0.5 * Main.ENEMY_SIZE.x) + Main.GAP_SIZE.x,
				Main.ENEMY_SIZE.y + (0.5 * Main.ENEMY_SIZE.y) + Main.GAP_SIZE.y),
			result)
