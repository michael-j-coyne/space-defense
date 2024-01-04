class_name Weapon extends Node2D

var _cooldown := 1.0
var _base_damage := 1.0
var _damage_multiplier := 1.0
var _cooling_down = false
var _projectile_despawn_time = 1.0
var _damage_source := ""
var _projectile_scene: PackedScene

func _ready():
	$Timer.wait_time = _cooldown
	$Timer.connect("timeout", _cooldown_finished)

func setup(
	cooldown: float,
	base_damage: float,
	damage_multiplier: float,
	projectile_despawn_time: float,
	damage_source: String,
	projectile_scene: PackedScene,
):

	_cooldown = cooldown
	_base_damage = base_damage
	_damage_multiplier = damage_multiplier
	_projectile_despawn_time = projectile_despawn_time
	_projectile_scene = projectile_scene
	_damage_source = damage_source

func _cooldown_finished():
	_cooling_down = false

func set_cooldown(cd: float):
	_cooldown = cd

func fire(velocity_func: Callable, damage_source: String) -> void:
	if _cooling_down:
		return

	var projectile = _projectile_scene.instantiate()

	projectile.setup(
		velocity_func,
		_base_damage * _damage_multiplier,
		_projectile_despawn_time,
		damage_source)

	# TEMP, JANKY
	projectile.global_position = to_global(position)

	# careful here...
	get_tree().root.add_child(projectile)

	$Timer.start()
	_cooling_down = true
