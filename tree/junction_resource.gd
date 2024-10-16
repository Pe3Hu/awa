class_name JunctionResource extends Resource


var map: MapResource
var grid: Vector2i
var ring: int
var index: int

var position: Vector2
var deviation: Vector2

var directions: Dictionary
var routes: Dictionary
var neighbors: Dictionary


func _init(map_: MapResource, grid_: Vector2i) -> void:
	map = map_
	grid = grid_
	index = map.junctions.size()
	map.junctions.append(self)
	
	ring = max(abs(grid.x), abs(grid.y))
	
	if !map.rings.has(ring):
		map.rings[ring] = []
	
	map.rings[ring].append(self)
	map.grids[grid] = self
	roll_deviation()
	
func roll_deviation() -> void:
	var x = randi_range(-map.junction_deviation.x, map.junction_deviation.x)
	var y = randi_range(-map.junction_deviation.y, map.junction_deviation.y)
	
	if ring == map.ring_limit - 1:
		#x = 0
		#y = 0
		if map.ring_limit - 1 == abs(grid.x):
			x = 0
		if map.ring_limit - 1 == abs(grid.y):
			y = 0
	
	deviation = Vector2(x ,y)
	position = Vector2(grid) * map.junction_offset
	
func add_route(direction_: Vector2i) -> void:
	var neighbor_grid = direction_ + grid
	var junctions = [self, map.grids[neighbor_grid]]
	var _route = RouteResource.new(map, junctions)
