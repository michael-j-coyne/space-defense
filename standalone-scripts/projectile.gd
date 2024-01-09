class_name Projectile extends Node2D

# What exactly is the consequence of not setting defaults? What is the benefit?
var attack: Attack
var speed: float
var direction: Vector2

func _physics_process(delta: float) -> void:
	var velocity = direction * speed
	position += velocity * delta
