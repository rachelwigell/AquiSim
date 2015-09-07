window.onload = function() {
	setTimeout(update_tank_stats, 2000);
	setTimeout(update_fish_dropdown, 2000);
	setTimeout(update_fish_stats, 2000);
	setTimeout(update_species_dropdown, 2000);
	setTimeout(update_species_stats, 2000);
};

window.setInterval(function(){
  	update_tank_stats();
}, 2000)

function update_tank_stats(){
	$('#tank_stats_display').empty();
	for(var name in tank_stats){
		stat = tank_stats[name];
		$('#tank_stats_display').append('<tr><td><b>' + name + ':</b></td><td> ' + stat + '</td></tr>');
	}
}

function update_fish_dropdown(){
	$('#fish_list').empty();
	$('#fish_list').append(new Option('Select a fish', 'select'));
	for(var fish in fish_stats){
		$('#fish_list').append(new Option(fish, fish));
	}
}

function update_fish_stats(){
	$('#fish_stats_display').empty();
	var selected_fish = $('#fish_list').find(':selected').val();
	if(selected_fish == 'select'){
		$('#fish_stats_display').text('No fish selected.');
	}
	else{
		fish_info = fish_stats[selected_fish];
		var row = '<tr><td><b>Name:</b></td><td>' + fish_info['Name:'] + '</td><td><b>Ammonia levels tolerated:</b></td><td>' + fish_info["Ammonia levels tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
		row = '<tr><td><b>Species:</b></td><td>' + fish_info['Species:'] + '</td><td><b>Nitrite levels tolerated:</b></td><td>' + fish_info["Nitrite levels tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
		row = '<tr><td colspan="2"><img src="' + fish_info['image url'] + '"></td><td><b>Nitrate levels tolerated:</b></td><td>' + fish_info["Nitrate levels tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
		row = '<tr><td><b>Status:</b></td><td>' + fish_info['Status:'] + '</td><td><b>pH levels tolerated:</b></td><td>' + fish_info["pH levels tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
		var health_percentage = fish_info['health'] * 100 / fish_info['max health'];
		row = '<tr><td><b>Health:</b></td><td><div class="progress"><span class="meter" style="width: ' + health_percentage + '%"></span></div></td><td><b>Temperatures tolerated:</b></td><td>' + fish_info["Temperatures tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
		var fullness_percentage = fish_info['fullness'] * 100 / fish_info['max fullness'];
		row = '<tr><td><b>Fullness:</b></td><td><div class="progress"><span class="meter" style="width: ' + fullness_percentage + '%"></span></div></td><td><b>Hardness levels tolerated:</b></td><td>' + fish_info["Hardness levels tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
	}	
}

function update_species_dropdown(){
	$('#species_list').empty();
	$('#species_list').append(new Option('Select a species', 'select'));
	for(var species in species_stats){
		$('#species_list').append(new Option(species, species));
	}
}

function update_species_stats(){
	$('#species_stats_display').empty();
	var selected_species = $('#species_list').find(':selected').val();
	if(selected_species == 'select'){
		$('#species_stats_display').text('No species selected.');
		$('#nickname_entry').hide();
		$('#add_fish').hide();
	}
	else{
		species_info = species_stats[selected_species];
		$('#nickname_entry').attr('placeholder', 'Give your ' + selected_species + ' a name!');
		$('#add_fish').text('Add a ' + selected_species + '!');
		$('#nickname_entry').show();
		$('#add_fish').show();
		for(var name in species_info){
			stat = species_info[name];
			$('#species_stats_display').append('<tr><td><b>' + name + '</b></td><td> ' + stat + '</td></tr>');	
		}
	}	
}

$('#fish_list').change(function(){
	update_fish_stats();
})

$('#species_list').change(function(){
	update_species_stats();
})

$('#help_topics').change(function(){
	var selected_topic = $('#help_topics').find(':selected').val();
	if(selected_topic == 'fish'){
		$('#help_text').text("Fish can be kept healthy by keeping the properties of the aquarium such as pH and temperature within the safe range, which varies for each species of fish, and by ensuring that they do not get hungry. See the other items in this menu to learn how to influence the chemistry of your tank's water!");
	}
	else if(selected_topic == 'pH'){
		$('#help_text').text("pH refers to the acidity of the tank water. Each fish has a range of pH's in which it can survive. pH will usually tend to rise naturally over time, but is lowered by the presence of waste and food in the water.");
	}
	else if(selected_topic == 'temperature'){
		$('#help_text').text("Water temperature is initially 24 degrees Celsius but will tend toward room temperature, which varies based on time of day. Each species of fish has a range of temperatures in which it can survive.");
	}
	else if(selected_topic == 'hardness'){
		$('#help_text').text("Water hardness is a measure of how many minerals are dissolved in the water. Each fish has a range of hardnesses that it prefers. Hardness cannot directly be controlled in this game, but will fluctuate natrually.");
	}
	else if(selected_topic == 'cycle'){
		$('#help_text').text("Waste and excess food break down into ammonia, which is toxic to fish. Bacteria will grow to convert ammonia into a less deadly substance, nitrite. A different sort of bacteria will convert nitrite into mostly harmless nitrates. Some kinds of fish tolerate these compounds better than others. Cut down on all of these compounds by keeping your tank clean or by performing water changes.");
	}
	else if(selected_topic == 'bacteria'){
		$('#help_text').text("Nitrosomonas bacteria convert ammonia to nitrite. Nitrobacter bacteria convert nitrite to nitrate. The bacteria are harmless, and in fact their work is beneficial to your tank chemistry. Their populations rise when they have a lot of their corresponding chemicals to 'eat!'");
	}
	else if(selected_topic == 'gases'){
		$('#help_text').text("Dissolved O2 and CO2 are influenced by the ratio of fish to plants. The fish are not directly affected by these levels, but their values do impact other aspects of tank chemistry. Increase the O2:CO2 ratio by keeping fewer fish or more plants!");
	}
})

$('#perform_water_change').click(function(){
	var processing = Processing.getInstanceById('processing');
	var percent = $('#water_change_percentage').attr('data-slider');
	console.log(percent);
	processing.waterChange(percent);
})

$('#add_fish').click(function(){
	var processing = Processing.getInstanceById('processing');
	var nickname = $('#nickname_entry').val();
	var species = $('#species_list').find(':selected').val();
	processing.addFishToTank(species, nickname);
})