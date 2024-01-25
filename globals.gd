extends Node

var current_level_idx: int
var current_level: Level
var shop_inventory

func _ready():
	reset()

var attack_speed_upgrade = ShopItem.new(
	"Attack speed +50%",
	"Shoot faster. Who can hate that?",
	300,
	2,
	2,
	5,
	func(): PlayerVariables.gun_cooldown *= .5)

var movement_speed_upgrade = ShopItem.new(
	"Movement Speed +50%",
	"\"Gotta go fast!\"",
	300,
	2,
	2,
	5,
	func(): PlayerVariables.speed *= 1.5)

var piercing_shot_upgrade = ShopItem.new(
	"Piercing shots +1",
	"Destroy two ships with one laser!",
	300,
	3,
	3,
	5,
	func(): PlayerVariables.gun_penetrations += 1)

var gatling_gun_upgrade = ShopItem.new(
	"Gatling Gun",
	"Now that's just plain fun.",
	2000,
	1,
	1,
	10,
	func(): PlayerVariables.has_gatling_gun = true)

func reset():
	shop_inventory = {
		"attack_speed_upgrade": attack_speed_upgrade,
		"movement_speed_upgrade": movement_speed_upgrade,
		"piercing_shot_upgrade": piercing_shot_upgrade,
		"gatling_gun_upgrade": gatling_gun_upgrade,
	}

	current_level = null
	current_level_idx = 0
