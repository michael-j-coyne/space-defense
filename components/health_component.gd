class_name HealthComponent extends Node

@export var MAX_HEALTH: int = 1
var health: int = MAX_HEALTH

func take_damage(attack: Attack):
	health -= attack.damage

	if health <= 0:
		get_parent().queue_free()
