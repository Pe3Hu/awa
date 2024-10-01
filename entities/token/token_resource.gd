class_name TokenResource extends Resource


enum Type {COMPARTMENT}
enum CompartmentSubtype {ANY, ENERGY, NETWORK, MOVEMENT, BARRIER, DAMAGE, HACK}


#@export var subtype:
@export var type: Type
@export_multiline var description: String
@export var texture: Texture2D
