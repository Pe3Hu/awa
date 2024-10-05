class_name Slot extends PanelContainer


signal slot_entered(slot)
signal slot_exit(slot)

@export var board: Board
@export var token: Token:
	set(token_):
		token = token_
		
		if is_node_ready() and token != null:
			add_child(token)
			status = SlotResource.Status.FILLED
@export var resource: SlotResource
@export var status: SlotResource.Status:
	set(status_):
		status = status_
		
		if is_node_ready():
			var style = StyleBoxFlat.new()
			style.bg_color = Global.color.slot[status]
			set("theme_override_styles/panel", style)
			#var style = get("theme_override_styles/panel")
			#style.bg_color = Global.color.slot[status]

#var grid: Vector2i


func init(board_: Board, resource_: SlotResource) -> void:
	board = board_
	resource = resource_
	status = SlotResource.Status.EMPTY
