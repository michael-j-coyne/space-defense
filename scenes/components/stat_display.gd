extends PanelContainer

@export var attack_speed_val: Label
@export var move_speed_val: Label

var gun_cooldown: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not PlayerVariables:
		return

	if PlayerVariables.gun_cooldown:
		attack_speed_val.text = "%.2f shots / sec" % (1.0 / PlayerVariables.gun_cooldown)
		gun_cooldown = PlayerVariables.gun_cooldown

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not PlayerVariables:
		return
	if PlayerVariables.gun_cooldown and gun_cooldown:

		if PlayerVariables.gun_cooldown != gun_cooldown:
			var difference = (1.0 / PlayerVariables.gun_cooldown) - (1.0 / gun_cooldown)
			stat_upgrade_effect(difference, attack_speed_val)
			gun_cooldown = PlayerVariables.gun_cooldown

func stat_upgrade_effect(difference, target):
	print(difference)
