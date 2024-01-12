class_name EmptyNotifierContainer extends Node

signal all_children_freed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if get_child_count() == 0:
		all_children_freed.emit()
		queue_free()
