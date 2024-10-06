class_name Wagon extends Board


@onready var scene_slot = preload("res://entities/slot/compartment/slot_compartment.tscn")
@onready var scene_token = preload("res://entities/token/compartment/token_compartment.tscn")

@export var resource: BoardWagonResource


func _ready() -> void:
	resource.Bourse = bourse.resource
	bourse.resource.wagon = resource
	var n = 5
	
	for y in n:
		for x in n:
			var slot = scene_slot.instantiate()
			var slot_resource = SlotCompartmentResource.new()
			slot_resource.init(Vector2i(x, y))
			slot.init(self, slot_resource)
			%Slots.add_child(slot)
	
	resource.index += 1
	update_index()
	
func update_index() -> void:
	%Title.text = resource.title
	%Slots.columns = resource.dimension.x
	update_slots()
	
func update_slots() -> void:
	if bourse.convoy.anchor_slot != null:
		bourse.convoy.clear()
		bourse.convoy._on_slot_mouse_entered(bourse.convoy.anchor_slot)
	
	for _i in %Slots.get_child_count():
		var slot = %Slots.get_child(_i)
		slot.visible = _i < resource.dimension.x * resource.dimension.y
		var x = _i % resource.dimension.x
		var y = int(float(_i) / resource.dimension.x)
		
		if resource.rotates[resource.rotate].has(Vector2i(x, y)):
			slot.status = SlotResource.Status.FILLED
		else:
			slot.status = SlotResource.Status.EMPTY
	
func _input(event) -> void:
	if event is InputEventKey:
		if !event.is_echo() && event.is_pressed():
			match event.keycode:
				KEY_A:
					resource.index -= 1
					update_index()
				KEY_D:
					resource.index += 1
					update_index()
			match event.keycode:
				KEY_Q:
					resource.rotate -= 1
					update_slots()
				KEY_E:
					resource.rotate += 1
					update_slots()
