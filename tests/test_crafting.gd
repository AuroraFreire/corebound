extends Node

var failures = 0

func _ready() -> void:
	var inv = preload("res://scenes/inventory.tscn").instantiate()
	add_child(inv)
	var craft = inv.get_node("CraftingGrid")
	var out = inv.get_node("OutputSlot")
	var bag = inv.get_node("GridContainer")

	# --- shapeless: 2 moss + 1 water anywhere = Medkit ---
	craft.get_child(0).add_item("AzureMoss", 1)
	craft.get_child(4).add_item("AzureMoss", 1)
	craft.get_child(8).add_item("PureWater", 5)
	inv.update_crafting_output()
	check("shapeless medkit matches", out.item != null and out.item.item_name == "Medkit")

	# --- taking output consumes recipe amounts ---
	inv.take_from_output()
	check("crafted item goes to hand", inv.holding_item != null and inv.holding_item.item_name == "Medkit")
	check("single ingredients consumed", craft.get_child(0).item == null and craft.get_child(4).item == null)
	check("stacked ingredient decremented", craft.get_child(8).item != null and craft.get_child(8).item.item_quantity == 4)
	check("output cleared when recipe broken", out.item == null)
	inv.holding_item.queue_free()
	inv.holding_item = null
	clear_grid(inv, craft)

	# --- big stacks in one cell still count, only recipe amount consumed ---
	craft.get_child(0).add_item("AzureMoss", 91)
	craft.get_child(1).add_item("PureWater", 3)
	inv.update_crafting_output()
	check("big single stack matches shapeless", out.item != null and out.item.item_name == "Medkit")
	inv.take_from_output()
	check("big stack only loses recipe amount", craft.get_child(0).item != null and craft.get_child(0).item.item_quantity == 89)
	check("water stack decremented once", craft.get_child(1).item != null and craft.get_child(1).item.item_quantity == 2)
	inv.holding_item.queue_free()
	inv.holding_item = null
	clear_grid(inv, craft)

	# --- amounts spread across cells drain in order ---
	craft.get_child(0).add_item("AzureMoss", 1)
	craft.get_child(1).add_item("AzureMoss", 5)
	craft.get_child(2).add_item("PureWater", 1)
	inv.update_crafting_output()
	check("spread stacks match shapeless", out.item != null and out.item.item_name == "Medkit")
	inv.take_from_output()
	check("spread consume drains cells in order", craft.get_child(0).item == null and craft.get_child(1).item.item_quantity == 4)
	inv.holding_item.queue_free()
	inv.holding_item = null
	clear_grid(inv, craft)

	# --- extra item type = no match ---
	craft.get_child(0).add_item("AzureMoss", 2)
	craft.get_child(1).add_item("PureWater", 1)
	craft.get_child(2).add_item("AzureStone", 1)
	inv.update_crafting_output()
	check("extra ingredient type rejected", out.item == null)
	clear_grid(inv, craft)

	# --- wrong combo = no output ---
	craft.get_child(0).add_item("AzureMoss", 1)
	craft.get_child(1).add_item("AzureStone", 1)
	inv.update_crafting_output()
	check("junk combo crafts nothing", out.item == null)
	clear_grid(inv, craft)

	# --- shaped: moss/water checkerboard around stone = AzureCrystal ---
	var crystal_layout = ["AzureMoss", "PureWater", "AzureMoss", "PureWater", "AzureStone", "PureWater", "AzureMoss", "PureWater", "AzureMoss"]
	for i in 9:
		craft.get_child(i).add_item(crystal_layout[i], 3)
	inv.update_crafting_output()
	check("crystal checkerboard matches", out.item != null and out.item.item_name == "AzureCrystal")
	inv.take_from_output()
	check("crystal craft consumes one per cell", craft.get_child(0).item.item_quantity == 2 and craft.get_child(4).item.item_quantity == 2)
	inv.holding_item.queue_free()
	inv.holding_item = null
	clear_grid(inv, craft)

	# --- same items, wrong arrangement = no match ---
	crystal_layout[0] = "PureWater"
	crystal_layout[1] = "AzureMoss"
	for i in 9:
		craft.get_child(i).add_item(crystal_layout[i], 1)
	inv.update_crafting_output()
	check("scrambled checkerboard rejected", out.item == null)
	clear_grid(inv, craft)

	# --- shaped recipes slide anywhere in the grid (test-only 2-cell recipe) ---
	JsonData.recipe_data.append({"Result": "PureWater", "Count": 1, "Type": "Shaped", "Pattern": [["AzureMoss"], ["AzureStone"]]})
	craft.get_child(3).add_item("AzureMoss", 40)
	craft.get_child(6).add_item("AzureStone", 7)
	inv.update_crafting_output()
	check("shaped matches offset position with stacks", out.item != null and out.item.item_name == "PureWater")
	clear_grid(inv, craft)

	craft.get_child(0).add_item("AzureMoss", 1)
	craft.get_child(4).add_item("AzureStone", 1)
	inv.update_crafting_output()
	check("diagonal placement rejected", out.item == null)
	clear_grid(inv, craft)
	JsonData.recipe_data.pop_back()

	# --- full 3x3 shaped: stone ring around water = OxygenTank ---
	for i in 9:
		if i == 4:
			craft.get_child(i).add_item("PureWater", 1)
		else:
			craft.get_child(i).add_item("AzureStone", 2)
	inv.update_crafting_output()
	check("3x3 ring recipe matches", out.item != null and out.item.item_name == "OxygenTank")
	inv.take_from_output()
	check("ring craft leaves stone remainder", craft.get_child(0).item != null and craft.get_child(0).item.item_quantity == 1)
	check("ring craft consumes center water", craft.get_child(4).item == null)
	inv.holding_item.queue_free()
	inv.holding_item = null
	clear_grid(inv, craft)

	# --- right click: grab half / drop one ---
	bag.get_child(0).add_item("AzureMoss", 91)
	rclick(inv, bag.get_child(0))
	check("right click grabs half (rounded up)", inv.holding_item != null and inv.holding_item.item_quantity == 46)
	check("right click leaves half in slot", bag.get_child(0).item.item_quantity == 45)
	rclick(inv, bag.get_child(1))
	rclick(inv, bag.get_child(1))
	check("right click drops one at a time", bag.get_child(1).item != null and bag.get_child(1).item.item_quantity == 2)
	check("hand shrinks as singles dropped", inv.holding_item.item_quantity == 44)
	rclick(inv, bag.get_child(0))
	check("right click tops up existing stack", bag.get_child(0).item.item_quantity == 46 and inv.holding_item.item_quantity == 43)

	# --- right click into crafting slot updates recipe ---
	rclick(inv, craft.get_child(0))
	rclick(inv, craft.get_child(1))
	check("right click fills crafting cells", craft.get_child(0).item.item_quantity == 1 and craft.get_child(1).item.item_quantity == 1)
	craft.get_child(2).add_item("PureWater", 1)
	inv.update_crafting_output()
	check("right click built a valid recipe", out.item != null and out.item.item_name == "Medkit")
	inv.holding_item.queue_free()
	inv.holding_item = null
	clear_grid(inv, craft)

	# --- right click with 1 in slot picks the whole thing ---
	bag.get_child(2).add_item("PureWater", 1)
	rclick(inv, bag.get_child(2))
	check("right click on single item takes it", inv.holding_item != null and bag.get_child(2).item == null)
	inv.holding_item.queue_free()
	inv.holding_item = null

	if failures == 0:
		print("ALL TESTS PASSED")
	else:
		print(str(failures) + " TESTS FAILED")
	get_tree().quit(failures)

func check(label, cond):
	if cond:
		print("PASS: " + label)
	else:
		failures += 1
		print("FAIL: " + label)

func rclick(inv, slot):
	var ev = InputEventMouseButton.new()
	ev.button_index = MOUSE_BUTTON_RIGHT
	ev.pressed = true
	inv.slot_gui_input(ev, slot)

func clear_grid(inv, craft):
	for craft_slot in craft.get_children():
		if craft_slot.item:
			craft_slot.item.free()
			craft_slot.item = null
	inv.update_crafting_output()
