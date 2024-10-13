class_name BourseResource extends Resource


var corporations: Array[CorporationResource]
var compositions: Array[CompositionResource]

var calced_compositions: Dictionary

const dimension: int = 4
const dimensions: Vector2i = Vector2i(dimension, dimension)



func _init() -> void:
	var a = Time.get_unix_time_from_system()
	Global._ready()
	init_corporations()
	calc_compositions()
	
	
	#
	var b = Time.get_unix_time_from_system()
	print(b - a)
	
func init_corporations() -> void:
	for _i in 1:
		var _corporation = CorporationResource.new(self)
	
func calc_compositions() -> void:
	var origin_composition = CompositionResource.new(self)
	origin_composition.branchs.append(Vector2i())
	var waves = [
		[origin_composition]
	]
	
	var d = Global.dict.pattern.index
	var k = 4
	
	for _i in range(0, k, 1):
		var parents = waves[_i]
		var childs = []
		
		for parent in parents:
			for pattern_index in Global.dict.pattern.index:
				for anchor in parent.branchs:
					var child = parent.create_child(pattern_index, anchor)
					
					if child != null:
						child.init_segments()
						
						if Global.arr.segment.has(child.segment_lengths):
							if !calced_compositions.has(child.pattern_indexs.size()):
								calced_compositions[child.pattern_indexs.size()] = []
							
							calced_compositions[child.pattern_indexs.size()].append(child)
							childs.append(child)
		
		waves.append(childs)
	
	return
	
	var a = waves[k]
	
	for composition in waves[k]:
		print([composition.pattern_indexs, composition.shape_indexs])
	
	for _j in waves[dimension].size():
	#for _j in range(waves[dimension].size() -1, -1, -1):
		var composition = waves[dimension][_j]
		composition.init_segments()
		
		if Global.dict.segments[dimension].has(composition.segment_lengths):
			#compositions[dimension].append(composition)
			compositions.append(composition)
	
	#var index = 0
	#for dimension in _dimensions:
	##	Global.dict.composition.size[dimension] = []
	#
		#for composition in compositions:
			#var data = {}
			#data.size = dimension
			#data.grids = composition.grids
			#data.indexs = []
			##var indexs = []
			#
			#for grid in composition.grids:
				#data.indexs.append(grid.y * dimension + grid.x)
			#
			#Global.dict.composition.index[index] = data
			#Global.dict.composition.size[dimension].append(index)
			#print([index, data.indexs, composition.segment_lengths])
			#index += 1
		
		#print(compositions[dimension].size())
