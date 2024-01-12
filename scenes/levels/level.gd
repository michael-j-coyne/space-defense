class_name Level extends Node2D

signal completed

func _on_all_enemies_defeated():
	completed.emit()
