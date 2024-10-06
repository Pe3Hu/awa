@tool
class_name Token extends TextureRect


@export var board: Board
@export var resource: TokenResource

@export_range(-30, 30, 1) var value: int:
	set(value_):
		value = value_
		%Value.text = str(value)


func _ready() -> void:
	if resource:
		#expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		#stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture = resource.texture
		#tooltip_text = "%s\n%s\nStats: %s Damage, %s Defense" % [resource.name, resource.description]#, resource.damage, resource.defense]
	
func init(board_: Board, resource_: TokenResource) -> void:
	board = board_
	resource = resource_
	value = resource.value
