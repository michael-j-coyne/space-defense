class_name Projectile extends Area2D

var velocity_func: Callable
var damage_val: float
var despawn_time: float

func setup(velocity_callable: Callable, damage_value: float, time_alive: float):
	velocity_func = velocity_callable
	damage_val = damage_value
	despawn_time = time_alive

func _ready():
	_setup_timer()

func _setup_timer():
	var timer := Timer.new()
	add_child(timer)
	timer.wait_time = despawn_time
	timer.one_shot = true
	timer.start()
	timer.connect("timeout", destroy)

# returns the damage that should be applied when
# the projectile collides with something that can be damaged
func damage() -> float:
	return damage_val

func destroy():
	get_parent().remove_child(self)
	queue_free()

func _physics_process(delta):
	position += velocity_func.call(delta)
