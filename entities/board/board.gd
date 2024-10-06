class_name Board extends PanelContainer


@export var bourse: Bourse:
	set = set_bourse


func set_bourse(bourse_: Bourse) -> void:
	bourse = bourse_
	
func get_slot(grid_: Vector2i) -> Slot:
	var index = grid_.y * %Slots.columns + grid_.x
	return %Slots.get_child(index)
	
func check_on_board(grid_: Vector2i) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and grid_.x < %Slots.columns and grid_.y < %Slots.columns
