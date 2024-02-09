@tool
class_name Level extends Node2D

signal completed
signal failed

var level_completed = false
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
		# NOTE: I am not sure if the money is going to be calculated
		# in the right order...
		enemy.died.connect(
			func(value):
				money_earned_in_level += value
		)

func level_failed():
	if not level_failed_emitted:
		PlayerVariables.money -= money_earned_in_level
		failed.emit()
	level_failed_emitted = true

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

func _on_all_enemies_defeated():
	level_completed = true
	completed.emit()
