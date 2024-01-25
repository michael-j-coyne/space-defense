class_name Game extends Node

var levels := [
	load("res://scenes/levels/level_1.tscn"),
	load("res://scenes/levels/level_2.tscn"),
	load("res://scenes/levels/level_3.tscn"),
	load("res://scenes/levels/level_4.tscn"),
]

var g = Globals
var money_at_level_start = 0
signal new_game_requested

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start_screen = load("res://screens/start.tscn").instantiate()
	var dir = DirAccess.open("user://")
	if dir.file_exists("savegame.save"):
		print("savegame found")
	add_child(start_screen)
	await start_screen.start
	start_screen.queue_free()
	await start_screen.tree_exited

	var level: Level = levels[g.current_level_idx].instantiate() as Level
	start_level(level)

func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_nodes = [PlayerVariables, Globals]
	for node in save_nodes:

		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		var node_data = node.call("save")

		save_game.store_var(node_data)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return

	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)

	while save_game.get_position() < save_game.get_length():
		var data = save_game.get_var()
		var singleton = get_node("/root/" + data["singleton_name"])

		if not singleton:
			push_error("No singleton found with name '%s'" % data["singleton_name"])
			return

		for key in data.keys():
			if key == "singleton_name":
				continue
			if key == "shop_stock":
				for item_name in data[key].keys():
					var saved_stock = data[key][item_name]
					singleton.shop_inventory[item_name].stock = saved_stock
				continue
			singleton.set(key, data[key])

func start_level(level):
	save_game()
	money_at_level_start = PlayerVariables.money
	level.completed.connect(go_next_level)
	level.failed.connect(_on_level_failed, CONNECT_ONE_SHOT)
	g.current_level = level
	add_child(level)

func go_next_level():
	save_game()
	if g.current_level:
		g.current_level.queue_free()
		await g.current_level.tree_exited

	if g.current_level_idx == levels.size() - 1:
		# no more levels
		var dir = DirAccess.open("user://")
		dir.remove("savegame.save")

		add_child(load("res://screens/win.tscn").instantiate())
		return

	g.current_level_idx += 1

	var shop: Shop = load("res://screens/shop.tscn").instantiate()
	add_child(shop)

	await shop.continue_pressed

	shop.queue_free()
	await shop.tree_exited

	var level: Level = levels[g.current_level_idx].instantiate() as Level
	start_level(level)

func restart_level() -> void:
	PlayerVariables.money = money_at_level_start
	var level: Level = levels[g.current_level_idx].instantiate() as Level
	start_level(level)

func _on_level_failed() -> void:

	var game_over_screen = load("res://screens/game_over.tscn").instantiate()
	game_over_screen.new_game_requested.connect(
		func():
			get_tree().paused = false
			new_game_requested.emit()
	)
	game_over_screen.retry_requested.connect(
		func():
			game_over_screen.queue_free()
			await game_over_screen.tree_exited
			g.current_level.queue_free()
			await g.current_level.tree_exited

			get_tree().paused = false
			restart_level()
	)
	add_child(game_over_screen)
	get_tree().paused = true

	game_over_screen.process_mode = PROCESS_MODE_ALWAYS
	game_over_screen.modulate.a = 0
	var tween = game_over_screen.create_tween()
	tween.tween_property(game_over_screen, "modulate:a", 1, 3.0)
