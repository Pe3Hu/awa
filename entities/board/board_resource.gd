class_name BoardResource extends Resource


var bourse: BourseResource:
	set = set_bourse
var slots: Array[SlotResource]
var columns: int


func set_bourse(bourse_: BourseResource) -> void:
	bourse = bourse_
	
func get_slot(grid_: Vector2i) -> SlotResource:
	var index = grid_.y * columns + grid_.x
	return slots[index]
	
func check_on_board(grid_: Vector2i) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and grid_.x < columns and grid_.y < columns
