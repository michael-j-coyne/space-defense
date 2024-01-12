extends Node2D

var levels := [
	load("res://scenes/levels/level_1.tscn"),
	load("res://scenes/levels/level_2.tscn")
]

var current_level_index = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level: Level = levels[current_level_index].instantiate() as Level
	level.completed.connect(func(): print('yay complete!'))
	add_child(level)
