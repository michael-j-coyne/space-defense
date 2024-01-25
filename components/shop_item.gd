class_name ShopItem extends RefCounted

var display_text: String = ""
var description: String = ""
var base_price: int = 0
var	stock: int = 0
var	max_stock: int = 0
var	price_multiplier: int = 0
var	apply_upgrade: Callable

func _init(display_text, description, base_price, stock, max_stock, price_multiplier, apply_upgrade):
	self.display_text = display_text
	self.description = description
	self.base_price = base_price
	self.stock = stock
	self.max_stock = max_stock
	self.price_multiplier = price_multiplier
	self.apply_upgrade = apply_upgrade
