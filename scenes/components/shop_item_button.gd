class_name ShopItemButton extends Button

func _ready():
	if disabled:
		$HBoxContainer/ItemLabel.modulate = (Color(0.5, 0.5, 0.5))
		$HBoxContainer/PriceLabel.modulate = (Color(0.5, 0.5, 0.5))

func set_item_name(name: String):
	$HBoxContainer/ItemLabel.text = " " + name

func set_price(price: int):
	$HBoxContainer/PriceLabel.text = "$" + str(price) + " "
