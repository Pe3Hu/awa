class_name VertexsResource extends Resource


var icosahedron: IcosahedronResource
var index: int
var position: Vector3



func _init(icosahedron_: IcosahedronResource, position_: Vector3) -> void:
	icosahedron = icosahedron_
	position = position_
	
	index = icosahedron.vertexs.size()
	icosahedron.vertexs.append(self)
