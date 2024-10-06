class_name ChartResource extends Resource


var convoy: ConvoyResource
var aspects: Dictionary
var min_aspect: int
var max_aspect: int


func init_aspects() -> void:
	for aspect in Global.arr.aspect:
		aspects[aspect] = 0
	
	for specific in convoy.specifics:
		aspects[specific.aspect] += specific.value
	
	var description = Global.dict.contract.title[convoy.contract].aspects
	
	for aspect in description:
		aspects[aspect] -= description[aspect]
	
func update_extremes() -> void:
	min_aspect = aspects[0]
	max_aspect = aspects[0]
	
	for aspect in aspects:
		if min_aspect > aspects[aspect]:
			min_aspect = aspects[aspect]
			
		if max_aspect < aspects[aspect]:
			max_aspect = aspects[aspect]
	
	var extreme = max(abs(min_aspect), abs(max_aspect))
	min_aspect = -extreme
	max_aspect = extreme
