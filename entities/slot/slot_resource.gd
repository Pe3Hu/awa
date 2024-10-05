class_name SlotResource extends Resource


enum Status {EMPTY, FILLED, TEMP, ERROR}

var status: Status
var grid: Vector2i


func init(grid_: Vector2i) -> void:
	grid = grid_
	status = Status.EMPTY
