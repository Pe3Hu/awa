class_name BoardHangar extends Board


@export var resource: BoardHangarResource


func _ready() -> void:
	resource.gui = gui.resource
	gui.resource.hangar = resource
	resource.calc_all_triplets()
