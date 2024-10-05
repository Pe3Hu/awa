class_name TokenResource extends Resource


enum Type {COMPARTMENT}
enum Aspect {ENERGY, NETWORK, PAYLOAD, SPEED, BARRIER, HACK, STEALTH, FIREPOWER}

@export var type: Type
@export var aspect: Aspect
@export_multiline var description: String
@export var texture: Texture2D
@export_range(-25, 25, 1) var value: int


func init(aspect_: Aspect, value_: int) -> void:
	type = Type.COMPARTMENT
	aspect = aspect_
	value = value_
	texture = load("res://entities/token/images/coin.png")
	
