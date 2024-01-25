class_name Game extends Node

var levels := [
	load("res://scenes/levels/level_1.tscn"),
	load("res://scenes/levels/level_2.tscn"),
	load("res://scenes/levels/level_3.tscn"),
	load("res://scenes/levels/level_4.tscn"),
	load("res://scenes/levels/level_5.tscn"),
	load("res://scenes/levels/level_6.tscn"),
]

var current_level_index = 0
var money_at_level_start = 0
signal new_game_requested

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_screen = load("res://screens/start.tscn").instantiate()
	add_child(start_screen)
	await start_screen.start
	start_screen.queue_free()
	await start_screen.tree_exited

	var level: Level = levels[current_level_index].instantiate() as Level
	start_level(level)

func start_level(level):
	money_at_level_start = PlayerVariables.money
	level.completed.connect(go_next_level)
	level.failed.connect(_on_level_failed, CONNECT_ONE_SHOT)
	Globals.current_level = level
	add_child(level)

func go_next_level():
	if Globals.current_level:
		Globals.current_level.queue_free()
		await Globals.current_level.tree_exited

	if current_level_index == levels.size() - 1:
		# no more levels
		add_child(load("res://screens/win.tscn").instantiate())
		return

	current_level_index += 1

	var shop: Shop = load("res://screens/shop.tscn").instantiate()
	add_child(shop)

	await shop.continue_pressed

	shop.queue_free()
	await shop.tree_exited

	var level: Level = levels[current_level_index].instantiate() as Level
	start_level(level)

func restart_level() -> void:
	PlayerVariables.money = money_at_level_start
	var level: Level = levels[current_level_index].instantiate() as Level
	start_level(level)

func _on_level_failed() -> void:
	if is_instance_valid(Globals.current_level):
		Globals.current_level.queue_free()
	var game_over_screen = load("res://screens/game_over.tscn").instantiate()
	game_over_screen.new_game_requested.connect(func(): new_game_requested.emit())
	game_over_screen.retry_requested.connect(
		func():
			game_over_screen.queue_free()
			await game_over_screen.tree_exited
			restart_level()
	)
	add_child(game_over_screen)
