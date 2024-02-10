@tool
class_name Level extends Node2D

signal completed
signal failed(screenshot: Sprite2D)

var level_failed_emitted = false
@export var player: Player
var money_earned_in_level = 0

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	Globals.current_level = self

	player.died.connect(level_failed)

	var enemies = get_tree().get_nodes_in_group("enemies")

	for enemy: Enemy in enemies:
		enemy.reached_bottom.connect(level_failed)
		enemy.died.connect(
			func(value):
				money_earned_in_level += value
		)

func take_screenshot():
	var image: Image = get_viewport().get_texture().get_image()
	var screen_size = get_node("/root").content_scale_size
	image.resize(screen_size.x, screen_size.y)

	var sprite = Sprite2D.new()
	var texture = ImageTexture.create_from_image(image)

	sprite.texture = texture
	sprite.centered = false
	return sprite

func level_failed():
	if not level_failed_emitted:
		PlayerVariables.money -= money_earned_in_level
		failed.emit(take_screenshot())
	level_failed_emitted = true
	queue_free()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	if not get_incoming_connections():
		warnings.append("No signals detected. Make sure to connect a signal from the Enemies so
		that we can determine when all of the enemies have been killed.")
	if not player:
		warnings.append("You need to connect the player to the Level, select the player
		in the export vars")
	return warnings

func _on_all_enemies_defeated():
	completed.emit()
	queue_free()
