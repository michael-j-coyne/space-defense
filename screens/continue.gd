extends TextureRect

signal new_game
signal continue_game

var tween_time = 1.0
@export var continue_button: Button
@export var new_game_button: Button
@export var confirmation_dialog: ConfirmationDialog

func _ready():
	continue_button.grab_focus()

func _on_new_game_pressed() -> void:
	confirmation_dialog.visible = true
	confirmation_dialog.confirmed.connect(func(): new_game.emit())

func _on_continue_pressed() -> void:
	continue_game.emit()

func _on_new_game_button_mouse_entered() -> void:
	new_game_button.grab_focus()

func _on_continue_button_mouse_entered() -> void:
	continue_button.grab_focus()
