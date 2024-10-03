class_name BoardWagonResource extends BoardResource


var index: int = 0:
	set(index_):
		var shift = index_ - index
		index = (Global.dict.pattern.index.size() + index_) % Global.dict.pattern.index.size()
		title = Global.dict.pattern.index[index].title
		var exceptions = ["5X0", "5I0"]
		
		if exceptions.has(title):
			index += shift
			title = Global.dict.pattern.index[index].title
		
		dimension = Global.dict.pattern.index[index].dimension
		rotate = 0
		rotates = Global.dict.pattern.index[index].rotates
var rotate: int = 0:
	set(rotate_):
		rotate = (4 + rotate_) % 4
var title: String
var dimension: Vector2i
var rotates: Dictionary
