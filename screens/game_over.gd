extends Sprite2D

signal return_to_title_requested
signal retry_requested
signal shop_requested

var level_screenshot: Sprite2D
var tween_time = 3.0
@onready var retry_button = get_node("CenterContainer/VBoxContainer/RetryButton")

func _ready():
	retry_button.grab_focus()
	if level_screenshot:
		var tween = level_screenshot.create_tween()
		tween.tween_property(level_screenshot, "modulate:a", 0, tween_time)

# TODO: rename this
func _on_button_pressed() -> void:
	return_to_title_requested.emit()
	queue_free()

func _on_shop_button_pressed() -> void:
	shop_requested.emit()
	queue_free()

func _on_retry_button_pressed() -> void:
	retry_requested.emit()
	queue_free()

func add_level_screenshot(screenshot: Sprite2D):
	level_screenshot = screenshot
	add_child(level_screenshot)
