extends GutTest

func test_take_damage_no_health_component():
	var hitbox = HitboxComponent.new()
	var attack = Attack.new()
	attack.damage = 1

	hitbox.take_damage(attack)
	hitbox.free()
	pass_test("this shouldn't crash the game")

func test_take_damage():
	var hitbox = HitboxComponent.new()

	var health = HealthComponent.new()
	health.MAX_HEALTH = 2
	health.health = health.MAX_HEALTH

	var attack = Attack.new()
	attack.damage = 1

	hitbox.health_component = health
	hitbox.take_damage(attack)

	assert_eq(health.health, 1)

	hitbox.free()
	health.free()
