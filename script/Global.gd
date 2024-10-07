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
	
	init_pattern()
	init_wagon()
	init_contract()
	init_convoy()
	
func init_direction() -> void:
	dict.direction = {}
	dict.direction.linear2 = [
		Vector2i( 0,-1),
		Vector2i( 1, 0),
		Vector2i( 0, 1),
		Vector2i(-1, 0)
	]
	
func init_pattern() -> void:
	dict.pattern = {}
	dict.pattern.index = {}
	dict.pattern.size = {}
	var exceptions = ["index", "grids"]
	
	var path = "res://entities//wagon/pattern.json"
	var array = load_data(path)[0]
	
	for pattern in array:
		pattern.index = int(pattern.index)
		pattern.size = int(pattern.size)
		pattern.flip = int(pattern.flip)
		var data = {}
		data.acronym = str(pattern.size) + pattern.letter.to_upper() + str(pattern.flip)
		data.grids = []
		data.dimension = Vector2i()
		data.rotates = {}
		
		for key in pattern:
			if !exceptions.has(key):
				data[key] = pattern[key]
		
		var grids = pattern.grids.split(";")
		
		for _grid in grids:
			var grid = str_to_var("Vector2i" + _grid)
			data.grids.append(grid)
			
			if data.dimension.x < grid.x:
				data.dimension.x = grid.x
			
			if data.dimension.y < grid.y:
				data.dimension.y = grid.y
		
		data.dimension += Vector2i.ONE
		data.dimension = Vector2i.ONE * max(data.dimension.x, data.dimension.y)
		data.rotates[0] = data.grids.duplicate()
		
		#print(data.title)
		for _i in range(1, 4, 1):
			data.rotates[_i] = []
			var anchor = Vector2i.ONE * max(data.dimension.x, data.dimension.y)
			
			for grid in data.rotates[_i - 1]:
				var y = grid.x
				var x = data.dimension.x - grid.y - 1
				var rotated_grid = Vector2i(x, y)
				data.rotates[_i].append(rotated_grid)
				
				if anchor.x > x:
					anchor.x = x
				if anchor.y > y:
					anchor.y = y
		
			if anchor != Vector2i.ZERO:
				#print(_i, " anchor ", anchor)
				for _j in data.rotates[_i].size():
					data.rotates[_i][_j] -= anchor
		
		dict.pattern.index[pattern.index] = data
		
		if !dict.pattern.size.has(pattern.size):
			dict.pattern.size[pattern.size] = []
	
		dict.pattern.size[pattern.size].append(pattern.index)
	
func init_wagon() -> void:
	dict.wagon = {}
	dict.wagon.title = {}
	dict.wagon.size = {}
	var exceptions = ["title", "size"]
	
	var path = "res://entities//wagon/wagon.json"
	var array = load_data(path)
	
	for wagon in array:
		var data = {}
		data.aspects = {}
		data.size = int(wagon.size)
		
		for key in wagon:
			if !exceptions.has(key):
				var index = arr.aspect_designation.find(key)
				var aspect = arr.aspect[index]
				data.aspects[aspect] = wagon[key]
		
		dict.wagon.title[wagon.title] = data
		
		if !dict.wagon.size.has(data.size):
			dict.wagon.size[data.size] = []
	
		dict.wagon.size[data.size].append(wagon.title)
	
func init_contract() -> void:
	dict.contract = {}
	dict.contract.title = {}
	dict.contract.aspect = {}
	var exceptions = ["title"]
	
	var path = "res://entities//convoy/contract.json"
	var array = load_data(path)
	
	for contract in array:
		var data = {}
		data.aspects = {}
		
		for key in contract:
			if !exceptions.has(key):
				var index = arr.aspect_designation.find(key)
				var aspect = arr.aspect[index]
				data.aspects[aspect] = contract[key]
		
		dict.contract.title[contract.title] = data
		
		for aspect in data.aspects:
			if !dict.contract.aspect.has(aspect):
				dict.contract.aspect[aspect] = []
			
			dict.contract.aspect[aspect].append(contract.title)
	
func init_convoy() -> void:
	dict.convoy = {}
	dict.convoy.index = {}
	dict.convoy.size = {}
	var exceptions = ["index"]
	
	var path = "res://entities//convoy/convoy.json"
	var array = load_data(path)
	
	for convoy in array:
		convoy.index = int(convoy.index)
		convoy.size = int(convoy.size)
		var data = {}
		data.grids = []
		
		for key in convoy:
			if !exceptions.has(key):
				if key == "indexs":
					var words = convoy[key].split(",")
					#data[key] = []
					
					for word in words:
						#data[key].append(int(word))
						var x = int(word) % convoy.size
						var y = int(float(int(word)) / convoy.size)
						var grid = Vector2i(x, y)
						data.grids.append(grid)
				else:
					data[key] = convoy[key]
		
		dict.convoy.index[convoy.index] = data
		
		if !dict.convoy.size.has(convoy.size):
			dict.convoy.size[convoy.size] = []
			
		dict.convoy.size[convoy.size].append(convoy.index)
	
	dict.condition = {}
	dict.condition.size = {}
	dict.condition.size[4] = [
		[-2, -1, 4, 5],
		[-1, 1, 2, 4],
		[0, 1, 2, 3]
	]
	
	var sizes = [4, 5]
	dict.anchors = {}
	
	for size in sizes:
		dict.anchors[size] = []
		
		for y in size:
			for x in size:
				dict.anchors[size].append(Vector2i(x, y))
	
	dict.flips = {}
	dict.rotates = {}
	
	for size in sizes:
		dict.flips[size] = {}
		dict.rotates[size] = {}
		
		for grid in dict.anchors[size]:
			dict.flips[size][grid] = Vector2i(abs(grid.x - (size - 1)), grid.y)
			var y = grid.x
			var x = abs(grid.y - (size - 1))
			dict.rotates[size][grid] = Vector2i(x, y)
	
	dict.segments = {}
	dict.segments[4] = [
		[9, 3],
		[8, 4],
		[7, 5]
	]
	dict.segments[5] = [
		[14, 3],
		[13, 4],
		[12, 5],
		[10, 7],
		[9, 8],
		[10, 4, 3],
		[9, 5, 3],
		[9, 4, 4],
	]
	#var k = 5
	#for grid in dict.flips[k]:
		#print([grid.x + grid.y * k, dict.flips[k][grid].x + dict.flips[k][grid].y * k])
	#pass
	
func init_color():
	#var h = 360.0
	
	color.slot = {}
	color.slot[SlotResource.Status.EMPTY] = Color.GHOST_WHITE
	color.slot[SlotResource.Status.FILLED] = Color.SLATE_GRAY
	color.slot[SlotResource.Status.TEMP] = Color.SLATE_GRAY
	color.slot[SlotResource.Status.ERROR] = Color.DIM_GRAY
	
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
	
func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
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
	
func get_all_combinations(array_: Array) -> Array:
	var combinations = {}
	combinations[0] = array_.duplicate()
	combinations[1] = []
	
	for child in array_.front():
		combinations[1].append([child])
	
	for _i in array_.size() - 1:
		set_combinations_based_on_size(combinations, _i + 2)
	
	return combinations[array_.size()]
	
func set_combinations_based_on_size(combinations_: Dictionary, size_: int) -> void:
	var parents = combinations_[size_-1]
	combinations_[size_] = []
	
	for parent in parents:
		for child in combinations_[0][size_ - 1]:
			if !parent.has(child):
				var combination = []
				combination.append_array(parent)
				combination.append(child)
				combination.sort_custom(func(a, b): return combinations_[0].find(a) < combinations_[0].find(b))
				
				if !combinations_[size_].has(combination):
					combinations_[size_].append(combination)
	
func get_str_aspect(aspect_: TokenResource.Type) -> String:
	return TokenResource.Aspect.keys()[aspect_].to_lower().capitalize()
