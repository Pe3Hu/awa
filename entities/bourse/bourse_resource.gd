class_name BourseResource extends Resource


var contracts: Array[ContractResource]
var corporations: Array[CorporationResource]
var decorations: Array[DecorationResource]
var compositions: Array[CompositionResource]
var drafts: Array[DraftResource]

var decoration_origins: Dictionary
var composition_origins: Array[CompositionResource]
var draft_origins: Array[DraftResource]

var decoration_sizes: Dictionary
var composition_decorations: Dictionary
var pattern_drafts: Dictionary


func _init() -> void:
	var a = Time.get_unix_time_from_system()
	Global._ready()
	#calc_decorations()
	init_decorations()
	
	#calc_compositions()
	init_compositions()
	
	#calc_drafts()
	init_drafts()
	
	init_contracts()
	init_corporations()
	
	corporations[0].hangar.finish_charging_wagons()
	corporations[0].init_initiatives()
	#
	var b = Time.get_unix_time_from_system()
	print(b - a)
	
func init_corporations() -> void:
	for _i in 1:
		var _corporation = CorporationResource.new(self)
	
func init_contracts() -> void:
	var decoration_size = 5
	
	for _i in 3:
		add_contract(decoration_size)
	
func add_contract(decoration_size_: int) -> void:
	var contract_type = roll_contract_type()
	var decoration_index = roll_decoration_index(decoration_size_)
	var decoration = decorations[decoration_index]
	#var reward = 
	#var Statistic = 
	var _contract = ContractResource.new(self, contract_type, decoration)
	
func roll_decoration_index(decoration_size_: int) -> int:
	var index = Global.dict.decoration.size[decoration_size_][contracts.size()]#.pick_random()
	return index
	
func roll_contract_type() -> String:
	var type = Global.dict.contract.title.keys()[contracts.size()]#.pick_random()
	return type
	
func calc_decorations() -> void:
	var _decoration_sizes = [5]#[4, 5]
	var _decoration_limits = [7]#[4, 6]
	
	for _i in _decoration_sizes.size():
		var decoration_size = _decoration_sizes[_i]
		var decoration_limit = _decoration_limits[_i]
		decoration_origins[decoration_size] = []
		
		var origin_decoration = DecorationResource.new(self, decoration_size)
		origin_decoration.branchs.append_array(Global.dict.anchors[decoration_size])
		var waves = [
			[origin_decoration]
		]
		
		for _j in range(0, decoration_limit, 1):
			var parents = waves[_j]
			var childs = []
			
			for parent in parents:
				for anchor in parent.branchs:
					var child = parent.create_child(anchor)
					
					if child != null:
						if !decoration_origins.has(child.grids.size()):
							decoration_origins[child.grids.size()] = []
						
						decoration_origins[child.grids.size()].append(child)
						childs.append(child)
			
			waves.append(childs)
		
		for _j in waves[decoration_limit].size():
		#for _j in range(waves[decoration_limit].size() -1, -1, -1):
			var decoration = waves[decoration_limit][_j]
			decoration.init_segments()
			
			if Global.dict.segments[decoration_size].has(decoration.segment_lengths):
				#decorations[decoration_size].append(decoration)
				decorations.append(decoration)
	
	var index = 0
	for decoration_size in _decoration_sizes:
	#	Global.dict.decoration.size[decoration_size] = []
	
		for decoration in decorations:
			var data = {}
			data.size = decoration_size
			data.grids = decoration.grids
			data.indexs = []
			#var indexs = []
			
			for grid in decoration.grids:
				data.indexs.append(grid.y * decoration_size + grid.x)
			
			Global.dict.decoration.index[index] = data
			Global.dict.decoration.size[decoration_size].append(index)
			print([index, data.indexs, decoration.segment_lengths])
			index += 1
			##
		##
		#print(decorations[decoration_size].size())
	
func calc_compositions() -> void:
	var _decoration_sizes = [4, 5]#[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 ,21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34
	var _decoration_indexs = [[0, 1], [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 14, 15, 16, 17, 18, 19, 20 ,21, 22]]#, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34]]
	var _counters = {}
	
	#for decoration_size in Global.dict.decoration.size:
	#	for decoration_index in Global.dict.decoration.size[decoration_size]:
			#if decoration_index < 10:
				#break
	
	for _k in _decoration_sizes.size():
		var decoration_size = _decoration_sizes[_k]
		
		for decoration_index in _decoration_indexs[_k]:
			var _decoration_description = Global.dict.decoration.index[decoration_index]
			#print(decoration_description.indexs)
			#var pattern_exceptions = [22, 11]
			
			for pattern_sizes in Global.dict.lengths[decoration_size]:
				var origin_composition = CompositionResource.new(self, decoration_index)
				#var pattern_sizes = [5, 5, 3, 3]#[5, 4, 3]
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
				
				composition_origins.append_array(waves[pattern_sizes.size()])
				
				#if !waves[pattern_sizes.size()].is_empty():
				#	print([decoration_index, Global.dict.lengths[decoration_size].find(pattern_sizes), waves[pattern_sizes.size()].size()])
	
	#var result = {}
	#
	#for composition in compositions:
		#for pattern_index in composition.pattern_indexs:
			#if !counters.has(pattern_index):
				#counters[pattern_index] = 0
			#
			#counters[pattern_index] += 1
				
				#var letters = []
				#print("___", waves[pattern_sizes.size()].find(composition))
				
				#for _i in composition.pattern_indexs.size():
					#var pattern_description = Global.dict.pattern.index[composition.pattern_indexs[_i]]
					#letters.append(pattern_description.acronym[1])
				#if !result.has(letters):
					#result[letters] = 0
				#
				#result[letters] += 1
			#
			#for letters in result:
				#print(["decoration_index" + str(decoration_index) + "$",  letters, result[letters]])
	
	#print(compositions.size())
	#for pattern_index in Global.dict.pattern.index:
		#if counters.has(pattern_index):
			#var pattern_description = Global.dict.pattern.index[pattern_index]
			#print([pattern_description.acronym, counters[pattern_index]])
	
	#if true:
	#	return
	
	print(composition_origins.size())
	var save_string = ""
	#var datas = []
	#print(compositions.size())
	
	for composition in composition_origins:
		var orders = composition.pattern_indexs.duplicate()
		orders.sort_custom(func(a, b): return a > b)
	
		var data = {}
		data.index = composition_origins.find(composition)
		data.decoration = composition.decoration_index
		var string = str(data.index) + "/" + str(data.decoration) + "/"
		data.patterns = []
		
		for order in orders:
			var _i = composition.pattern_indexs.find(order)
			var pattern = []
			var anchor_index = composition.pattern_anchors[_i].y * composition.decoration_size + composition.pattern_anchors[_i].x
			pattern.append_array([composition.pattern_indexs[_i], anchor_index, composition.pattern_rotates[_i]])
			
			string += str(pattern[0]) + "," + str(pattern[1]) + "," + str(pattern[2]) + "/"
			#for _index in pattern:
				#string += str(_index)
				#
				#if pattern.find(_index) != pattern.size() - 1:
					#string += ","
				#else:
					#string +=  "/"
			#data.patterns.append(pattern)
		
		string = string.erase(string.length() - 1)
		string += ";"
		save_string += string
		#datas.append(data)
	
	var path = "res://entities/composition/composition.json"
	Global.save(path, save_string)
	
func init_decorations() -> void:
	for index in Global.dict.decoration.index:
		var _decoration = DecorationResource.new(self, index)
	
	#print(decorations.size())
	
func init_compositions() -> void:
	for index in Global.dict.composition.index:
		var _composition = CompositionResource.new(self, index)
	
	#print(compositions.size())
	
func calc_drafts() -> void:
	for pattern_sizes in Global.dict.drafts:
		var pattern_indexs = {}
		pattern_indexs[2] = [null]
		pattern_indexs[0] = Global.dict.pattern.size[pattern_sizes[0]]
		pattern_indexs[1] = Global.dict.pattern.size[pattern_sizes[1]]
		
		if pattern_sizes[2] > 0:
			pattern_indexs[2] = Global.dict.pattern.size[pattern_sizes[2]]
		
		for pattern_0 in pattern_indexs[0]:
			for pattern_1 in pattern_indexs[1]:
				for pattern_2 in pattern_indexs[2]:
					var patterns = [pattern_0, pattern_1]
					
					if pattern_2 != null:
						patterns.append(pattern_2)
					
					var _draft = DraftResource.new(self, patterns)
	
	print(draft_origins.size())
	
	var save_string = ""
	#var datas = []
	#print(compositions.size())
	#draft_origins = [draft_origins.front()]
	
	for draft in draft_origins:
		var data = {}
		data.index = draft_origins.find(draft)
		data.patterns = draft.pattern_indexs.duplicate()
		var string = str(data.index) + "/"
		data.compositions = []
		
		for pattern_index in draft.pattern_indexs:
			string += str(pattern_index) + ","
			
		string = string.erase(string.length() - 1)
		string += "/"
		
		for composition in draft.compositions:
			string += str(composition.index) + ","
		
		string = string.erase(string.length() - 1)
		string += ";"
		save_string += string
		#datas.append(data)
	
	var path = "res://entities/decoration/draft.json"
	Global.save(path, save_string)
	
	#drafts.sort_custom(func(a, b): return a.compositions.size() < b.compositions.size())
	#var draft = drafts.front()
	#var _decorations = {}
	#var letters = []
	#
	#for pattern_index in draft.pattern_indexs:
		#var pattern_description = Global.dict.pattern.index[pattern_index]
		#letters.append(pattern_description.acronym)
	#
	#print(letters)
	#
	#for composition in draft.compositions:
		#if !_decorations.has(composition.decoration):
			#_decorations[composition.decoration] = 0
		#
		#_decorations[composition.decoration] += 1
	#
	#for decoration in _decorations:
		#var indexs = []
			#
		#for grid in decoration.grids:
			#indexs.append(grid.y * decoration.decoration_size + grid.x)
		#print(indexs)
	
func init_drafts() -> void:
	for index in Global.dict.draft.index:
		var _draft = DraftResource.new(self, index)
	
	#print(drafts.size())




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
	
