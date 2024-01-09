extends GutTest


func test_damage():
	var hc = HealthComponent.new()

	var attack = Attack.new()
	attack.damage = hc.MAX_HEALTH - 0.5
	hc.take_damage(attack)

	assert_eq(hc.health, hc.MAX_HEALTH - 0.5)

	hc.free()
