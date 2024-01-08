class_name GunComponent extends Node2D

@export var ammo: PackedScene
@export var projectile_speed := 0.0
@export var damage := 0.0

func shoot(direction: Vector2):
	var attack = Attack.new()
	attack.damage = damage

	# TODO: once we create the Projectile, do .instantiate() as Projectile
	var projectile = ammo.instantiate()
	projectile.attack = attack
	projectile.speed = projectile_speed
	projectile.direction = direction
	projectile.global_position = global_position

	get_node("/root").add_child(projectile)
