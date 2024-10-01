class_name Token extends TextureRect


@export var resource: TokenResource


func _ready() -> void:
	if resource:
		expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture = resource.texture
		#tooltip_text = "%s\n%s\nStats: %s Damage, %s Defense" % [resource.name, resource.description]#, resource.damage, resource.defense]
		
func init(resource_: TokenResource) -> void:
	resource = resource_
	
func _get_drag_data(at_position_: Vector2) -> Variant:
	set_drag_preview(make_drag_preview(at_position_))
	return self
	
func make_drag_preview(at_position_: Vector2) -> Control:
	var t := TextureRect.new()
	t.texture = resource.texture
	t.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	t.custom_minimum_size = size
	t.modulate.a = 0.5
	t.position = Vector2(-at_position_)
	
	var c := Control.new()
	c.add_child(t)
	return c
