extends Sprite2D

signal new_game_requested
signal retry_requested
signal shop_requested

var tween_time = 1.0
@onready var retry_button = get_node("VBoxContainer/RetryButton")

func _ready():
	retry_button.grab_focus()

func _on_button_pressed() -> void:
	new_game_requested.emit()

func _on_shop_button_pressed() -> void:
	shop_requested.emit()

func _on_retry_button_pressed() -> void:
	retry_requested.emit()
