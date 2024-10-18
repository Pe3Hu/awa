class_name StripResource extends Resource


var icosahedron: IcosahedronResource
var faces: Array[FaceResource]



func _init(icosahedron_: IcosahedronResource, faces_: Array) -> void:
	icosahedron = icosahedron_
	faces.append_array(faces_)
	icosahedron.strips.append(self)
