@tool
class_name Level extends Node2D

signal completed
signal failed

var level_completed = false
@export var player: Player

func _ready() -> void:
	if Engine.is_editor_hint():
		return

	player.tree_exiting.connect(emit_level_failed)

	var enemies = get_tree().get_nodes_in_group("enemies")

	for enemy: Enemy in enemies:
		enemy.reached_bottom.connect(emit_level_failed)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	# NOTE: what if there are multiple signals that need to be connected?
	# how will we check for each one?
	if not get_incoming_connections():
		warnings.append("No signals detected. Make sure to connect a signal from the Enemies so
		that we can determine when all of the enemies have been killed.")
	if not player:
		warnings.append("You need to connect the player to the Level, select the player
		in the export vars")
	return warnings

func emit_level_failed() -> void:
	if not level_completed:
		failed.emit()

func _on_all_enemies_defeated():
	level_completed = true
	completed.emit()
