class_name BoardConvoyResource extends BoardResource


var contracts = []


func calc_all_contracts() -> void:
	for title in Global.dict.contract.title:
		var contract = {}
		contract.title = title
		contract.aspects = Global.dict.contract.title[title].aspects
		contracts.append(contract)
		#contract.stars = []
		#contract.star = 0
		contract.appraisals = {}
	
	var a = gui.convoy.contracts
	pass
