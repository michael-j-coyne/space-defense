extends ProgressBar

func _ready() -> void:
	max_value = PlayerVariables.max_heat
	value = 0
	if not PlayerVariables.has_gatling_gun:
		visible = false

func _process(_delta: float) -> void:
	value = PlayerVariables.gun_heat
