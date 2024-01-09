extends GutTest

func test_shoot():
	var ammo = load("res://scenes/projectiles/player_projectiles/blue_laser.tscn")

	var direction = Vector2(0, -1)

	var gun = GunComponent.new()
	gun.projectile_speed = 300.0
	gun.damage = 1.0
	gun.ammo = ammo
	add_child_autofree(gun)

	gun.position = Vector2(0.0, 500)
	var projectile = gun.shoot(direction)

	assert_eq(projectile.position, gun.position)
	assert_eq(projectile.direction, direction)
	assert_eq(projectile.speed, gun.projectile_speed)
	assert_eq(projectile.attack.damage, gun.damage)
	assert_eq(projectile in get_node("/root").get_children(), true)

	projectile.free()
