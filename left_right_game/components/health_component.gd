class_name HealthComponent extends Node

@export var MAX_HEALTH := 1.0
var health = MAX_HEALTH

func take_damage(attack: Attack):
	health -= attack.damage

	if health <= 0:
		var parent = get_parent()
		if parent.has_method("die"): parent.die()
