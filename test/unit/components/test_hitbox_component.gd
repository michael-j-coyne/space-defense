extends GutTest

func test_take_damage_no_health_component():
	var hitbox = HitboxComponent.new()
	var attack = Attack.new()
	attack.damage = 1.0

	hitbox.take_damage(attack)
	hitbox.free()
	pass_test("this shouldn't crash the game")

func test_take_damage():
	var hitbox = HitboxComponent.new()

	var health = HealthComponent.new()
	health.MAX_HEALTH = 1.0
	health.health = 1.0

	var attack = Attack.new()
	attack.damage = 0.5

	hitbox.health_component = health
	hitbox.take_damage(attack)

	assert_eq(health.health, 0.5)

	hitbox.free()
	health.free()
