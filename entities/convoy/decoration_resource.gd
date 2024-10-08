class_name DecorationResource extends Resource


var bourse: BourseResource
var convoy_size: int
var grids: Array[Vector2i]
var segment_lengths: Array[int]
var branchs: Array
var chains: Array
var insulations: Array
var chain_size: int = 3


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
	child.chains.append_array(chains)
	#child.insulations.append_array(insulations)
	
	if grids.size() == 1:
		pass
	
	if child.grids.size() % chain_size == 1:
		child.chains.append([grid_])
		
		for direction in Global.dict.direction.linear2:
			var branch = grid_ + direction
			
			if check_border(branch) and !child.insulations.has(branch) and !child.branchs.has(branch):
				child.branchs.append(branch)
	else:
		child.chains[child.chains.size() - 1].append(grid_)
		
		if child.chains.back().size() % chain_size == 0:
			for grid in child.grids:#child.chains.back():
				for direction in Global.dict.direction.linear2:
					var insulation = grid + direction
					
					if check_border(insulation) and !child.insulations.has(insulation) and !child.grids.has(insulation):
						child.insulations.append(insulation)
		
			for direction in Global.dict.direction.diagonal:
				var branch = grid_ + direction
				
				if check_border(branch) and !child.insulations.has(branch):# and !child.branchs.has(branch):
					child.branchs.append(branch)
		else:
			for direction in Global.dict.direction.linear2:
				var branch = grid_ + direction
				
				if check_border(branch) and !child.insulations.has(branch) and !child.branchs.has(branch):
					child.branchs.append(branch)
			
			#for direction in Global.dict.direction.hybrid:
				#var branch = grid + direction
				#
				#if check_border(branch) and !child.grids.has(branch) and !child.branchs.has(branch):
					#child.branchs.append(branch)
	
	#if !child.check_chain():
	#	return null
	
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
	var options = Global.dict.anchors[convoy_size].filter(func(a): return !grids.has(a))
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
	return grid_.x >= 0 and grid_.y >= 0 and grid_.x < convoy_size and grid_.y < convoy_size
	
func check_links() -> bool:
	var links = [grids.back()]
	var options = grids.filter(func(a): return !links.has(a))
	var flag = true
	
	while flag:
		flag = false
		
		for _i in range(links.size()-1,-1,-1):
			var link = links[_i]
		
			for direction in Global.dict.direction.hybrid:
				var neighbor = link + direction
				
				if options.has(neighbor):
					links.append(neighbor)
					options.erase(neighbor)
					flag = true
	
	return links.size() == grids.size()
	
func check_chains() -> bool:
	var datas = []
	
	for grid in grids:
		var data = {}
		data.grid = grid
		data.neighbors = []
		
		for direction in Global.dict.direction.linear2:
			var neighbor = grid + direction
			
			if grids.has(neighbor):
				data.neighbors.append(neighbor)
		
		datas.append(data)
	
	while !datas.is_empty():
		datas.sort_custom(func(a, b): return a.neighbors.size() > b.neighbors.size())
		var data = datas.pop_back()
		
		if data.neighbors.is_empty():
			return false
		
		var neighbor = data.neighbors.pick_random()
		var pair = [data.grid, neighbor]
		
		for _i in range(datas.size()-1,-1,-1):
			var _data = datas[_i]
			
			if _data.grid == neighbor:
				datas.erase(_data)
			else:
				_data.neighbors = _data.neighbors.filter(func (a): return !pair.has(a))
	
	return true



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
