class_name WagonResource extends BoardResource


var hangar: HangarResource
var statistic: StatisticResource
var pattern_index: int = 0:
	set(pattern_index_):
		var shift = pattern_index_ - pattern_index
		var n = Global.dict.pattern.index.size()
		pattern_index = (n + pattern_index_) % n
		acronym = Global.dict.pattern.index[pattern_index].acronym
		var exceptions = ["5X0", "5I0"]
		
		if exceptions.has(acronym):
			pattern_index = (n + pattern_index_ + shift) % n
			acronym = Global.dict.pattern.index[pattern_index].acronym
		
		dimension = Global.dict.pattern.index[pattern_index].dimension
		rotate = 0
		rotates = Global.dict.pattern.index[pattern_index].rotates
var rotate: int = 0:
	set(rotate_):
		rotate = (4 + rotate_) % 4
var acronym: String
var type: String
var dimension: Vector2i
var rotates: Dictionary


func _init(hangar_: HangarResource, pattern_index_: int, type_: String) -> void:
	hangar = hangar_
	hangar.racharding_wagons.append(self)
	pattern_index = pattern_index_
	type = type_
	roll_statistic()
	
func roll_statistic() -> void:
	statistic = StatisticResource.new()
	statistic.values = Global.dict.wagon.title[type].aspects.duplicate()#.pick_random().duplicate()
	var aspects = statistic.values.keys()#.shuffle()
	var grids = rotates[0].duplicate()#.shuffle()
	#aspects.shuffle()
	#values.shuffle()
	
	for _i in aspects.size():
		#var grid = grids[_i]
		#var aspect = aspects[_i]
		statistic.grids[aspects[_i]] = [grids[_i]]
	
	pass
	
