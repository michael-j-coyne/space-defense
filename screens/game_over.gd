extends Sprite2D

signal new_game_requested

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		new_game_requested.emit()

func _on_button_pressed() -> void:
	new_game_requested.emit()
