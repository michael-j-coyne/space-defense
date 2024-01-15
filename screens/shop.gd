extends Sprite2D

signal continue_pressed

func _on_continue_pressed() -> void:
	continue_pressed.emit()
