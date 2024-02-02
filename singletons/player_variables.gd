extends Node

var money: int
var speed: float

# gun variables
var gun_cooldown: float
var gun_projectile_speed: float
var gun_penetrations: int
var has_gatling_gun: bool
# NOTE: doesn't make much sense for gun_heat to be stored here.
# it should be stored in player or gun.
var gun_heat: float
var max_heat: float

func _ready() -> void:
	reset()

func reset():
	money = 0
	speed = 400

	# gun variables
	gun_cooldown = 0.75
	gun_projectile_speed = 750
	gun_penetrations = 1
	gun_heat = 0
	max_heat = 15

	has_gatling_gun = false

func save() -> Dictionary:
	return {
		"singleton_name": "PlayerVariables",
		"money": money,
		"speed": speed,
		"gun_cooldown": gun_cooldown,
		"gun_projectile_speed": gun_projectile_speed,
		"gun_penetrations": gun_penetrations,
		"max_heat": max_heat,
		"has_gatling_gun": has_gatling_gun,
	}
