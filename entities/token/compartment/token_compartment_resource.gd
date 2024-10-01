class_name TokenCompartmentResource extends TokenResource


@export var subtype: CompartmentSubtype
@export_range(0, 25, 1) var value: int


func init(subtype_: CompartmentSubtype, value_: int) -> void:
	type = Type.COMPARTMENT
	subtype = subtype_
	value = value_
	texture = load("res://entities/token/images/coin.png")
