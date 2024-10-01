class_name WagonBoard extends Board


@export var resource: BoardWagonResource

func _ready() -> void:
	for _i in 5 * 5:
		var slot := Slot.new()
		slot.init(self, TokenResource.Type.COMPARTMENT, Vector2(32, 32))
		%Grid.add_child(slot)
	
	resource.index -= 1
	update_index()
	
func update_index() -> void:
	%Title.text = resource.title
	%Grid.columns = resource.dimension.x
	
	for _i in %Grid.get_child_count():
		var slot = %Grid.get_child(_i)
		slot.visible = _i < resource.dimension.x * resource.dimension.y
		var x = _i % resource.dimension.x
		var y = _i / resource.dimension.x
		
		if resource.grids.has(Vector2i(x, y)):
			slot.status = SlotResource.Status.ACTIVE
		else:
			slot.status = SlotResource.Status.INACTIVE


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
