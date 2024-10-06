class_name ContractResource extends Resource


var bourse: BourseResource
var convoy: ConvoyResource
#reward
var type: String


func _init(bourse_: BourseResource, type_: String, convoy_: ConvoyResource) -> void:
	bourse = bourse_
	bourse.contracts.append(self)
	type = type_
	convoy = convoy_
