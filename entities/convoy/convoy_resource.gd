class_name ConvoyResource extends Resource


var contract: ContractResource
var chart: ChartResource
var statistic: StatisticResource
var slots: Array[SlotCompartmentResource]
var size: int
var index: int


func _init(size_: int, index_: int) -> void:
	size = size_
	index = index_
	roll_statistic()
	
func roll_statistic() -> void:
	statistic = StatisticResource.new()
	var values = Global.dict.condition.size[size][0].duplicate()#.pick_random().duplicate()
	var aspects = Global.arr.primary.duplicate()
	#aspects.shuffle()
	#values.shuffle()
	
	for _i in Global.dict.convoy.index[index].grids.size():
		var grid = Global.dict.convoy.index[index].grids[_i]
		statistic.grids[aspects[_i]] = [grid]
		statistic.values[aspects[_i]] = values[_i]
	

#func calc_all_contracts() -> void:
	#for title in Global.dict.contract.title:
		#var contract = {}
		#contract.title = title
		#contract.aspects = Global.dict.contract.title[title].aspects
		#contracts.append(contract)
		##contract.stars = []
		##contract.star = 0
		#contract.appraisals = {}
	#
	##var a = Bourse.convoy.contracts
	#pass
