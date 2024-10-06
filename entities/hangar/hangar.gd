class_name Hangar extends Board


@export var resource: HangarResource


func _ready() -> void:
	resource.Bourse = bourse.resource
	bourse.resource.hangar = resource
	#resource.calc_all_triplets()
