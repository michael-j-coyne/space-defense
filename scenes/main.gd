extends Node2D

var levels := [
	load("res://scenes/levels/level_1.tscn"),
	load("res://scenes/levels/level_2.tscn")
]

var current_level_index = 0
var current_level: Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level: Level = levels[current_level_index].instantiate() as Level
	level.completed.connect(go_next_level)
	current_level = level
	add_child(level)

func go_next_level():
	if current_level_index == levels.size() - 1:
		# no more levels
		return

	current_level.queue_free()
	current_level_index += 1
	var level: Level = levels[current_level_index].instantiate() as Level
	level.completed.connect(go_next_level)
	current_level = level
	add_child(level)

