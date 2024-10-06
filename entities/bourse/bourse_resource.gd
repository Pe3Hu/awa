class_name BourseResource extends Resource


var contracts: Array[ContractResource]
var corporations: Array[CorporationResource]
var corporations: Array[CorporationResource]


func _init() -> void:
	Global._ready()
	init_corporations()
	init_contracts()
	
func init_corporations() -> void:
	for _i in 1:
		var _corporation = CorporationResource.new(self)
	
func init_contracts() -> void:
	for _i in 1:
		add_contract()
	
func add_contract() -> void:
	var contract_type = roll_contract_type()
	var convoy_size = 4
	var convoy_index = roll_convoy_index(convoy_size)
	var convoy = ConvoyResource.new(convoy_size, convoy_index)
	#var reward = 
	var _contract = ContractResource.new(self, contract_type, convoy)
	
func roll_convoy_index(size_: int) -> int:
	var index = Global.dict.convoy.size[size_][0]#.pick_random()
	return index
	
func roll_contract_type() -> String:
	var type = Global.dict.contract.title.keys()[0]#.pick_random()
	return type
