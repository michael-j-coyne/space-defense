class_name AttackHitboxComponent extends Area2D
# This class is coupled to the parent,
# it relies on the parent having the "attack" member variable

# Note: it may be nice to use something like get_attack so we can
# change the logic later. Or, we could implement getters / setters for
# the attack property.

signal attack_landed

func _on_area_entered(area: Area2D):
	var parent = get_parent()
	if area.has_method("take_damage") and "attack" in parent:
		area.take_damage(parent.attack)
		attack_landed.emit()
