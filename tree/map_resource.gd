class_name MapResource extends Resource


var junctions: Array[JunctionResource]
var routes: Array[RouteResource]
var rings: Dictionary
var grids: Dictionary

var is_deviation: bool = false

const ring_limit = 6
const route_scale = 10

const junction_icon = Vector2(32, 32)
const junction_offset = junction_icon * 2
const junction_deviation = Vector2i(junction_icon * 0.5)


func _init() -> void:
	var a = Time.get_unix_time_from_system()
	Global._ready()
	init_junctions()
	init_routes()
	
	var b = Time.get_unix_time_from_system()
	print(b - a)
	
func init_junctions() -> void:
	for ring in ring_limit:
		var grid = Vector2i.ZERO
		
		if ring == 0:
			var _junction = JunctionResource.new(self, grid)
		else:
			grid = Vector2i(Global.dict.direction.diagonal.front()) * ring
			
			for _i in Global.dict.direction.linear2.size():
				var _k = (_i + 2) %Global.dict.direction.linear2.size()
				
				for _j in ring:
					var _junction = JunctionResource.new(self, grid)
					grid += Global.dict.direction.linear2[_k]# * 2
	
func init_routes() -> void:
	for junction in junctions:
		for direction in Global.dict.direction.diagonal:
			var neighbor_grid = direction + junction.grid
			
			if grids.has(neighbor_grid):
				if !junction.directions.has(direction):
					junction.add_route(direction)
	
	for ring in range(0, float(ring_limit) / 2):
		var grid = Vector2i(Global.dict.direction.linear2.front() * (ring + 0.5))
		
		for _i in Global.dict.direction.diagonal.size():
			var _k = (_i + 1) % Global.dict.direction.linear1.size()
			
			for _j in ring * 2 + 1:
				var diamond_junctions = []
				
				for direction in Global.dict.direction.linear1:
					var junction_grid = grid + direction
					
					if grids.has(junction_grid):
						diamond_junctions.append(grids[junction_grid])
					else:
						break
				
				if diamond_junctions.size() == Global.dict.direction.linear1.size():
					var _r = randi_range(0, 1)
					
					if ring == 0:
						_r = (_i + 1) % 2
					
					var route_junctions = diamond_junctions.filter(func(a): return diamond_junctions.find(a) % 2 == _r)
					var _route = RouteResource.new(self, route_junctions)
				
				grid += Global.dict.direction.diagonal[_k]# * 2
