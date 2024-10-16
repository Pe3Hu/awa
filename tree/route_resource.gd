class_name RouteResource extends Resource


var map: MapResource
var junctions: Array[JunctionResource]
var index: int
var length: int


func _init(map_: MapResource, junctions_: Array) -> void:
	map = map_
	junctions.append_array(junctions_)
	index = map.routes.size()
	map.routes.append(self)
	
	var direction = junctions[1].grid - junctions[0].grid
	junctions[0].directions[direction] = self
	junctions[0].neighbors[junctions[1]] = self
	junctions[0].routes[self] = junctions[1]
	
	direction = junctions[0].grid - junctions[1].grid
	junctions[1].directions[direction] = self
	junctions[1].neighbors[junctions[0]] = self
	junctions[1].routes[self] = junctions[0]
	
	var a = junctions[0].position + junctions[0].deviation
	var b = junctions[1].position + junctions[1].deviation
	length = floor(a.distance_to(b) / map.junction_offset.length() * map.route_scale)
