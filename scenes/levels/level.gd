class_name Level extends Node2D

signal level_complete

func _on_all_enemies_defeated():
	level_complete.emit()
