class_name NodeFlasher extends Node

static func node_flash(node, time_secs):
	node_fadeout(node, time_secs)

static func node_fadeout(node, time_secs):
	var tween = node.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(node, "modulate:a", 0, time_secs)
	tween.tween_callback(func(): node_fadein(node, time_secs))

static func node_fadein(node, time_secs):
	var tween = node.create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "modulate:a", 1, time_secs)
	tween.tween_callback(func(): node_fadeout(node, time_secs))
