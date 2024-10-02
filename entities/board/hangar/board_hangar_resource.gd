class_name BoardHangarResource extends BoardResource


var triplets = []
var performances = {}


func calc_all_triplets() -> void:
	var titles = []
	
	for size in Global.dict.wagon.size:
		var _titles = Global.dict.wagon.size[size].duplicate()
		titles.append(_titles)
	
	var combinations = Global.get_all_combinations(titles)
	
	for combination in combinations:
		var triplet = {}
		triplet.combination = combination
		triplet.aspects = {}
		
		for title in combination:
			for aspect in Global.dict.wagon.title[title].aspects:
				if !triplet.aspects.has(aspect):
					triplet.aspects[aspect] = 0
				
				triplet.aspects[aspect] += Global.dict.wagon.title[title].aspects[aspect]
		
		triplets.append(triplet)
	
	calc_all_performances()
	
func calc_all_performances() -> void:
	var stars = {}
	stars[1] = [-7, 0]
	stars[2] = [1, 4]
	stars[3] = [5, 8]
	stars[4] = [9, 12]
	
	for contract in gui.convoy.contracts:
		#var sum_stars = 0
		
		for triplet in triplets:
			var performance = {}
			performance.triplet = triplets.find(triplet)
			performance.contract = gui.convoy.contracts.find(contract)
			performance.appraisal = 0
			#performance.appraisals = {}
			#performance.success = true
			var aspects = triplet.aspects.keys().filter(func (a): return !contract.aspects.has(a))
			aspects.append_array(contract.aspects.keys())
			
			for aspect in aspects:
				var appraisal = 0
				
				if triplet.aspects.has(aspect):
					appraisal += triplet.aspects[aspect]
				
				if contract.aspects.has(aspect):
					appraisal -= contract.aspects[aspect]
				
					#performance.appraisals[aspect] = appraisal
					performance.appraisal += appraisal
				else:
					if appraisal < 0:
						#performance.appraisals[aspect] = appraisal
						performance.appraisal += appraisal
				
				#if appraisal < 0 and performance.success:
				#	performance.success = false
			
			var fails = int(-performance.appraisal)
			
			if fails <= -7:
				fails = -7
			
			if fails >= 12:
				fails = 12
			
			fails *= -1
			#for star in stars:
				#if fails >= stars[star].front() and fails <= stars[star].back():
					#performance.star = star
					#break
			#
			#contract.stars.append(performance.star)
			#sum_stars += performance.star
		
		#contract.star = snappedf(float(sum_stars) / triplets.size(), 0.01)
		#print([contract.title, contract.star])
			
			#if fails <= 5 and fails > 0:
			if true:
				if !contract.appraisals.has(fails):
					contract.appraisals[fails] = []
				
				contract.appraisals[fails].append(performance)
		
		#var appraisals = contract.appraisals.keys()
		#appraisals.sort()
		#for appraisal in appraisals:
		#	print([contract.title, appraisal, contract.appraisals[appraisal].size()])
	
	#var fails = performances.keys()
	#fails.sort()
	#
	#for _i in fails:
		#print([_i, performances[_i]])
	#performances.sort_custom(func(a, b): return a.appraisal > b.appraisal)
		
		
	
	
	
	pass
