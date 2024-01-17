extends Node

var current_level: Level

var shop_inventory = {
	"attack_speed_upgrade": {
		"display_text": "Attack speed +30%",
		"base_price": 100,
		"stock": 2,
		"max_stock": 2,
		"upgrade": func(): PlayerVariables.gun_cooldown *= .7
	},
	"movement_speed_upgrade": {
		"display_text": "Movement Speed +20%",
		"base_price": 100,
		"stock": 2,
		"max_stock": 2,
		"upgrade": func(): PlayerVariables.speed *= 1.2
	},
	"piercing_shot_upgrade": {
		"display_text": "Piercing shots +1",
		"base_price": 300,
		"stock": 3,
		"max_stock": 3,
		"upgrade": func(): PlayerVariables.gun_penetrations += 1
	}
}
