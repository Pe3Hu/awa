class_name DraftResource extends Resource


var index: int
var bourse: BourseResource
var pattern_indexs: Array[int]
var compositions: Array[CompositionResource]


#func _init(bourse_: BourseResource, pattern_indexs_: Array) -> void:
	#bourse = bourse_
	#pattern_indexs.append_array(pattern_indexs_)
	#compositions = bourse.compositions.filter(func (a): return a.check_draft(self))
	#
	#if !compositions.is_empty():
		#bourse.draft_origins.append(self)
	
func _init(bourse_: BourseResource, index_: int) -> void:
	bourse = bourse_
	index = index_
	
	var description = Global.dict.draft.index[index]
	pattern_indexs.append_array(description.patterns)
	
	for _i in description.compositions:
		var composition = bourse.compositions[_i]
		compositions.append(composition)
	
	bourse.drafts.append(self)
	bourse.pattern_drafts[pattern_indexs] = self
