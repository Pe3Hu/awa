class_name CompositionResource extends Resource


#var convoy: ConvoyResource
#var wagons: Array[WagonResource]
var bourse: BourseResource
var convoy_index: int
var convoy_size: int
var pattern_indexs: Array[int]
var pattern_anchors: Array[Vector2i]
var pattern_rotates: Array[int]
var grids = []


func _init(bourse_: BourseResource, convoy_index_: int) -> void:
	bourse = bourse_
	convoy_index = convoy_index_
	init_grids()
	
func init_grids() -> void:
	var conovy_description = Global.dict.convoy.index[convoy_index]
	convoy_size = conovy_description.size
	
	for y in convoy_size:
		for x in convoy_size:
			var grid = Vector2i(x, y)
			
			if !conovy_description.grids.has(grid):
				grids.append(grid)
	
func add_pattern(pattern_index_: int, pattern_anchor_: Vector2i, pattern_rotate_: int) -> void:
	pattern_indexs.append(pattern_index_)
	pattern_anchors.append(pattern_anchor_)
	pattern_rotates.append(pattern_rotate_)
	
	var pattern_description = Global.dict.pattern.index[pattern_index_]
	
	for patter_grid in pattern_description.rotates[pattern_rotate_]:
		var grid = pattern_anchor_ + patter_grid
		grids.erase(grid)
	
func create_child(pattern_index_: int, pattern_anchor_: Vector2i, pattern_rotate_: int) -> CompositionResource:
	var child = CompositionResource.new(bourse, convoy_index)
	
	for _i in pattern_indexs.size():
		child.add_pattern(pattern_indexs[_i], pattern_anchors[_i], pattern_rotates[_i])
	
	child.add_pattern(pattern_index_, pattern_anchor_, pattern_rotate_)
	return child
	
func get_pattern_rotates(pattern_index_: int, anchor_: Vector2i) -> Array:
	var pattern_description = Global.dict.pattern.index[pattern_index_]
	var rotates = []
	
	for rotate in pattern_description.rotates:
		var flag = true
		
		for patter_grid in pattern_description.rotates[rotate]:
			var grid = anchor_ + patter_grid
			
			if !grids.has(grid):
				flag = false
		
		if flag:
			rotates.append(rotate)
	
	return rotates
	
func get_childs_based_on_size(child_size_: int) -> Array:
	var childs = []
	
	for pattern_index in Global.dict.pattern.size[child_size_]:
		for pattern_anchor in Global.dict.anchors[convoy_size]:
			for pattern_rotate in get_pattern_rotates(pattern_index, pattern_anchor):
				var child = create_child(pattern_index, pattern_anchor, pattern_rotate)
				childs.append(child)
	
	return childs
