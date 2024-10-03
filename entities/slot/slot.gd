class_name Slot extends PanelContainer


signal slot_entered(slot)
signal slot_exit(slot)

@export var board: Board
@export var token: Token
@export var type: TokenResource.Type
@export var status: SlotResource.Status:
	set(status_):
		status = status_
		
		if is_node_ready():
			var style = StyleBoxFlat.new()
			style.bg_color = Global.color.slot[status]
			set("theme_override_styles/panel", style)
			#var style = get("theme_override_styles/panel")
			#style.bg_color = Global.color.slot[status]


func init(board_: Board, type_: TokenResource.Type, cms_: Vector2) -> void:
	board = board_
	type = type_
	custom_minimum_size = cms_
	
func _can_drop_data(_at_position: Vector2, item_: Variant) -> bool:
	if item_ is Token:
		if true:#type == TokenResource.Type.BAG:
			if get_child_count() == 0:
				return true
			else:
				if type == item_.get_parent().type:
					return true
				else: get_child(0).resource.type == item_.resource.type
		else:
			return item_.resource.type == type
	
	return false
	
func _drop_data(_at_position: Vector2, item_: Variant) -> void:
	var keys = ["damage", "defense"]
	
	if get_child_count() > 0:
		var item := get_child(0)
		
		if item == item_:
			return
		
		if true:#type != TokenResource.Type.BAG:
			for key in keys:
				board.gui.change_label(key, -item.resource.get(key))
		
		item.reparent(item_.get_parent())
	
	if item_.get_parent().type == type and true:#type == TokenResource.Type.BAG:
		pass
	else:
		if true:#type != TokenResource.Type.BAG:
			for key in keys:
				board.gui.change_label(key, item_.resource.get(key))
		else:
			for key in keys:
				board.gui.change_label(key, -item_.resource.get(key))
	
	item_.reparent(self)
