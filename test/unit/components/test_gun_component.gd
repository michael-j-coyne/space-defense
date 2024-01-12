extends GutTest

# NOTE: I am not so sure that this test is any good.
func shoot_ammo(ammo: PackedScene):
	var direction = Vector2(0, -1)

	var gun = GunComponent.new()
	gun.projectile_speed = 300.0
	gun.damage = 1.0
	gun.ammo = ammo
	add_child_autofree(gun)

	gun.position = Vector2(0.0, 500)
	var projectile = gun.shoot(direction)

	# ensure that the properties of the gun are passed along to the projectile
	# and that the projectile was added to the scene
	assert_eq(projectile.direction, direction)
	assert_eq(projectile.speed, gun.projectile_speed)
	assert_eq(projectile.attack.damage, gun.damage)
	assert_eq(projectile in get_node("/root").get_children(), true)

	projectile.free()

func test_shoot_blue_laser():
	shoot_ammo(load("res://scenes/projectiles/player_projectiles/blue_laser.tscn"))

func test_shoot_basic_red_laser():
	shoot_ammo(load("res://scenes/projectiles/enemy_projectiles/basic_red_laser.tscn"))
