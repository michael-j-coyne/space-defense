class_name Main extends Node

@onready var enemy_spawn: EnemyGrid = get_node("EnemyGrid") as EnemyGrid

func _ready() -> void:
	enemy_spawn.spawn_enemies()
