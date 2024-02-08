class_name HealthComponent extends Node

@export var MAX_HEALTH: int = 1
var health: int = MAX_HEALTH

func _ready() -> void:
	health = MAX_HEALTH

func take_damage(attack: Attack):
	health -= attack.damage

	var parent = get_parent()

	if parent.has_method("flash_red"):
		parent.flash_red()

	if health <= 0:
		if parent.has_method("die"):
			parent.die()
		else:
			parent.queue_free()
