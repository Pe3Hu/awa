class_name CorporationResource extends Resource


var bourse: BourseResource
var hangar: HangarResource
#var initiatives: Array[InitiativeResource]


func _init(bourse_: BourseResource) -> void:
	bourse = bourse_
	bourse.corporations.append(self)
	hangar = HangarResource.new(self)
	
func init_initiatives() -> void:
	pass
