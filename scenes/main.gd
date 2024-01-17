extends Node2D

func _ready() -> void:
	new_game()

func new_game():
	Globals.reset()
	PlayerVariables.reset()
	var game = Game.new()
	game.new_game_requested.connect(
		func():
			game.queue_free()
			new_game()
	)
	add_child(game)
