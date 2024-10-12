class_name CorporationResource extends Resource


var bourse: BourseResource
var hangar: HangarResource

var initiatives: Array[InitiativeResource]
var pattern_initiatives: Dictionary


func _init(bourse_: BourseResource) -> void:
	bourse = bourse_
	bourse.corporations.append(self)
	hangar = HangarResource.new(self)
	
func init_initiatives() -> void:
	var contract_decorations = []
	
	for contract in bourse.contracts:
		if !contract_decorations.has(contract.decoration):
			contract_decorations.append(contract.decoration)
	
	var showcasing_drafts = []
	var showcasing_compositions = []
	var showcasing_pattern_indexs = []
	#var showcasing_pattern_acronyms = hangar.get_showcasing_pattern_acronyms()
	#print(showcasing_pattern_acronyms)
	
	for wagon in hangar.showcasing_wagons:
		showcasing_pattern_indexs.append(wagon.pattern_index)
	
	showcasing_pattern_indexs.sort_custom(func(a, b): return a > b)
	var pattern_combinations = Global.get_all_combinations_based_on_size(showcasing_pattern_indexs, 3)
	
	for pattern_combination in pattern_combinations:
		if bourse.pattern_drafts.has(pattern_combination):
			var draft = bourse.pattern_drafts[pattern_combination]
			showcasing_drafts.append(draft)
			var compositions = draft.compositions.filter(func(a): return !showcasing_compositions.has(a) and contract_decorations.has(a.decoration))
			showcasing_compositions.append_array(compositions)
	
	for composition in showcasing_compositions:
		#var origin = composition.get_pattern_acronyms()
		#var need = origin.filter(func(a): return !showcasing_pattern_acronyms.has(a) or origin.count(a) > showcasing_pattern_acronyms.count(a))
		var missing_pattern_indexes = []
		
		for composition_pattern_index in composition.pattern_indexs:
			if !missing_pattern_indexes.has(composition_pattern_index):
				var count = composition.pattern_indexs.count(composition_pattern_index) - showcasing_pattern_indexs.count(composition_pattern_index)
				
				for _i in count:
					missing_pattern_indexes.append(composition_pattern_index)
		
		var initiative = null
		
		if !pattern_initiatives.has(missing_pattern_indexes):
			initiative = InitiativeResource.new(self, showcasing_pattern_indexs, missing_pattern_indexes)
		else:
			initiative = pattern_initiatives[missing_pattern_indexes]
		
		initiative.compositions.append(composition)
	
	for initiative in initiatives:
		initiative.fill_contracts_based_on_decoration()
		#var need_acronyms = []
		#
		#for index in need:
			#need_acronyms.append(Global.dict.pattern.index[index].acronym)
		#print([composition.decoration.indexs, origin, need_acronyms])#, composition.pattern_anchors, composition.pattern_rotates])
	
	#print(showcasing_pattern_indexs)
	#print(pattern_combinations)
	#print([showcasing_drafts.size(), showcasing_compositions.size()])
