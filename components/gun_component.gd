@tool
class_name GunComponent extends Node2D

## How long before the gun can fire again
@export var cooldown: float = 1.0
## The projectile scene which will be shot from the gun
@export var ammo: PackedScene
## How fast the projectile fired from the gun moves in pixels / second
@export var projectile_speed := 0.0
## How much damage the projectile fired from the gun will do, before any multipliers
@export var damage: int = 0

# If the gun is cooling down, it can't fire.
var cooling_down = false

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	if not ammo:
		warnings.append("You have not given the gun any ammo. The gun will be unable to shoot.")
	if damage == 0:
		warnings.append("The damage of the gun is 0. The projectiles will not do any damage.")
	if projectile_speed == 0:
		warnings.append("The projectile speed is 0. The projectiles will not move.")
	if cooldown < 0:
		warnings.append("The cooldown must be >= 0")

	return warnings

func shoot(direction: Vector2) -> Projectile:
	if cooling_down:
		return

	var attack = Attack.new()
	attack.damage = damage

	var projectile: Projectile = ammo.instantiate() as Projectile
	projectile.attack = attack
	projectile.speed = projectile_speed
	projectile.direction = direction

	# NOTE: I will also need to rotate the projectile if I decide to make the gun able to shoot
	# at various angles.

	var translation_direction = position.normalized()
	var translation_amount = Vector2(0, projectile.get_size().y / 2)

	projectile.global_position = global_position + translation_direction * translation_amount

	# TODO: append projectile to the "level" not the "root"
	get_node("/root").add_child(projectile)

	cooling_down = true
	get_tree().create_timer(cooldown).connect("timeout", func(): cooling_down = false)

	return projectile

