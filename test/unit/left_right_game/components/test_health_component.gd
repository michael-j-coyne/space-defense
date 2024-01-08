extends GutTest

const health_component = preload("res://left_right_game/components/health_component.tscn")

func test_damage():
	var hc = health_component.instantiate()

	var attack = Attack.new()
	attack.damage_value = hc.health - 0.5

	hc.damage(attack)

	assert_eq(hc.health, hc.health - 0.5)
