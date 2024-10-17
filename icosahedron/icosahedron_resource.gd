class_name IcosahedronResource extends Resource


var vertexs: Array[VertexsResource]
var edges: Array[EdgeResource]
var faces: Array[FaceResource]


func _init() -> void:
	var q = (1 + sqrt(5)) / 2
	var l = (3 + sqrt(5)) / (4 * sqrt(3))
	var r = sqrt(2 * (5 + sqrt(5))) / 4
	
	var positions = [
		Vector3(0, 1, q),
		Vector3(0, -1, q),
		Vector3(q, 0, 1),
		Vector3(-q, 0, 1),
		Vector3(q, 0, -1),
		Vector3(-q, 0, -1),
		Vector3(1, q, 0),
		Vector3(-1, q, 0),
		Vector3(1, -q, 0),
		Vector3(-1, -q, 0),
		Vector3(q, 1, 0),
		Vector3(-1, -1, 0)
	]
	
	for position in positions:
		var _vertex = VertexsResource.new(self, position)
	
	for _i in vertexs.size():
		for _j in range(_i + 1, vertexs.size(), 1):
			var a = vertexs[_i]
			var b = vertexs[_j]
			var d = a.position.distance_to(b.position)
			
			print([d])
	
		#Vector3(0, 1, q),
		#Vector3(0, -1, q),
		#Vector3(0, q, 1),
		#Vector3(0, q, -1),
		#Vector3(-q, 0, 1),
		#
		#Vector3(q, 0, 1),
		#Vector3(-q, 0, 1),
		#Vector3(q, 1, 0),
		#Vector3(-q, 1, 0),
		#Vector3(1, 0, 1),
		#Vector3(1, 0, 1),
		#Vector3(q, 1, 0),
		#Vector3(-q, 1, 0),
		
		
