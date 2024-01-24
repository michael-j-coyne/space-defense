extends Node

var money: int
var speed: float

# gun variables
var gun_cooldown: float
var gun_projectile_speed: float
var gun_penetrations: int

func _ready() -> void:
	reset()

func reset():
	money = 0
	speed = 400

	# gun variables
	gun_cooldown = 0.75
	gun_projectile_speed = 750
	gun_penetrations = 1
