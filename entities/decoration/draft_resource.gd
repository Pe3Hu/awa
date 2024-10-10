class_name DraftResource extends Resource


var bourse: BourseResource
var pattern_indexs: Array[int]
var compositions: Array[CompositionResource]


func _init(bourse_: BourseResource, pattern_indexs_: Array) -> void:
	bourse = bourse_
	pattern_indexs.append_array(pattern_indexs_)
	init_compositions()
	
	if !compositions.is_empty():
		bourse.drafts.append(self)
	
func init_compositions() -> void:
	compositions = bourse.compositions.filter(func (a): return a.check_draft(self))
	
