class_name CompositionResource extends Resource


var bourse: BourseResource
var decoration: DecorationResource
var index: int
var decoration_index: int
var decoration_size: int
var pattern_indexs: Array[int]
var pattern_anchors: Array[Vector2i]
var pattern_rotates: Array[int]
var grids = []
var decoration_grids = []


#func _init(bourse_: BourseResource, decoration_index_: int) -> void:
	#bourse = bourse_
	#decoration_index = decoration_index_
	#decoration = bourse.decorations[decoration_index]
	#init_grids()
	#
#func init_grids() -> void:
	#var description = Global.dict.decoration.index[decoration_index]
	#decoration_size = description.size
	#decoration_grids.append_array(description.grids)
	#grids = Global.dict.anchors[decoration_size].filter(func(a): return !description.grids.has(a))
	
func _init(bourse_: BourseResource, index_: int) -> void:
	bourse = bourse_
	index = index_
	var description = Global.dict.composition.index[index]
	#decoration_size = description.patterns.size() + 1
	decoration = bourse.decorations[description.decoration]
	decoration.compositions.append(self)
	decoration_size = decoration.decoration_size
	#decoration_index = description.decoration
	
	for pattern in description.patterns:
		add_pattern(pattern.index, pattern.anchor, pattern.rotate)
	
	if !bourse.composition_decorations.has(decoration):
		bourse.composition_decorations[decoration] = []
	
	bourse.composition_decorations[decoration].append(self)
	bourse.compositions.append(self)
	
	if !check_fail():
		pass
	
func add_pattern(pattern_index_: int, pattern_anchor_: Vector2i, pattern_rotate_: int) -> void:
	pattern_indexs.append(pattern_index_)
	pattern_anchors.append(pattern_anchor_)
	pattern_rotates.append(pattern_rotate_)
	
	var pattern_description = Global.dict.pattern.index[pattern_index_]
	
	for patter_grid in pattern_description.directions[pattern_rotate_]:
		var grid = pattern_anchor_ + patter_grid
		grids.erase(grid)
	
func create_child(pattern_index_: int, pattern_anchor_: Vector2i, pattern_rotate_: int) -> CompositionResource:
	var child = CompositionResource.new(bourse, decoration_index)
	
	for _i in pattern_indexs.size():
		child.add_pattern(pattern_indexs[_i], pattern_anchors[_i], pattern_rotates[_i])
	
	child.add_pattern(pattern_index_, pattern_anchor_, pattern_rotate_)
	return child
	
func get_pattern_rotates(pattern_index_: int, anchor_: Vector2i) -> Array:
	var pattern_description = Global.dict.pattern.index[pattern_index_]
	var rotates = []
	
	for rotate in pattern_description.directions:
		var flag = true
		
		for patter_grid in pattern_description.directions[rotate]:
			var grid = anchor_ + patter_grid
			
			if !grids.has(grid):
				flag = false
		
		if flag:
			rotates.append(rotate)
	
	return rotates
	
func get_childs_based_on_size(child_size_: int) -> Array:
	var childs = []
	
	for pattern_index in Global.dict.pattern.size[child_size_]:
		for pattern_anchor in grids:#Global.dict.anchors[decoration_size]:
			for pattern_rotate in get_pattern_rotates(pattern_index, pattern_anchor):
				var child = create_child(pattern_index, pattern_anchor, pattern_rotate)
				childs.append(child)
				
				if !child.check_fail():
					pass
	
	return childs
	
func check_draft(draft_: DraftResource) -> bool:
	var uniques = []
	
	for _index in draft_.pattern_indexs:
		if !uniques.has(_index):
			uniques.append(_index)
	
	for _index in uniques:
		if pattern_indexs.count(_index) < draft_.pattern_indexs.count(_index):
			return false
	
	return true
	
func get_pattern_acronyms() -> Array:
	if !check_fail():
		pass
	
	var acronyms = []
	
	for pattern_index in pattern_indexs:
		acronyms.append(Global.dict.pattern.index[pattern_index].acronym)
	
	return acronyms
	
func check_fail() -> bool:
	for pattern_anchor in pattern_anchors:
		if decoration.grids.has(pattern_anchor):
			return false
	
	return true
	
func check_calc_fail() -> bool:
	for pattern_anchor in pattern_anchors:
		if decoration_grids.has(pattern_anchor):
			return false
	
	return true
	
#func order_patterns() -> void:
	#var order = pattern_indexs.duplicate()
	#pass
	#order.sort_custom(func(a, b): return a > b)
	#pattern_indexs.sort_custom(func(a, b): return order.find(pattern_indexs.find(a)) > order.find(pattern_indexs.find(b)))
	#pattern_anchors.sort_custom(func(a, b): return order.find(pattern_anchors.find(a)) > order.find(pattern_anchors.find(b)))
	#pattern_rotates.sort_custom(func(a, b): return order.find(pattern_rotates.find(a)) > order.find(pattern_rotates.find(b)))
	#pass
	
func check_initiative_on_surpluses(initiative_: InitiativeResource) -> bool:
	var counters = {}
	
	for pattern_index in pattern_indexs:
		if !counters.has(pattern_index):
			counters[pattern_index] = 0
		
		counters[pattern_index] += 1
	
	for pattern_index in initiative_.pattern_available_indexes:
		if counters.has(pattern_index):
			counters[pattern_index] -= 1
			
			if counters[pattern_index] == 0:
				counters.erase(pattern_index)
	
	for pattern_index in initiative_.pattern_missing_indexs:
		if !counters.has(pattern_index):
			return false
		elif counters[pattern_index] != 1:
			return false
	
	return true
