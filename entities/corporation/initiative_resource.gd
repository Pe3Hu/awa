class_name InitiativeResource extends Resource


var corporation: CorporationResource
var pattern_available_indexes: Array[int]
var pattern_missing_indexs: Array[int]

var contracts: Array[ContractResource]
var compositions: Array[CompositionResource]


func _init(corporation_: CorporationResource, pattern_available_indexes_: Array, pattern_missing_indexs_: Array) -> void:
	corporation = corporation_
	pattern_available_indexes.append_array(pattern_available_indexes_)
	pattern_missing_indexs.append_array(pattern_missing_indexs_)
	corporation.initiatives.append(self)
	corporation.pattern_initiatives[pattern_missing_indexs] = self
	
func fill_contracts_based_on_decoration() -> void:
	for contract in corporation.bourse.contracts:
		var composition_intersections = contract.decoration.compositions.filter(func(a): return compositions.has(a))
		
		if !composition_intersections.is_empty():
			for composition in composition_intersections:
				if composition.check_initiative_on_surpluses(self):
					contracts.append(contract)
					break
	
	print(contracts.size())
