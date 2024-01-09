extends GutTest

func helper_test_get_size(projectile: Projectile):
	const scaling_factor = Vector2(1.5, 1.5)
	var initial_size = projectile.get_size()
	projectile.scale = scaling_factor
	var size_after_scaling = projectile.get_size()

	assert_eq(size_after_scaling, initial_size * scaling_factor)

	projectile.free()

func test_blue_laser_get_size():
	var projectile = load(
		"res://scenes/projectiles/player_projectiles/blue_laser.tscn").instantiate()
	helper_test_get_size(projectile)

func test_basic_red_laser_get_size():
	var projectile = load(
		"res://scenes/projectiles/enemy_projectiles/basic_red_laser.tscn").instantiate()
	helper_test_get_size(projectile)

func helper_test_physics_process(speed: float, direction: Vector2):
	var projectile = Projectile.new()
	projectile.speed = speed
	projectile.direction = direction

	simulate(projectile, 1, 1.0)
	assert_almost_eq(projectile.position, direction * speed, Vector2(0.01, 0.01))

	projectile.free()

func test_physics_process_with_speed():
	helper_test_physics_process(100.0, Vector2(1, 1).normalized())

func test_physics_process_no_speed():
	helper_test_physics_process(0, Vector2(1, 1).normalized())

func test_physics_process_no_direction():
	helper_test_physics_process(100.0, Vector2(0, 0))
