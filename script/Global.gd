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
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	
func init_arr() -> void:
	pass
	
func init_num() -> void:
	num.index = {}
	
func init_dict() -> void:
	init_pattern()
	
func init_pattern() -> void:
	dict.pattern = {}
	dict.pattern.index = {}
	dict.pattern.size = {}
	var exceptions = ["index", "grids"]
	
	var path = "res://entities/board/wagon/pattern.json"
	var array = load_data(path)
	
	for pattern in array:
		pattern.index = int(pattern.index)
		pattern.size = int(pattern.size)
		pattern.flip = int(pattern.flip)
		var data = {}
		data.title = str(pattern.size) + pattern.letter.to_upper() + str(pattern.flip)
		data.grids = []
		data.dimension = Vector2i()
		
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
		dict.pattern.index[pattern.index] = data
		
		if !dict.pattern.size.has(pattern.size):
			dict.pattern.size[pattern.size] = []
	
		dict.pattern.size[pattern.size].append(pattern.index)
	
func init_vec():
	vec.size = {}
	vec.size.sixteen = Vector2(16, 16)
	
	init_window_size()
	
func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)
	
func init_color():
	#var h = 360.0
	
	color.slot = {}
	color.slot[SlotResource.Status.ACTIVE] = Color.GREEN
	color.slot[SlotResource.Status.INACTIVE] = Color.RED
	pass
	
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
