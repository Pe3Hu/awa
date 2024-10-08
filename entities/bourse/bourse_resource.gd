class_name BourseResource extends Resource


var contracts: Array[ContractResource]
var corporations: Array[CorporationResource]
var compositions: Array[CompositionResource]
var decorations: Dictionary#Array[CompositionResource]


func _init() -> void:
	var a = Time.get_unix_time_from_system()
	Global._ready()
	init_corporations()
	init_contracts()
	#init_compositions()
	init_decorations()
	var b = Time.get_unix_time_from_system()
	print(b - a)
	
func init_corporations() -> void:
	for _i in 1:
		var _corporation = CorporationResource.new(self)
	
func init_contracts() -> void:
	for _i in 1:
		add_contract()
	
func add_contract() -> void:
	var contract_type = roll_contract_type()
	var convoy_size = 4
	var convoy_index = roll_convoy_index(convoy_size)
	var convoy = ConvoyResource.new(convoy_size, convoy_index)
	#var reward = 
	var _contract = ContractResource.new(self, contract_type, convoy)
	
func roll_convoy_index(size_: int) -> int:
	var index = Global.dict.convoy.size[size_][0]#.pick_random()
	return index
	
func roll_contract_type() -> String:
	var type = Global.dict.contract.title.keys()[0]#.pick_random()
	return type
	
func init_compositions() -> void:
	#var convoy_index = 3
	for convoy_index in Global.dict.convoy.index:
		#var conovy_description = Global.dict.convoy.index[convoy_index]
		#var pattern_exceptions = [22, 11]
		var origin_composition = CompositionResource.new(self, convoy_index)
		var pattern_sizes = [5, 4, 3]
		var waves = [
			[origin_composition]
		]
		
		for _i in pattern_sizes.size():
			var child_pattern_size = pattern_sizes[_i]
			var parents = waves[_i]
			var childs = []
			
			for parent in parents:
				var _childs = parent.get_childs_based_on_size(child_pattern_size)
				childs.append_array(_childs)
			
			waves.append(childs)
		
		#var a = waves[pattern_sizes.size()]
		var result = {}
		
		for composition in waves[pattern_sizes.size()]:
			var letters = []
			#print("___", waves[pattern_sizes.size()].find(composition))
			
			for _i in composition.pattern_indexs.size():
				var pattern_description = Global.dict.pattern.index[composition.pattern_indexs[_i]]
				letters.append(pattern_description.acronym[1])
				#print([pattern_description.acronym, composition.pattern_anchors[_i].y * conovy_description.size + composition.pattern_anchors[_i].x, composition.pattern_rotates[_i]])
			
			if !result.has(letters):
				result[letters] = 0
			
			result[letters] += 1
		
		#for letters in result:
		#	print(["convoy_index" + str(convoy_index) + "$",  letters, result[letters]])
	
	
	
					#print(["success", pattern_description.acronym, anchor.y * conovy_description.size + anchor.x, rotates])
				#else:
				#	print(["fail",pattern_description.acronym, anchor.y * conovy_description.size + anchor.x])
	
#func get_pattern_rotates(anchor_: Vector2i, pattern_index_: int, grids_: Array) -> Array:
	#var pattern_description = Global.dict.pattern.index[pattern_index_]
	#var rotates = []
	#
	#for rotate in pattern_description.rotates:
		#var flag = true
		#
		#for patter_grid in pattern_description.rotates[rotate]:
			#var grid = anchor_ + patter_grid
			#
			#if !grids_.has(grid):
				#flag = false
		#
		#if flag:
			#rotates.append(rotate)
	#
	#return rotates
	
func init_decorations() -> void:
	var convoy_size = 5
	var origin_decoration = DecorationResource.new(self, convoy_size)
	origin_decoration.branchs = Global.dict.anchors[convoy_size]
	var limit = 9
	var waves = [
		[origin_decoration]
	]
	
	for _i in range(0, limit, 1):
		var parents = waves[_i]
		var childs = []
		
		for parent in parents:
			for anchor in parent.branchs:
				var child = parent.create_child(anchor)
				
				if child != null:
					childs.append(child)
		
		waves.append(childs)
	
	for _i in range(decorations[limit].size() -1, -1, -1):
		var decoration = decorations[limit][_i]
		decoration.init_segments()
		
		if !Global.dict.segments[convoy_size].has(decoration.segment_lengths):
			decorations[limit].erase(decoration)
		#else:
			#if !decoration.check_pairs():
				#decorations[limit].erase(decoration)
	
	for decoration in decorations[limit]:
		var indexs = []
		
		for grid in decoration.grids:
			indexs.append(grid.y * convoy_size + grid.x)
		
		print([decorations[limit].find(decoration), indexs, decoration.segment_lengths])
	
	print(decorations[limit].size())
