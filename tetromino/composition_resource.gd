class_name CompositionResource extends Resource


enum Shape {I, L, O, T, Z}

var bourse: BourseResource
var index: int

var pattern_indexs: Array[int]
var pattern_anchors: Array[Vector2i]

var occupied_grids: Array[Vector2i]
var branchs: Array[Vector2i]

var shape_grids: Dictionary
var shape_indexs: Dictionary

var segment_lengths: Array[int]


#func _init(bourse_: BourseResource, index_: int) -> void:
	#bourse = bourse_
	#index = index_
	#var description = Global.dict.decoration.index[index]
	#bourse.dimension = description.size
	#grids.append_array(description.grids)
	#
	#for grid in grids:
		#var _index = bourse.dimension * grid.y + grid.x
		#indexs.append(_index)
	#
	#if !bourse.bourse.dimensions.has(bourse.dimension):
		#bourse.bourse.dimensions = []
	#
	#bourse.bourse.dimensions.append(self)
	#bourse.decorations.append(self)
	
func _init(bourse_: BourseResource) -> void:
	bourse = bourse_
	
func create_child(pattern_index_: int, pattern_anchor_: Vector2i) -> Variant:
	if occupied_grids.has(pattern_anchor_):
		return null
	
	var child = CompositionResource.new(bourse)
	child.pattern_indexs.append_array(pattern_indexs.duplicate())
	child.pattern_anchors.append_array(pattern_anchors.duplicate())
	
	child.occupied_grids.append_array(occupied_grids.duplicate())
	
	if !pattern_indexs.is_empty():
		child.branchs.append_array(branchs.duplicate())
		
		for shape in shape_grids:
			child.shape_grids[shape] = shape_grids[shape].duplicate()
			child.shape_indexs[shape] = shape_indexs[shape].duplicate()
	
	child.pattern_indexs.append(pattern_index_)
	child.pattern_anchors.append(pattern_anchor_)
	
	var description = Global.dict.pattern.index[pattern_index_]
	
	for pattern_direction in description.directions:
		var grid = pattern_anchor_ + pattern_direction
		
		if !check_border(grid) or child.occupied_grids.has(grid):
			return null
		
		child.occupied_grids.append(grid)
		
		if !child.shape_grids.has(description.shape):
			child.shape_grids[description.shape] = []
			child.shape_indexs[description.shape] = []
		
		if child.shape_grids[description.shape].has(grid):
			pass
		
		child.shape_grids[description.shape].append(grid)
		child.shape_indexs[description.shape].append(grid.y * bourse.dimension + grid.x)
		child.branchs.erase(grid)
	
	for shape in child.shape_indexs:
		child.shape_indexs[shape].sort()
		child.shape_grids[shape].sort_custom(func(a, b): return a.y * bourse.dimension + a.x < b.y * bourse.dimension + b.x)
	
	if pattern_indexs.is_empty():
		for grid in child.occupied_grids:
			for direction in Global.dict.direction.linear2:
				var branch = grid + direction
				
				if check_border(branch) and !child.branchs.has(branch) and !child.occupied_grids.has(branch):
					child.branchs.append(branch)
		
		pass
	else:
		for pattern_direction in description.directions:
			for branch_direction in Global.dict.direction.linear2:
				var branch = pattern_anchor_ + pattern_direction + branch_direction
				
				if check_border(branch) and !child.branchs.has(branch) and !child.occupied_grids.has(branch):
					child.branchs.append(branch)
	
	if !bourse.calced_compositions.has(child.pattern_indexs.size()):
		return child
	else:
		var flag = true
		var flips = [false, true]
		var rotates = [0, 1, 2, 3]
		
		for flip in flips:
			if flag:
				for rotate in rotates:
					var _shape_grids = {}
					
					for shape in child.shape_grids:
						_shape_grids[shape] = []
						
						for grid in child.shape_grids[shape]:
							var _grid = Vector2i(grid)
							
							if flip:
								_grid = Global.dict.flips[_grid]
							
							for _i in rotate:
								_grid = Global.dict.rotates[_grid]
							
							_shape_grids[shape].append(_grid)
			
						_shape_grids[shape].sort_custom(func(a, b): return a.y * bourse.dimension + a.x < b.y * bourse.dimension + b.x)
			
					for original in bourse.calced_compositions[child.pattern_indexs.size()]:
						if original.shape_grids == _shape_grids:
							flag = false
							break
							
							if !flag:
								break
		
		if flag:
			return child
		
		#var flag = true
		#
		#for related_pattern_index in Global.dict.pattern.shape[description.shape]:
			#var related_description = Global.dict.pattern.index[related_pattern_index]
			#var _shape_grids = {}
			#
			#for shape in child.shape_grids:
				#_shape_grids[shape] = []
				#
				#for grid in child.shape_grids[shape]:
					#var _grid = Vector2i(grid)
					#
					#if related_description.is_fliped:
						#_grid = Global.dict.flips[_grid]
					#
					#for _i in related_description.rotate:
						#_grid = Global.dict.rotates[_grid]
					#
					#_shape_grids[shape].append(_grid)
			#
				#_shape_grids[shape].sort_custom(func(a, b): return a.y * bourse.dimension + a.x < b.y * bourse.dimension + b.x)
			#
			#for original in bourse.calced_compositions[child.pattern_indexs.size()]:
				#if original.shape_grids == _shape_grids:
					#flag = false
					#break
			#
			#if !flag:
				#break
		#
		#if flag:
			#return child
	
	return null
	
func init_segments() -> void:
	var options = Global.arr.anchor.filter(func(a): return !occupied_grids.has(a))
	var segments = []
	
	while !options.is_empty():
		var new_segment = [options.pop_back()]
		var current_wave = []
		current_wave.append_array(new_segment)
		var next_wave = []
		
		while !current_wave.is_empty():
			for grid in current_wave:
				for direction in Global.dict.direction.linear2:
					var neighbor = grid + direction
					
					if !next_wave.has(neighbor) and options.has(neighbor):
						next_wave.append(neighbor)
			
			current_wave.clear()
			current_wave.append_array(next_wave)
			options = options.filter(func(a): return !next_wave.has(a))
			new_segment.append_array(next_wave)
			next_wave.clear()
		
		segments.append(new_segment)
	
	for segment in segments:
		segment_lengths.append(segment.size())
	
	segment_lengths.sort_custom(func(a, b): return a > b)
	
func check_border(grid_: Vector2i) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and grid_.x < bourse.dimension and grid_.y < bourse.dimension
