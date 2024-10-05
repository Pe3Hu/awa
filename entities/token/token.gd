class_name Token extends TextureRect


@export var board: Board
@export var resource: TokenResource


func _ready() -> void:
	if resource:
		#expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		#stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture = resource.texture
		#tooltip_text = "%s\n%s\nStats: %s Damage, %s Defense" % [resource.name, resource.description]#, resource.damage, resource.defense]
	
func init(board_: Board, resource_: TokenResource) -> void:
	board = board_
	resource = resource_
	modulate = Global.color.aspect[resource.aspect]
	update_value()
	
func update_value() -> void:
	%Value.text = str(resource.value)
