class_name AttackHitboxComponent extends Area2D

func _on_area_entered(area: Area2D):
	if area.has_method("take_damage"):
		area.take_damage(get_parent().attack)
