class_name AttackHitboxComponent extends Area2D
# This class is coupled to the parent,
# it relies on the parent having the "attack" member variable

var enabled = true
signal attack_landed

func _on_area_entered(area: Area2D):
	if not enabled:
		return

	var parent = get_parent()
	if area.has_method("take_damage") and "attack" in parent:
		area.take_damage(parent.attack)
		attack_landed.emit()
