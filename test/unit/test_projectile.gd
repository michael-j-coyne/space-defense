extends GutTest

const damage_amount = 2.3
const time_alive = 3.9
const initial_pos = Vector2(100, 50)

var player_projectile: Projectile
var enemy_projectile: Projectile
var velocity_func = func(_delta): return Vector2(1, 1)

func before_each():
	player_projectile = Projectile.new()
	player_projectile.setup(velocity_func, damage_amount, time_alive, "player", initial_pos)

	enemy_projectile = Projectile.new()
	enemy_projectile.setup(velocity_func, damage_amount, time_alive, "enemy", initial_pos)

func after_each():
	player_projectile.free()
	enemy_projectile.free()

func test_get_damage_source():
	assert_eq(player_projectile.get_damage_source(), "player")
	assert_eq(enemy_projectile.get_damage_source(), "enemy")

func test_get_damage_amount():
	assert_eq(player_projectile.damage(), damage_amount)

func test_processing():
	simulate(enemy_projectile, 60, 1.0 / 60)
	pass_test("Make sure we can call _physics_process without crashing")

func test_timer_destroys_node():
	var test_projectile = Projectile.new()
	test_projectile.setup(velocity_func, 1.0, 0.0000001, "player", initial_pos)
	add_child(test_projectile)
	await wait_for_signal(test_projectile.ready, 0.5)
	await wait_frames(1)
	assert_freed(test_projectile)
