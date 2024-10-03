class_name WagonBoard extends Board


@export var resource: BoardWagonResource


func _ready() -> void:
	resource.gui = gui.resource
	gui.resource.wagon = resource
	var n = 5
	
	for _i in n * n:
		var slot := Slot.new()
		slot.init(self, TokenResource.Type.COMPARTMENT, Vector2(32, 32))
		%Grid.add_child(slot)
	
	resource.index -= 1
	update_index()
	
func update_index() -> void:
	%Title.text = resource.title
	%Grid.columns = resource.dimension.x
	update_slots()
	
func update_slots() -> void:
	for _i in %Grid.get_child_count():
		var slot = %Grid.get_child(_i)
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
