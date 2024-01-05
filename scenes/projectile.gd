class_name Projectile extends Area2D

var _velocity_callable: Callable
var _damage_value: float
var _time_alive: float
var _damage_source: String

func setup(
	velocity_callable: Callable,
	damage_value: float,
	time_alive: float,
	damage_source: String,
	initial_position):

	_velocity_callable = velocity_callable
	_damage_value = damage_value
	_time_alive = time_alive
	_damage_source = damage_source
	position = initial_position

	_rotate_self(0)

func _ready():
	_setup_timer()

func _rotate_self(delta: float):
	var v1 = _velocity_callable.call(delta).normalized()
	var v2 = Vector2(0, -1)
	rotation = atan2(v1.y, v1.x) - atan2(v2.y, v2.x)

func _setup_timer():
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = _time_alive
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", destroy)

func get_damage_source() -> String:
	return _damage_source

# returns the damage that should be applied when
# the projectile collides with something that can be damaged
func damage() -> float:
	return _damage_value

func destroy():
	queue_free()

func _physics_process(delta):
	_rotate_self(delta)
	position += _velocity_callable.call(delta)

func _on_area_entered(area):
	if area is Enemy and _damage_source == "player":
		destroy()
	elif area is Player and _damage_source == "enemy":
		destroy()
