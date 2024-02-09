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

func _on_continue_pressed() -> void:
	continue_game.emit()
	queue_free()

func _on_new_game_button_mouse_entered() -> void:
	new_game_button.grab_focus()

func _on_continue_button_mouse_entered() -> void:
	continue_button.grab_focus()

func _on_new_game_button_focus_entered() -> void:
	var tween = NodeFlasher.node_flash(new_game_button, tween_time)
	new_game_button.focus_exited.connect(
		func():
			new_game_button.modulate.a = 1
			tween.kill()
	)

func _on_continue_button_focus_entered() -> void:
	var tween = NodeFlasher.node_flash(continue_button, tween_time)
	continue_button.focus_exited.connect(
		func():
			continue_button.modulate.a = 1
			tween.kill()
	)

func _on_confirmation_dialog_confirmed() -> void:
	new_game.emit()
	queue_free()
