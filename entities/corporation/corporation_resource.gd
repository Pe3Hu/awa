class_name CorporationResource extends Resource


var bourse: BourseResource
var hangar: HangarResource
#var initiatives: Array[InitiativeResource]


func _init(bourse_: BourseResource) -> void:
	bourse = bourse_
	bourse.corporations.append(self)
	hangar = HangarResource.new(self)
	
func init_initiatives() -> void:
	var contract_decorations = []
	
	for contract in bourse.contracts:
		if !contract_decorations.has(contract.decoration):
			contract_decorations.append(contract.decoration)
	
	var showcasing_patterns = []
	var showcasing_acronyms = hangar.get_showcasing_pattern_acronyms()
	
	for wagon in hangar.showcasing_wagons:
		showcasing_patterns.append(wagon.pattern_index)
	
	showcasing_patterns.sort_custom(func(a, b): return a > b)
	var pattern_combinations = Global.get_all_combinations_based_on_size(showcasing_patterns, 3)
	var showcasing_drafts = []
	var showcasing_compositions = []
	
	for pattern_combination in pattern_combinations:
		if bourse.pattern_drafts.has(pattern_combination):
			var draft = bourse.pattern_drafts[pattern_combination]
			showcasing_drafts.append(draft)
			var compositions = draft.compositions.filter(func(a): return !showcasing_compositions.has(a) and contract_decorations.has(a.decoration))
			showcasing_compositions.append_array(compositions)
	
	print(showcasing_acronyms)
	for composition in showcasing_compositions:
		var origin = composition.get_pattern_acronyms()
		var need = origin.filter(func(a): return !showcasing_acronyms.has(a))
		print([composition.decoration.indexs, origin, need])#, composition.pattern_anchors, composition.pattern_rotates])
	
	#print(showcasing_patterns)
	#print(pattern_combinations)
	#print([showcasing_drafts.size(), showcasing_compositions.size()])
