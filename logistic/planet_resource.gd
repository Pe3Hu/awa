class_name PlanetResource extends AstronomicalResource


var star: StarResource
#var subtype: Subtype


func  _init(star_: StarResource) -> void:
	star = star_
	star.planets.append(self)
	star.astronomicals.append(self)
	
	roll_subptype()
	
func roll_subptype() -> void:
	var a = Global.dict.star.type
	var star_index = Global.dict.star.type[star.type][star.subtype]
	var probabilities = Global.dict.star.index[star_index].probability.planet
	
	subtype = Global.get_random_key(probabilities)
	pass
