class_name ContractResource extends Resource


var bourse: BourseResource
var decoration: DecorationResource
#reward
var type: String


func _init(bourse_: BourseResource, type_: String, decoration_: DecorationResource) -> void:
	bourse = bourse_
	bourse.contracts.append(self)
	type = type_
	decoration = decoration_
	print(decoration_.index)
