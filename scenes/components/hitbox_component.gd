@tool
class_name HitboxComponent extends Area2D

@export var health_component: HealthComponent

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	if not health_component:
		warnings.append("You have not set a health component.")
	return warnings

func take_damage(attack: Attack):
	if health_component:
		health_component.take_damage(attack)
