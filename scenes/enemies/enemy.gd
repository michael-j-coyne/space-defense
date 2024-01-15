class_name Enemy extends Node2D

# returns the abstract "bounding box" for the node, it is the space that the
# node occupies on the screen.
func boundary():
	pass

func check_reached_bottom() -> void:
	pass
