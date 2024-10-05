class_name BoardConvoyResource extends BoardResource


var contracts = []
var chart: ChartResource
var specifics = []
var index: int
var contract: String
var size: int = 4


func calc_all_contracts() -> void:
	for title in Global.dict.contract.title:
		var contract = {}
		contract.title = title
		contract.aspects = Global.dict.contract.title[title].aspects
		contracts.append(contract)
		#contract.stars = []
		#contract.star = 0
		contract.appraisals = {}
	
	#var a = gui.convoy.contracts
	pass
	
func init(gui_: GUIResource) -> void:
	gui = gui_
	chart = ChartResource.new()
	chart.convoy = self
	roll_index()
	roll_contract()
	chart.init_aspects()
	
func roll_index() -> void:
	index = Global.dict.convoy.size[size][0]#.pick_random()
	var values = Global.dict.condition.size[size][0].duplicate()#.pick_random().duplicate()
	var aspects = Global.arr.primary.duplicate()
	#aspects.shuffle()
	#values.shuffle()
	
	for _i in Global.dict.convoy.index[index].grids.size():
		var specific = {}
		specific.grid = Global.dict.convoy.index[index].grids[_i]
		specific.aspect = aspects[_i]
		specific.value = values[_i]
		specifics.append(specific)
	
func roll_contract() -> void:
	contract = Global.dict.contract.title.keys()[0]#.pick_random()
