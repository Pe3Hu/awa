class_name ScenarioResource extends Resource


var corporation: CorporationResource
var contract: ContractResource
var wagons: Array[WagonResource]
#var composition: CompositionResource

var compliance: StatisticResource


func _init(corporation_: CorporationResource, contract_: ContractResource, wagons_: Array) -> void:
	corporation = corporation_
	contract = contract_
	wagons.append(wagons_)
	
	init_requirement()
	
func init_requirement() -> void:
	compliance = StatisticResource.new(contract.requirement.aspects)
	
	for wagon in wagons:
		for aspect in wagon.statistic.aspects:
			var value = wagon.statistic.aspects[aspect]
			
			if value < 0:
				compliance.change_aspect(aspect, value)
			else:
				if compliance.aspects[aspect] < 0:
					compliance.change_aspect(aspect, value)
