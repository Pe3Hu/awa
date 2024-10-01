class_name BoardWagonResource extends BoardResource


var index: int = 0:
	set(index_):
		index = (Global.dict.pattern.index.size() + index_) % Global.dict.pattern.index.size()
		title = Global.dict.pattern.index[index].title
		dimension = Global.dict.pattern.index[index].dimension
		grids.clear()
		grids.append_array(Global.dict.pattern.index[index].grids)
var title: String
var dimension: Vector2i
var grids: Array[Vector2i]
