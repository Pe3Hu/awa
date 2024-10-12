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
	init_shape()
	
	init_pattern()
	init_wagon()
	init_contract()
	init_decoration()
	init_composition()
	init_draft()
	
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
	
func init_shape() -> void:
	dict.status = {}
	dict.status.next = {}
	dict.status.next[WagonResource.Status.REPAIRING] = WagonResource.Status.SHOWCASING
	dict.status.next[WagonResource.Status.SHOWCASING] = WagonResource.Status.OPERATING
	dict.status.next[WagonResource.Status.OPERATING] = WagonResource.Status.REPAIRING
	
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
		[12],
		[9, 3],
		[8, 4],
		[7, 5]
	]
	dict.segments[5] = [
		[15, 3],
		[14, 4],
		[12, 6],
		[11, 7],
		[10, 8],
		[9, 9],
		[11, 4, 3],
		[9, 5, 4],
		[8, 6, 4],
		[7, 7, 4],
		[7, 6, 5]
	]
	
	dict.lengths = {}
	dict.lengths[4] = [
		[5, 4, 3],
		[4, 4, 4]
	]
	dict.lengths[5] = [
		[5, 5, 5, 3],
		[5, 5, 4, 4],
		[5, 4, 3, 3, 3],
		[4, 4, 4, 3, 3]
	]
	
	dict.drafts = [
		[5, 5, 0],
		[5, 4, 0],
		[4, 4, 0],
		[5, 4, 3],
		[5, 3, 3],
		[4, 4, 4],
		[4, 4, 3],
		[4, 3, 3],
		[3, 3, 3]
	]
	#dict.drafts = [
		#[3, 3, 3]
	#]
	
	#dict.segments[5] = [
		#[17],
		#[14, 3],
		#[13, 4],
		#[12, 5],
		#[10, 7],
		#[9, 8],
		#[10, 4, 3],
		#[9, 5, 3],
		#[9, 4, 4],
	#]
	
	#dict.segments[5] = [
		#[16],
		#[13, 3],
		#[12, 4],
		#[11, 5],
		#[9, 7],
		#[8, 8],
		#[10, 3, 3],
		#[9, 4, 3],
		#[8, 5, 3],
		#[8, 4, 4],
		#[7, 5, 4],
		#[6, 5, 5],
		#[5, 5, 3, 3],
		#[5, 4, 4, 3],
		#[4, 4, 4, 4]
	#]
	
	#dict.lengths[5] = [
		#[5, 5, 3, 3],
		#[5, 4, 4, 3],
		#[4, 4, 4, 4]
	#]
	
	
	#dict.segments[5] = [
		#[19],
		#[16, 3],
		#[15, 4],
		#[14, 5],
		#[13, 6],
		#[12, 7],
		#[11, 8],
		#[10, 9],
		#[10, 3, 3]
	#]
	
	#dict.lengths[5] = [
		#[5, 5, 5, 4],
		#[5, 5, 3, 3, 3],
		#[5, 4, 4, 3, 3],
		#[4, 4, 4, 4, 3]
	#]
	
	#var k = 5
	#for grid in dict.flips[k]:
		#print([grid.x + grid.y * k, dict.flips[k][grid].x + dict.flips[k][grid].y * k])
	#pass
	
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
		data.dimension = Vector2i()
		data.shapes = {}
		data.directions = {}
		
		for key in pattern:
			if !exceptions.has(key):
				data[key] = pattern[key]
		
		var grids = pattern.grids.split(";")
		data.shapes[0] = []
		
		for _grid in grids:
			var grid = str_to_var("Vector2i" + _grid)
			data.shapes[0].append(grid)
			
			if data.dimension.x < grid.x:
				data.dimension.x = grid.x
			
			if data.dimension.y < grid.y:
				data.dimension.y = grid.y
		
		data.dimension += Vector2i.ONE
		data.dimension = Vector2i.ONE * max(data.dimension.x, data.dimension.y)
		
		#print(data.title)
		for _i in range(1, 4, 1):
			data.shapes[_i] = []
			var anchor = Vector2i.ONE * max(data.dimension.x, data.dimension.y)
			
			for grid in data.shapes[_i - 1]:
				var y = grid.x
				var x = data.dimension.x - grid.y - 1
				var rotated_grid = Vector2i(x, y)
				data.shapes[_i].append(rotated_grid)
				
				if anchor.x > x:
					anchor.x = x
				if anchor.y > y:
					anchor.y = y
		
			if anchor != Vector2i.ZERO:
				#print(_i, " anchor ", anchor)
				for _j in data.shapes[_i].size():
					data.shapes[_i][_j] -= anchor
		
		for _i in data.shapes:
			data.directions[_i] = []
			
			for grid in data.shapes[_i]:
				data.directions[_i].append(grid - data.shapes[_i].front())
			
		
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
	
func init_decoration() -> void:
	dict.decoration = {}
	dict.decoration.index = {}
	dict.decoration.size = {}
	var exceptions = ["index"]
	
	var path = "res://entities//decoration/decoration.json"
	var array = load_data(path)
	
	for decoration in array:
		decoration.index = int(decoration.index)
		decoration.size = int(decoration.size)
		var data = {}
		data.grids = []
		
		for key in decoration:
			if !exceptions.has(key):
				if key == "indexs":
					var words = decoration[key].split(";")
					#data[key] = []
					
					for word in words:
						#data[key].append(int(word))
						var x = int(word) % decoration.size
						var y = int(float(int(word)) / decoration.size)
						var grid = Vector2i(x, y)
						data.grids.append(grid)
				else:
					data[key] = decoration[key]
		
		dict.decoration.index[decoration.index] = data
		
		if !dict.decoration.size.has(decoration.size):
			dict.decoration.size[decoration.size] = []
			
		dict.decoration.size[decoration.size].append(decoration.index)
	
	#dict.decoration.index = {}
	#dict.decoration.size = {}
	
func init_composition() -> void:
	dict.composition = {}
	dict.composition.index = {}
	dict.composition.size = {}
	dict.composition.decoration = {}
	
	var path = "res://entities//composition/composition.json"
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	
	for str_0 in text.rsplit(";"):
		var arr_1 = str_0.rsplit("/")
		
		if arr_1.size() > 1:
			var data = {}
			var index = int(arr_1[0])
			data.decoration = int(arr_1[1])
			data.patterns = []
			var decoration_size = Global.dict.decoration.index[data.decoration].size
			
			for _i in arr_1.size():
				if _i > 1:
					var arr_2 = arr_1[_i].rsplit(",")
					var pattern = {}
					pattern.index = int(arr_2[0])
					var anchor_index = int(arr_2[1])
					pattern.rotate = int(arr_2[2])
					var x = anchor_index % decoration_size
					var y = int(float(anchor_index) / decoration_size)
					pattern.anchor = Vector2i(x ,y)
					data.patterns.append(pattern)
			
			data.patterns.sort_custom(func(a, b): return a.index < b.index)
			
			if !dict.composition.decoration.has(data.decoration):
				dict.composition.decoration[data.decoration] = []
			
			dict.composition.decoration[data.decoration].append(index)
			
			dict.composition.index[index] = data
	
func init_draft() -> void:
	dict.draft = {}
	dict.draft.index = {}
	
	var path = "res://entities//decoration/draft.json"
	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	
	for str_0 in text.rsplit(";"):
		var arr_1 = str_0.rsplit("/")
		
		if arr_1.size() > 1:
			var data = {}
			var index = int(arr_1[0])
			data.patterns = []
			data.compositions = []
			var arr_2 = arr_1[1].rsplit(",")
			
			for _i in arr_2.size():
				data.patterns.append(int(arr_2[_i]))
			
			arr_2 = arr_1[2].rsplit(",")
			
			for _i in arr_2.size():
				data.compositions.append(int(arr_2[_i]))
			
			dict.draft.index[index] = data
	
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
