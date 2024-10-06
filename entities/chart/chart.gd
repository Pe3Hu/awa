class_name Chart extends PanelContainer


@export var convoy: BoardConvoy
@export var resource: ChartResource


var center = custom_minimum_size / 2
var angle = PI * 2 / 8


func init() -> void:
	resource = convoy.resource.chart
	#var sprite_size = Vector2.ONE * 32
	
	for _i in Global.arr.aspect.size():
		#var sprite = Sprite2D.new()
		#sprite.texture = load("res://entities/token/images/coin.png")
		#sprite.position = center + Vector2.from_angle(angle) * (center - sprite_size / 2)
		#%Aspects.add_child(sprite)
		
		var point = center + Vector2.from_angle(angle * _i) * center * 0.5
		%Threshold.add_point(point)
	
	update_indicator()
	
func update_indicator() -> void:
	resource.update_extremes()
	var points = []
	#print([resource.min_aspect, resource.max_aspect])
	
	for _i in Global.arr.aspect.size():
		var aspect = Global.arr.aspect[_i]
		var shift = remap(resource.aspects[aspect], resource.min_aspect, resource.max_aspect, 0, 1)
		var point = center + Vector2.from_angle(angle * (_i + 1)) * center * (0.0 + 1.0 * shift)
		#print(Vector2.from_angle(angle * _i))
		#print([Global.get_str_aspect(aspect), resource.aspects[aspect], shift, point - center])
		points.append(point)
		var token = get_node("%"+Global.get_str_aspect(aspect))
		token.value = resource.aspects[aspect]
	
	%Indicator.polygon = points
