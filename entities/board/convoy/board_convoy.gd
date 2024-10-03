class_name ConvoyBoard extends Board


var coins := []#0, 2, 3, 4, 5]
@export var resource: BoardConvoyResource


func _ready() -> void:
	resource.gui = gui.resource
	gui.resource.convoy = resource
	resource.calc_all_contracts()
	var n = 4
	%Grid.columns = n
	
	#for _i in n * n:
		#var slot := Slot.new()
		#slot.init(self, TokenResource.Type.COMPARTMENT, Vector2(32, 32))
		#%Grid.add_child(slot)
	for slot in %Grid.get_children():
		slot.slot_entered.connect(_on_slot_mouse_entered)
		slot.slot_exit.connect(_on_slot_mouse_exit)
		slot.status = SlotResource.Status.EMPTY
		slot.grid.x = slot.get_index() % n
		slot.grid.y = int(float(slot.get_index()) / n)
	
	for _i in coins.size():
		var token = TokenCompartment.new()
		var _resource = TokenCompartmentResource.new()
		resource.init(TokenResource.CompartmentSubtype.ANY, coins[_i])
		token.init(_resource)
		%Grid.get_child(_i).add_child(token)
		#token.update_value()
	
func _on_slot_mouse_entered(slot_: Slot) -> void:
	if check_pattern(slot_):
		#slot_.status = SlotResource.Status.TEMP
		
		for patter_grid in gui.resource.wagon.rotates[gui.resource.wagon.rotate]:
			var grid = slot_.grid + patter_grid
			var slot = get_slot(grid)
			slot.status = SlotResource.Status.TEMP
	else:
		slot_.status = SlotResource.Status.ERROR
	
func _on_slot_mouse_exit(slot_: Slot) -> void:
	if slot_.status == SlotResource.Status.TEMP:
		for patter_grid in gui.resource.wagon.rotates[gui.resource.wagon.rotate]:
			var grid = slot_.grid + patter_grid
			var slot = get_slot(grid)
			slot.status = SlotResource.Status.EMPTY
	else:
		slot_.status = SlotResource.Status.EMPTY
	
func check_pattern(slot_: Slot) -> bool:
	for patter_grid in gui.resource.wagon.rotates[gui.resource.wagon.rotate]:
		var grid = slot_.grid + patter_grid
		
		if !check_on_board(grid):
			return false
		
		var slot = get_slot(grid)
		
		if slot_.status != SlotResource.Status.EMPTY:
			return false
	return true
