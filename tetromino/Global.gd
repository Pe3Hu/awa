extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	if dict.keys().is_empty():
		init_arr()
		init_color()
		init_dict()
	
	#get_tree().bourse.resource.after_init()
	
func init_arr() -> void:
	arr.shape = ["i", "l", "o", "t", "z"]
	arr.aspect_designation = ["energy", "network", "payload", "speed", "barrier", "hack", "stealth", "firepower"]
	arr.primary = [
		TokenResource.Aspect.ENERGY,
		TokenResource.Aspect.NETWORK,
		TokenResource.Aspect.PAYLOAD,
		TokenResource.Aspect.SPEED
	]
	arr.secondary = [
		TokenResource.Aspect.BARRIER,
		TokenResource.Aspect.HACK,
		TokenResource.Aspect.STEALTH,
		TokenResource.Aspect.FIREPOWER
	]
	
	arr.aspect = []
	arr.aspect.append_array(arr.primary)
	arr.aspect.append_array(arr.secondary)
	
func init_dict() -> void:
	init_direction()
	init_also()
	
	init_pattern()
	init_decoration()
	
func init_direction() -> void:
	dict.direction = {}
	dict.direction.linear2 = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	dict.direction.diagonal = [
		Vector2i( 1,-1),
		Vector2i( 1, 1),
		Vector2i(-1, 1),
		Vector2i(-1,-1)
	]
	
	dict.direction.hybrid = []
	
	for _i in dict.direction.linear2.size():
		var direction = dict.direction.linear2[_i]
		dict.direction.hybrid.append(direction)
		direction = dict.direction.diagonal[_i]
		dict.direction.hybrid.append(direction)
	
func init_also() -> void:
	dict.status = {}
	dict.status.next = {}
	dict.status.next[WagonResource.Status.REPAIRING] = WagonResource.Status.SHOWCASING
	dict.status.next[WagonResource.Status.SHOWCASING] = WagonResource.Status.OPERATING
	dict.status.next[WagonResource.Status.OPERATING] = WagonResource.Status.REPAIRING
	
	arr.condition = [
		[-2, -1, 4, 5],
		[-1, 1, 2, 4],
		[0, 1, 2, 3]
	]
	
	arr.segment = [
		[12],
		[8],
		[8, 4],
		[4, 4],
		[4],
		[]
	]
	
	var size = 4
	arr.anchor = []
	arr.start = [
		Vector2i(0, 0),
		Vector2i(1, 0),
		Vector2i(1, 1)
	]
	
	for y in size:
		for x in size:
			arr.anchor.append(Vector2i(x, y))
	
	dict.flips = {}
	dict.rotates = {}
	
	for grid in arr.anchor:
		dict.flips[grid] = Vector2i(abs(grid.x - (size - 1)), grid.y)
		var y = grid.x
		var x = abs(grid.y - (size - 1))
		dict.rotates[grid] = Vector2i(x, y)
	
func init_pattern() -> void:
	dict.pattern = {}
	dict.pattern.index = {}
	dict.pattern.shape = {}
	var exceptions = ["index"]
	var unique_directions = []
	
	var path = "res://entities//pattern/pattern.json"
	var array = load_data(path)
	
	for pattern in array:
		pattern.index = int(pattern.index)
		pattern.shape = CompositionResource.Shape.keys()[arr.shape.find(pattern.shape)]
		var data = {}
		data.directions = [] 
		
		for key in pattern:
			if !exceptions.has(key):
				
				if key == "directions":
					var directions =  pattern.directions.split(";")
					
					for _direction in directions:
						var direction = str_to_var("Vector2i" + _direction)
						data.directions.append(direction)
				else:
					data[key] = pattern[key]
		
		if !dict.pattern.shape.has(data.shape):
			dict.pattern.shape[data.shape] = []
	
		dict.pattern.shape[data.shape].append(pattern.index)
		dict.pattern.index[pattern.index] = data
	
func init_decoration() -> void:
	dict.decoration = {}
	dict.decoration.index = {}
	dict.decoration.shape = {}
	var exceptions = ["index"]
	var unique_directions = []
	var n = 4
	
	var path = "res://entities//decoration/decoration.json"
	var array = load_data(path)
	
	for decoration in array:
		decoration.index = int(decoration.index)
		var shapes = []
		var arr_0 = decoration.indexs.split("\\")
		
		for _i in arr_0:
			var arr_1 = _i.split(";")
			var _data = {}
			_data.shape = CompositionResource.Shape.keys()[arr.shape.find(arr_1[0])]
			_data.indexs = []
			_data.grids = []
			var arr_2 = arr_1[1].split(",")
			
			for _j in arr_2:
				var index = int(_j)
				var x = index % n
				var y = float(index) / n
				var grid = Vector2i(x, int(y))
				_data.indexs.append(index)
				_data.grids.append(grid)
			
			shapes.append(_data)
		
		var shape = shapes[0].shape
		
		if !dict.decoration.shape.has(shape):
			dict.decoration.shape[shape] = []
	
		dict.decoration.shape[shape].append(decoration.index)
		dict.decoration.index[decoration.index] = shapes
	
func init_color():
	#var h = 360.0
	
	color.aspect = {}
	for _i in arr.aspect.size():
		color.aspect[arr.aspect[_i]] = Color.from_hsv((_i + 1) / float(arr.aspect.size()), 1.0, 1.0)
	
	#color.aspect[TokenResource.Aspect.NETWORK] = Color.from_hsv(160 / h, 0.8, 0.5)
	#color.aspect[TokenResource.Aspect.ENERGY] = Color.from_hsv(60 / h, 0.9, 0.9)
	#color.aspect[TokenResource.Aspect.SPEED] = Color.from_hsv(35 / h, 0.9, 0.9)
	#color.aspect[TokenResource.Aspect.PAYLOAD] = Color.from_hsv(0 / h, 0.0, 0.7)
	#color.aspect[TokenResource.Aspect.HACK] = Color.from_hsv(280 / h, 0.9, 0.9)
	#color.aspect[TokenResource.Aspect.FIREPOWER] = Color.from_hsv(0 / h, 0.9, 0.9)
	#color.aspect[TokenResource.Aspect.BARRIER] = Color.from_hsv(210 / h, 0.9, 0.9)
	#color.aspect[TokenResource.Aspect.STEALTH] = Color.from_hsv(115 / h, 0.9, 0.7)
	
func save(path_: String, data_): #: String
	var file = FileAccess.open(path_, FileAccess.WRITE)
	file.store_string(data_)
	
func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var _parse_err = json_object.parse(text)
	return json_object.get_data()
	
func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
	
func get_all_combinations_based_on_size(array_: Array, size_: int) -> Array:
	var combinations = {}
	combinations[0] = array_.duplicate()
	combinations[1] = []
	
	for child in array_:
		combinations[1].append([child])
	
	for _i in size_ - 1:
		set_combinations_based_on_size(combinations, _i + 2)
	
	return combinations[size_]
	
func set_combinations_based_on_size(combinations_: Dictionary, size_: int) -> void:
	var parents = combinations_[size_ - 1]
	combinations_[size_] = []
	
	for parent in parents:
		for child in combinations_[0]:
			if !parent.has(child):
				var combination = []
				combination.append_array(parent)
				combination.append(child)
				combination.sort_custom(func(a, b): return combinations_[0].find(a) < combinations_[0].find(b))
				
				if !combinations_[size_].has(combination):
					combinations_[size_].append(combination)
	
func get_str_aspect(aspect_: TokenResource.Type) -> String:
	return TokenResource.Aspect.keys()[aspect_].to_lower().capitalize()



#func init_pattern1() -> void:
	#dict.pattern = {}
	#dict.pattern.index = {}
	#dict.pattern.shape = {}
	#var exceptions = ["index", "directions"]
	#var unique_directions = []
	#
	#var path = "res://entities//pattern/pattern.json"
	#var array = load_data(path)
	#
	#for pattern in array:
		#pattern.index = int(pattern.index)
		#pattern.flip = int(pattern.flip)
		#var data = {}
		#data.dimension = Vector2i()
		#data.grids = {}
		#data.directions = {}
		#
		#for key in pattern:
			#if !exceptions.has(key):
				#data[key] = pattern[key]
		#
		#var directions = pattern.directions.split(";")
		#data.grids[0] = []
		#
		#for _grid in directions:
			#var grid = str_to_var("Vector2i" + _grid)
			#data.grids[0].append(grid)
			#
			#if data.dimension.x < grid.x:
				#data.dimension.x = grid.x
			#
			#if data.dimension.y < grid.y:
				#data.dimension.y = grid.y
		#
		#data.dimension += Vector2i.ONE
		#data.dimension = Vector2i.ONE * max(data.dimension.x, data.dimension.y)
		#
		##print(data.title)
		#for _i in range(0, 4, 1):
			#if _i > 0:
				#data.grids[_i] = []
				#var anchor = Vector2i.ONE * max(data.dimension.x, data.dimension.y)
				#
				#for grid in data.grids[_i - 1]:
					#var y = grid.x
					#var x = data.dimension.x - grid.y - 1
					#var rotated_grid = Vector2i(x, y)
					#data.grids[_i].append(rotated_grid)
					#
					#if anchor.x > x:
						#anchor.x = x
					#if anchor.y > y:
						#anchor.y = y
			#
				#if anchor != Vector2i.ZERO:
					#for _j in data.grids[_i].size():
						#data.grids[_i][_j] -= anchor
		#
		#for _i in data.grids:
			#data.directions[_i] = []
			#
			#for grid in data.grids[_i]:
				#data.directions[_i].append(grid - data.grids[_i].front())
			#
			#if !unique_directions.has(data.directions[_i]):
				#unique_directions.append(data.directions[_i])
				#var _data = {}
				#_data.shape = CompositionResource.Shape.keys()[arr.shape.find(pattern.letter)]
				#_data.rotate = _i
				#_data.is_fliped = pattern.flip != 0
				#_data.directions = data.directions[_i]
			#
				#if !dict.pattern.shape.has(_data.shape):
					#dict.pattern.shape[_data.shape] = []
			#
				#dict.pattern.shape[_data.shape].append(dict.pattern.index.keys().size())
				#dict.pattern.index[dict.pattern.index.keys().size()] = _data
	

#func init_pattern2() -> void:
	#dict.pattern = {}
	#dict.pattern.index = {}
	#dict.pattern.shape = {}
	#dict.pattern.shape = {}
	#var exceptions = ["index", "directions"]
	#var unique_directions = []
	#
	#var path = "res://entities//pattern/pattern.json"
	#var array = load_data(path)
	#
	#for pattern in array:
		#pattern.index = int(pattern.index)
		#var data = {}
		#data.dimension = Vector2i()
		#data.grids = {}
		#
		#for key in pattern:
			#if !exceptions.has(key):
				#data[key] = pattern[key]
		#
		#var directions = pattern.directions.split(";")
		#data.grids[0] = []
		#
		#for _grid in directions:
			#var grid = str_to_var("Vector2i" + _grid)
			#data.grids[0].append(grid)
			#
			#if data.dimension.x < grid.x:
				#data.dimension.x = grid.x
			#
			#if data.dimension.y < grid.y:
				#data.dimension.y = grid.y
		#
		#data.dimension += Vector2i.ONE
		#data.dimension = Vector2i.ONE * max(data.dimension.x, data.dimension.y)
		#
		##print(data.title)
		#for _i in range(0, 4, 1):
			#if _i > 0:
				#data.grids[_i] = []
				#var anchor = Vector2i.ONE * max(data.dimension.x, data.dimension.y)
				#
				#for grid in data.grids[_i - 1]:
					#var y = grid.x
					#var x = data.dimension.x - grid.y - 1
					#var rotated_grid = Vector2i(x, y)
					#data.grids[_i].append(rotated_grid)
					#
					#if anchor.x > x:
						#anchor.x = x
					#if anchor.y > y:
						#anchor.y = y
			#
				#if anchor != Vector2i.ZERO:
					#for _j in data.grids[_i].size():
						#data.grids[_i][_j] -= anchor
			#
			#data.grids[_i].sort_custom(func(a, b): return a.y * data.dimension.x + a.x  < b.y * data.dimension.x + b.x)
			#
			#if !dict.pattern.shape.has(data.grids[_i]):
				#var shape = {}
				#shape.index = pattern.index
				#shape.rotate = _i
				#dict.pattern.shape[data.grids[_i]] = shape
		##var 
		#
		#dict.pattern.index[pattern.index] = data
		#
		#if !dict.pattern.shape.has(_data.shape):
			#dict.pattern.shape[_data.shape] = []
	#
		#dict.pattern.shape[_data.shape].append(pattern.index)
	#var a = dict.pattern
	#pass
	
