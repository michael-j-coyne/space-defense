@tool
class_name Level extends Node2D

signal completed

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	# NOTE: what if there are multiple signals that need to be connected?
	# how will we check for each one?
	if not get_incoming_connections():
		warnings.append("No signals detected. Make sure to connect a signal from the Enemies so
		that we can determine when all of the enemies have been killed.")
	return warnings

func _on_all_enemies_defeated():
	completed.emit()
