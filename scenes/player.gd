class_name Player extends Area2D

const states = {
	"initial": PlayerState.InitialState,
	"free": PlayerState.FreeState
}

const PLAYER_SIZE = Vector2(100, 100)
@export var speed = 400
var velocity = Vector2.ZERO
@onready var weapon := $Weapon as Weapon
var state : PlayerState

func _ready():
	var sprite = get_node("Sprite2D")
	var collision = get_node("CollisionPolygon2D")
	var scaling = PLAYER_SIZE / sprite.texture.get_size()

	# if this is not true, the collision shape scaling will behave improperly
	assert(scaling.x == scaling.y)

	collision.scale = scaling
	sprite.scale = scaling

	# TODO: fix hardcoded values
	weapon.setup(1.0, 1.0, 1.0, 5.0, "player", load("res://scenes/blue_laser.tscn"))

	change_state("initial")

func change_state(state_name: String):
	state = states[state_name].new(self)

func _physics_process(delta):
	state.physics_process(delta)

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("damage") and\
	area.has_method("get_damage_source") and\
	area.get_damage_source() == "enemy":
		state.take_damage(area.damage())
