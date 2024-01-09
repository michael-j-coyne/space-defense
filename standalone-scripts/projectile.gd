class_name Projectile extends Node2D

# What exactly is the consequence of not setting defaults? What is the benefit?
var attack: Attack
var speed: float
var direction: Vector2
@export var time_alive: float = 2.0

func _ready() -> void:
	get_tree().create_timer(time_alive).connect("timeout", func(): queue_free())

func _physics_process(delta: float) -> void:
	var velocity = direction * speed
	position += velocity * delta
