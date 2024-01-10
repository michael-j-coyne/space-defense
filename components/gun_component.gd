@tool
class_name GunComponent extends Node2D

@export var ammo: PackedScene
@export var projectile_speed := 0.0
@export var damage := 0.0

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	if not ammo:
		warnings.append("You have not given the gun any ammo. The gun will be unable to shoot.")
	if damage == 0:
		warnings.append("The damage of the gun is 0. The projectiles will not do any damage.")
	if projectile_speed == 0:
		warnings.append("The projectile speed is 0. The projectiles will not move.")

	return warnings

func shoot(direction: Vector2) -> Projectile:
	var attack = Attack.new()
	attack.damage = damage

	var projectile: Projectile = ammo.instantiate() as Projectile
	projectile.attack = attack
	projectile.speed = projectile_speed
	projectile.direction = direction

	# Note: I will also need to rotate the projectile if I decide to make the gun able to shoot
	# at various angles.

	var translation_direction = position.normalized()
	var translation_amount = Vector2(0, projectile.get_size().y / 2)

	projectile.global_position = global_position + translation_direction * translation_amount

	get_node("/root").add_child(projectile)

	return projectile

