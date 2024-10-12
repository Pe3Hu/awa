class_name StatisticResource extends Resource


var aspects: Dictionary
#var grids: Dictionary


func _init(aspects_: Dictionary) -> void:
	aspects = aspects_
	
func change_aspect(aspect_: TokenResource.Aspect, value_: int) -> void:
	if !aspects.has(aspect_):
		aspects[aspect_] = 0
	
	aspects[aspect_] += value_
	
	if aspects[aspect_] == 0:
		aspects.erase(aspect_)
