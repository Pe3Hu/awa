class_name HangarResource extends BoardResource


var corporation: CorporationResource
var repairing_wagons: Array[WagonResource]
var showcasing_wagons: Array[WagonResource]
var operating_wagons: Array[WagonResource]

var stand_size: int = 4


func _init(corporation_: CorporationResource) -> void:
	corporation = corporation_
	init_wagons()
	
func init_wagons() -> void:
	for size in Global.dict.wagon.size:
		for pattern_index in Global.dict.pattern.size[size]:
			for type in Global.dict.wagon.size[size]:
				var _wagon = WagonResource.new(self, pattern_index, type)
				#add_starter_wagon(pattern_index, type)
	
func finish_charging_wagons() -> void:
	for _i in min(stand_size, repairing_wagons.size()):
		var wagon = repairing_wagons[_i * 20]#.front()
		wagon.next_status()
	
func get_wagons_based_on_status(status_: WagonResource.Status) -> Array:
	var path = WagonResource.Status.keys()[status_].to_lower() + "_wagons"
	return get(path)
	
func get_showcasing_pattern_acronyms() -> Array:
	var acronyms = []
	var indexs = []
	
	for wagon in showcasing_wagons:
		indexs.append(wagon.pattern_index)
		#acronyms.append(Global.dict.pattern.index[wagon.pattern_index].acronym)
	
	indexs.sort_custom(func(a, b): return a > b)
	
	for index in indexs:
		acronyms.append(Global.dict.pattern.index[index].acronym)
	
	return acronyms
