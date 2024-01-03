class_name Player extends Area2D

const PLAYER_SIZE = Vector2(100, 100)
@export var speed = 400
var velocity = Vector2.ZERO
@onready var weapon := $Weapon as Weapon

func _ready():
	var sprite = get_node("Sprite2D")
	var collision = get_node("CollisionPolygon2D")
	var scaling = PLAYER_SIZE / sprite.texture.get_size()

	# if this is not true, the collision shape scaling will behave improperly
	assert(scaling.x == scaling.y)

	collision.scale = scaling
	sprite.scale = scaling

	# TODO: fix hardcoded values
	weapon.setup(1.0, 1.0, 1.0, 5.0, preload("res://scenes/projectile.tscn"))

func _physics_process(delta):
	velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_accept"):
		# TODO: remove hardcoded velocity func
		var velocity_func = func(_delta): return Vector2(0, -10)
		weapon.fire(velocity_func, "player")

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed

	position += velocity * delta
