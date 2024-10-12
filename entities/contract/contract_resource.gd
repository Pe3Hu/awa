class_name ContractResource extends Resource


var bourse: BourseResource
var decoration: DecorationResource
#reward
var type: String
var requirement: StatisticResource


func _init(bourse_: BourseResource, type_: String, decoration_: DecorationResource) -> void:
	bourse = bourse_
	bourse.contracts.append(self)
	type = type_
	decoration = decoration_
	
	requirement = StatisticResource.new(Global.dict.contract.title[type].aspects)
	#print(decoration_.index)
