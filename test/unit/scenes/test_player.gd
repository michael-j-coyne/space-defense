extends GutTest

func test_get_health():
	var player := load("res://scenes/player.tscn").instantiate() as Player
	assert_eq(player.get_current_health() > 0, true)
	player.free()
