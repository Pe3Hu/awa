class_name ConvoyBoard extends Board


var coins := []#0, 2, 3, 4, 5]


func _ready() -> void:
	for _i in 5 * 5:
		var slot := Slot.new()
		slot.init(self, TokenResource.Type.COMPARTMENT, Vector2(32, 32))
		%Grid.add_child(slot)
	
	for _i in coins.size():
		var token = TokenCompartment.new()
		var resource = TokenCompartmentResource.new()
		resource.init(TokenResource.CompartmentSubtype.ANY, coins[_i])
		token.init(resource)
		%Grid.get_child(_i).add_child(token)
		#token.update_value()
