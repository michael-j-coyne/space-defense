extends GutTest


func test_damage_no_kill():
	var hc = HealthComponent.new()
	hc.MAX_HEALTH = 100
	hc.health = hc.MAX_HEALTH

	var attack = Attack.new()
	attack.damage = hc.MAX_HEALTH - 1
	hc.take_damage(attack)

	assert_eq(hc.health, 1)

	hc.free()

func test_deadly_damage():
	var parent = Node.new()
	var hc = HealthComponent.new()
	parent.add_child(hc)
	hc.MAX_HEALTH = 1
	hc.health = hc.MAX_HEALTH

	var attack = Attack.new()
	attack.damage = hc.health + 1
	hc.take_damage(attack)

	await wait_frames(2)
	assert_freed(parent)

func test_deadly_damage_boundary():
	var parent = Node.new()
	var hc = HealthComponent.new()
	parent.add_child(hc)
	hc.MAX_HEALTH = 1
	hc.health = 1

	var attack = Attack.new()
	# boundary is that health should reach 0.0, but not go below
	attack.damage = hc.health
	hc.take_damage(attack)

	await wait_frames(2)
	assert_freed(parent)
