@tool
class_name TokenCompartment extends Token


@export var aspect: TokenResource.Aspect:
	set(aspect_):
		aspect = aspect_
		modulate = Color.from_hsv((aspect + 1) / float(8), 1.0, 1.0)


func init(board_: Board, resource_: TokenResource) -> void:
	super.init(board_, resource_)
	aspect = resource_.aspect
