extends Node2D

var levels := [
	load("res://scenes/levels/level_1.tscn"),
	load("res://scenes/levels/level_2.tscn"),
	load("res://scenes/levels/level_3.tscn")
]

var current_level_index = 0
var current_level: Level

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level: Level = levels[current_level_index].instantiate() as Level
	level.completed.connect(go_next_level)
	level.failed.connect(_on_level_failed)
	current_level = level
	add_child(level)

func go_next_level():
	if current_level_index == levels.size() - 1:
		# no more levels
		return

	current_level_index += 1

	current_level.queue_free()
	await current_level.tree_exited

	var shop: Shop = load("res://screens/shop.tscn").instantiate()
	add_child(shop)

	await shop.continue_pressed

	shop.queue_free()
	await shop.tree_exited

	var level: Level = levels[current_level_index].instantiate() as Level
	level.completed.connect(go_next_level)
	level.failed.connect(_on_level_failed)
	current_level = level
	add_child(level)

func _on_level_failed() -> void:
	current_level.queue_free()
	add_child.call_deferred(load("res://screens/game_over.tscn").instantiate())

