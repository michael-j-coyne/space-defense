extends Sprite2D

signal new_game
signal continue_game

var tween_time = 1.0

func _ready():
	NodeFlasher.node_flash($ContinueButton, tween_time)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		continue_game.emit()
	if Input.is_action_just_pressed("ui_text_backspace"):
		new_game.emit()

func _on_new_game_pressed() -> void:
	new_game.emit()

func _on_continue_pressed() -> void:
	continue_game.emit()
