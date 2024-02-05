extends VBoxContainer

@export var price_label: Label
@export var item_label: Label
@export var description_label: Label

func _ready():
	if $ShopItemButton.disabled:
		item_label.modulate = (Color(0.5, 0.5, 0.5))
		price_label.modulate = (Color(0.5, 0.5, 0.5))

func get_button() -> Button:
	return $ShopItemButton

func set_item_name(item_name: String):
	item_label.text = " " + item_name

func set_price(price: int):
	price_label.text = "$" + str(price) + " "

func set_description(description: String):
	description_label.text = "  " + description
