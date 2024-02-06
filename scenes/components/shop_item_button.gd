extends VBoxContainer

@export var price_label: Label
@export var item_label: Label
@export var description_label: Label

var hover_color
var focus_color

func _ready():
	if $ShopItemButton.disabled:
		item_label.modulate = (Color(0.5, 0.5, 0.5))
		price_label.modulate = (Color(0.5, 0.5, 0.5))

	var theme_resource := load(ProjectSettings.get("gui/theme/custom")) as Theme
	hover_color = theme_resource.get_color("font_hover_color", "Button")
	focus_color = theme_resource.get_color("font_focus_color", "Button")

func get_button() -> Button:
	return $ShopItemButton

func set_item_name(item_name: String):
	item_label.text = item_name

func set_price(price: int):
	price_label.text = "$" + str(price)

func set_description(description: String):
	description_label.text = description

func _on_shop_item_button_focus_entered() -> void:
	price_label.add_theme_color_override("font_color", focus_color)
	item_label.add_theme_color_override("font_color", focus_color)

func _on_shop_item_button_focus_exited() -> void:
	price_label.remove_theme_color_override("font_color")
	item_label.remove_theme_color_override("font_color")

func _on_shop_item_button_mouse_entered() -> void:
	price_label.add_theme_color_override("font_color", hover_color)
	item_label.add_theme_color_override("font_color", hover_color)

func _on_shop_item_button_mouse_exited() -> void:
	price_label.remove_theme_color_override("font_color")
	item_label.remove_theme_color_override("font_color")
