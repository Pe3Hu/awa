class_name HangarResource extends BoardResource


var corporation: CorporationResource
var racharding_wagons: Array[WagonResource]
var showcasing_wagons: Array[WagonResource]
var operating_wagons: Array[WagonResource]


func _init(corporation_: CorporationResource) -> void:
	corporation = corporation_
	init_wagons()
	
func init_wagons() -> void:
	var exceptions = [22, 11]
	
	for size in Global.dict.wagon.size:
		for pattern_index in Global.dict.pattern.size[size]:
			if !exceptions.has(pattern_index):
				for type in Global.dict.wagon.size[size]:
					var _wagon = WagonResource.new(self, pattern_index, type)
					#add_starter_wagon(pattern_index, type)
	
#func add_starter_wagon(pattern_index_: int, type_: String) -> void:
	#var pattern_index = 11
	#var _wagon = WagonResource.new(self, pattern_index_, type_)
