class_name BoardConvoy extends Board


@onready var scene_slot = preload("res://entities/slot/compartment/slot_compartment.tscn")
@onready var scene_token = preload("res://entities/token/compartment/token_compartment.tscn")

@export var resource: ConvoyResource

var anchor_slot: Slot


func _ready() -> void:
	bourse.resource.convoy = resource
	resource.init(bourse.resource)
	
	%Chart.init()
	#resource.calc_all_contracts()
	resource.columns = 4
	%Slots.columns = resource.columns
	
	for y in %Slots.columns:
		for x in %Slots.columns:
			var slot = scene_slot.instantiate()
			var slot_resource = SlotCompartmentResource.new()
			slot_resource.init(Vector2i(x, y))
			%Slots.add_child(slot)
			slot.init(self, slot_resource)
			slot.slot_entered.connect(_on_slot_mouse_entered)
			slot.slot_exit.connect(_on_slot_mouse_exit)
			#slot.grid.x = slot.get_index() % n
			#slot.grid.y = int(float(slot.get_index()) / n)
	
	for specific in resource.specifics:
		var token = scene_token.instantiate()
		var token_resource = TokenCompartmentResource.new()
		token_resource.init(specific.aspect, specific.value)
		token.init(self, token_resource)
		var slot = get_slot(specific.grid)
		slot.token = token
	
func clear() -> void:
	for slot in %Slots.get_children():
		if slot.token == null:
			slot.status = SlotResource.Status.EMPTY
		else:
			slot.status = SlotResource.Status.FILLED
	
func _on_slot_mouse_entered(slot_: Slot) -> void:
	anchor_slot = slot_
	
	if check_pattern(slot_):
		#slot_.status = SlotResource.Status.TEMP
		for patter_grid in bourse.resource.wagon.rotates[bourse.resource.wagon.rotate]:
			var grid = slot_.resource.grid + patter_grid
			var slot = get_slot(grid)
			slot.status = SlotResource.Status.TEMP
	else:
		slot_.status = SlotResource.Status.ERROR
	
func _on_slot_mouse_exit(slot_: Slot) -> void:
	anchor_slot = null
	clear()
	#if slot_.status == SlotResource.Status.TEMP:
		#for patter_grid in bourse.resource.wagon.rotates[bourse.resource.wagon.rotate]:
			#var grid = slot_.resource.grid + patter_grid
			#var slot = get_slot(grid)
			#
			#if slot != null:
				#slot.status = SlotResource.Status.EMPTY
	#else:
		#slot_.status = SlotResource.Status.EMPTY
	
func check_pattern(slot_: Slot) -> bool:
	for patter_grid in bourse.resource.wagon.rotates[bourse.resource.wagon.rotate]:
		var grid = slot_.resource.grid + patter_grid
		
		if !check_on_board(grid):
			return false
		
		var slot = get_slot(grid)
		
		if slot.status != SlotResource.Status.EMPTY:
			return false
	
	return true
