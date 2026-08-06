extends Node2D

@onready var label_name = $UI/ItemPopup/Control/RichTextLabel2
@onready var label_description = $UI/ItemPopup/Control/RichTextLabel
@onready var label_rarity = $UI/ItemPopup/Control/RichTextLabel3
@onready var label_price = $UI/ItemPopup/Control/RichTextLabel4

func item_poup(slot: Rect2i, item):
	if item == null:
		return
	var data = JsonData.item_data[item.item_name]
	var rarity = str(JsonData.item_data[item.item_name].get("Rarity", ""))
	label_name.text = item.item_name.capitalize()
	label_description.text = str(data.get("Description", ""))
	label_price.text = "Price: " + str(int(data.get("Price", "")))
	if rarity == "Common":
		label_rarity.text = rarity
		label_rarity.set("theme_override_colors/default_color", Color(1.0, 1.0, 1.0, 1.0))
	elif rarity == "Uncommon":
		label_rarity.text = rarity
		label_rarity.set("theme_override_colors/default_color", Color(0.188, 1.0, 0.251, 1.0))
	elif rarity == "Rare":
		label_rarity.text = rarity
		label_rarity.set("theme_override_colors/default_color", Color(0.153, 0.706, 1.0, 1.0))
	elif rarity == "Epic":
		label_rarity.text = rarity
		label_rarity.set("theme_override_colors/default_color", Color(0.824, 0.416, 0.792, 1.0))
	elif rarity == "Legendary":
		label_rarity.text = "[wave]Legendary[wave]"
		label_rarity.set("theme_override_colors/default_color", Color(1.0, 0.698, 0.0, 1.0))

	else:
		label_rarity.text = "[pulse]???[pulse]"
		label_rarity.set("theme_override_colors/default_color", Color())
		label_rarity.set("theme_override_colors/font_outline_color", Color(1.0, 1.0, 1.0))
		label_rarity.set("theme_override_constants/outline_size", 3)
	var padding = 8
	var correction = -Vector2i(%ItemPopup.size.x + padding, 0)
	%ItemPopup.popup(Rect2i(slot.position + correction, %ItemPopup.size))

func hide_item_popup():
	%ItemPopup.hide()
