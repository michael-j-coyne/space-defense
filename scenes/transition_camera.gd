class_name TransitionCamera extends Camera2D

@onready var SCREEN_SIZE = get_tree().root.content_scale_size

func pan_to_camera(src_camera: Camera2D, target_camera: Camera2D, transiton_time: float, pause_during_transition: bool = true):
	var tween = self.create_tween()

	if src_camera.anchor_mode == ANCHOR_MODE_DRAG_CENTER:
		position = src_camera.global_position - 0.5 * SCREEN_SIZE
	else:
		position = src_camera.global_position

	get_tree().paused = pause_during_transition
	src_camera.enabled = false
	self.enabled = true

	tween.tween_property(
		self,
		"position",
		target_camera.global_position - 0.5 * SCREEN_SIZE,
		transiton_time)

	tween.tween_callback(
		func():
			get_tree().paused = false
			target_camera.enabled = true
			self.enabled = false
	)
