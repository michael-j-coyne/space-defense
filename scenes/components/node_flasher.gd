class_name NodeFlasher extends Node

static func node_flash(node, time_secs):
	# Ensure the node's visibility is on
	node.show()

	var tween = node.create_tween()

	# infinite loops
	tween.set_loops()

	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(node, "modulate:a", 0, time_secs).set_ease(Tween.EASE_IN)
	tween.tween_property(node, "modulate:a", 1, time_secs).set_ease(Tween.EASE_OUT)

	return tween
