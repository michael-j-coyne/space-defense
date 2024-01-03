class_name Weapon extends Node2D

var _cooldown := 1.0
var _base_damage := 1.0
var _damage_multiplier := 1.0
var _cooling_down = false
var _projectile_scene = preload("res://scenes/projectile.tscn")

func _ready():
	$Timer.wait_time = _cooldown
	$Timer.connect("timeout", _cooldown_finished)

func _cooldown_finished():
	_cooling_down = false

func set_cooldown(cd: float):
	_cooldown = cd

func fire() -> void:
	if _cooling_down:
		return

	var projectile = _projectile_scene.instantiate()

	# TODO: remove harcoded values
	var velocity_func = func(_delta): return Vector2(0, -5)
	var projectile_despawn_time = 5.0

	projectile.setup(
		velocity_func,
		_base_damage * _damage_multiplier,
		projectile_despawn_time,
		"player")

	# TEMP, JANKY
	projectile.global_position = to_global(position)

	# careful here...
	get_tree().root.add_child(projectile)

	$Timer.start()
	_cooling_down = true
