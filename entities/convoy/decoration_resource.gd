class_name DecorationResource extends Resource


var bourse: BourseResource
var convoy_size: int
var grids: Array[Vector2i]
var segment_lengths: Array[int]


func _init(bourse_: BourseResource, convoy_size_: int) -> void:
	bourse = bourse_
	convoy_size = convoy_size_
	
func create_child(grid_: Vector2i) -> Variant:
	if grids.has(grid_):
		return null
	
	var child = DecorationResource.new(bourse, convoy_size)
	child.grids.append_array(grids)
	child.grids.append(grid_)
	child.grids.sort_custom(func(a, b): return a.y * convoy_size + a.x < b.y * convoy_size + b.x)
	
	if !bourse.decorations.has(child.grids.size()):
		bourse.decorations[child.grids.size()] = [child]
		return child
	else:
		var flag = true
		var flips = [false, true]
		var rotates = [0, 1, 2, 3]
		
		for flip in flips:
			if flag:
				for rotate in rotates:
					var _grids = []
					
					for grid in child.grids:
						var _grid = Vector2i(grid)
						
						if flip:
							_grid = Global.dict.flips[convoy_size][_grid]
						
						for _i in rotate:
							_grid = Global.dict.rotates[convoy_size][_grid]
						
						_grids.append(_grid)
					
					_grids.sort_custom(func(a, b): return a.y * convoy_size + a.x < b.y * convoy_size + b.x)
					
					for original in bourse.decorations[_grids.size()]:
						if original.grids == _grids:
							flag = false
							break
					
					if !flag:
						break
		
		if flag:
			bourse.decorations[child.grids.size()].append(child)
			return child
	
	return null
	
func init_segments() -> void:
	return
	#var a = Global.dict.anchors[convoy_size]
	#var b = a.filter(func(a): return grids.has(a))
	var options = Global.dict.anchors[convoy_size].filter(func(a): return !grids.has(a))
	var segments = [[options.pop_back()]]
	
	while !options.is_empty():
		
		
		var current_segment = segments.back()
		var next_segment = []
		
		while !current_segment.is_empty():
			for grid in current_segment:
				for direction in Global.dict.direction.linear2:
					var neighbor = grid + direction
					
					if !next_segment.has(neighbor) and options.has(neighbor):
						next_segment.append(neighbor)
			
			#for grid in next_segment:
		
		#var grid = options.pop_back()
		#var flag = false
		#var neighbors = []
		#
		#for segment in segments:
			#if !flag:
				#for neighbor in neighbors:
					#if segment.has(neighbor):
						#flag = true
						#segment.append(grid)
						#break
			#else:
				#break
		#
		#if !flag:
			#segments.append([grid])
	
	for segment in segments:
		segment_lengths.append(segment.size())
	
	#var result = []
	#
	#if true:
		#var indexs = []
			#
		#for grid in grids:
			#indexs.append(grid.y * convoy_size + grid.x)
		#
		#result.append(indexs)
		#
		#
		#var indexs = []
		#
		#for grid in segment:
			#indexs.append(grid.y * convoy_size + grid.x)
		#
		#result.append(indexs)
		#
	#print(result)
	
	#print([indexs, decoration.segment_lengths])
	
func check_border(grid_: Vector2i) -> bool:
	return grid_.x >= 0 and grid_.y >= 0 and grid_.x < convoy_size and grid_.y < convoy_size
	
