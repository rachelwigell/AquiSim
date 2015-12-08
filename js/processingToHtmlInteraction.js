var selected_fish = 'select';

window.setInterval(function(){
  	update_tank_stats();
  	update_fish_stats();
  	update_achievements_stats();
  	update_fish_dropdown();
  	write_to_local_storage();
}, 2000)

function update_tank_stats(){
	var processing = Processing.getInstanceById('processing');
	processing.updateTankStats();
	$('#tank_stats_display').empty();
	for(var i = 0; i < 6; i++){
		name1 = Object.keys(tank_stats)[i];
		stat1 = tank_stats[name1];
		name2 = Object.keys(tank_stats)[i+6];
		stat2 = tank_stats[name2];
		$('#tank_stats_display').append('<tr><td><b>' + name1 + ':</b></td><td> ' + stat1 + '</td>' +
										'<td><b>' + name2 + ':</b></td><td> ' + stat2 + '</td></tr>');

	}
}

function update_fish_dropdown(){
	$('#fish_list').empty();
	$('#fish_list').append(new Option('Select a fish', 'select'));
	for(var fish in fish_stats){
		$('#fish_list').append(new Option(fish, fish));
	}
	$('#fish_list').val(selected_fish);
}

function update_fish_stats(){
	var processing = Processing.getInstanceById('processing');
	processing.updateFishStats();
	$('#fish_stats_display').empty();
	if(selected_fish == 'select'){
		$('#fish_stats_display').empty();
	}
	else{
		fish_info = fish_stats[selected_fish];
		var row = '<tr><td><b>Name:</b></td><td>' + fish_info['Name:'] + '</td><td><b>Ammonia levels tolerated:</b></td><td>' + fish_info["Ammonia levels tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
		row = '<tr><td><b>Species:</b></td><td>' + fish_info['Species:'] + '</td><td><b>Nitrite levels tolerated:</b></td><td>' + fish_info["Nitrite levels tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
		row = '<tr><td colspan="2"><center><img src="' + fish_info['image url'] + '"></center></td><td><b>Nitrate levels tolerated:</b></td><td>' + fish_info["Nitrate levels tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
		row = '<tr><td><b>Status:</b></td><td>' + fish_info['Status:'] + '</td><td><b>pH levels tolerated:</b></td><td>' + fish_info["pH levels tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
		var health_percentage = fish_info['health'] * 100 / fish_info['max health'];
		row = '<tr><td><b>Health:</b></td><td><div class="progress round" style="width: 100px"><span class="meter" style="width: ' + health_percentage + '%"></span></div></td><td><b>Temperatures tolerated:</b></td><td>' + fish_info["Temperatures tolerated:"] + '</td></tr>';
		$('#fish_stats_display').append(row);
		var fullness_percentage = fish_info['fullness'] * 100 / fish_info['max fullness'];
		row = '<tr><td><b>Fullness:</b></td><td><div class="progress round" style="width: 100px"><span class="meter" style="width: ' + fullness_percentage + '%"></span></div></td><td><b>Hardness levels tolerated:</b></td><td>' + fish_info["Hardness levels tolerated:"] + '</td></tr>';
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
		$('#species_stats_display').empty();
		$('#nickname_entry').hide();
		$('#add_fish').hide();
	}
	else{
		species_info = species_stats[selected_species];
		$('#nickname_entry').attr('placeholder', 'Name your ' + selected_species + '!');
		$('#add_fish').text('Add a ' + selected_species + '!');
		$('#nickname_entry').show();
		$('#add_fish').show();
		for(var name in species_info){
			stat = species_info[name];
			if(name == "image url"){
				$('#species_stats_display').append('<tr><td colspan="2"><center><img src="' + stat + '"></center></td></tr>');
			}
			else{
				$('#species_stats_display').append('<tr><th>' + name + '</th><td> ' + stat + '</td></tr>');	
			}
		}
	}	
}

function update_achievements_dropdown(){
	$('#achievements_list').empty();
	$('#achievements_list').append(new Option('Select an unlockable', 'select'));
	for(var achievement in achievements_stats){
		$('#achievements_list').append(new Option(achievement, achievement));
	}
}

function reward_button_visibility(){
	var processing = Processing.getInstanceById('processing');
	processing.updateAchievementsStats();
	var clickMode = processing.getClickMode();
	var selected_achievement = $('#achievements_list').find(':selected').val();
	var achievement_info = achievements_stats[selected_achievement];
	var add_val = selected_achievement != 'select' && clickMode == 'DEFAULT' && achievement_info['earned'] && !achievement_info['used'];
	var move_val = selected_achievement != 'select'&& selected_achievement != 'Substrate' && clickMode == 'DEFAULT' && achievement_info['earned'] && achievement_info['used'];
	var rotate_val = selected_achievement != 'select' && selected_achievement != 'Substrate' && clickMode == 'DEFAULT' && achievement_info['earned'] && achievement_info['used'];
	var delete_val = selected_achievement != 'select' && clickMode == 'DEFAULT' && achievement_info['earned'] && achievement_info['used'];
	var cancel_add = selected_achievement != 'select' && clickMode == 'ADDACHIEVEMENT' && achievement_info['earned'] && !achievement_info['used'];
	var cancel_move = selected_achievement != 'select' && clickMode == 'MOVEACHIEVEMENT' && achievement_info['earned'] && achievement_info['used'];
	var cancel_rotate = selected_achievement != 'select' && clickMode == 'ROTATEACHIEVEMENT' && achievement_info['earned'] && achievement_info['used'];
	$('#add_reward').attr('hidden', !add_val);
	$('#move_reward').attr('hidden', !move_val);
	$('#rotate_reward').attr('hidden', !rotate_val);
	$('#delete_reward').attr('hidden', !delete_val);
	$('#cancel_reward_add').attr('hidden', !cancel_add);
	$('#cancel_reward_move').attr('hidden', !cancel_move);
	$('#cancel_reward_rotate').attr('hidden', !cancel_rotate);
}

function update_achievements_stats(){
	reward_button_visibility();
	$('#achievements_display').empty();
	var selected_achievement = $('#achievements_list').find(':selected').val();
	if(selected_achievement == 'select'){
		$('#achievements_display').empty();
	}
	else{
		achievement_info = achievements_stats[selected_achievement];
		var append_string = '<tr><td><img src="' + achievement_info['image url'] + '"></td>';
		if(!achievement_info['earned']){
			 append_string += '<td>' + achievement_info['description'] + ' Earn this achievement by <b>' + achievement_info['condition'] + '.</b></td></tr>';
		}
		else if(!achievement_info['used']){
			append_string += '<td>Congratulations! You earned the ' + achievement_info['reward'] + ' by ' + achievement_info['condition'] + '. You can add it to your tank now.</td></tr>';
			update_button_text('add_reward', 'Add ' + achievement_info['reward']);
		}
		else{
			append_string += '<td>The ' + achievement_info['reward'] + ' is already in your tank. You can modify it with the buttons below.</td></tr>';
			update_button_text('rotate_reward', 'Rotate ' + achievement_info['reward']);
			update_button_text('move_reward', 'Move ' + achievement_info['reward']);
			update_button_text('delete_reward', 'Delete ' + achievement_info['reward']);
		}
		$('#achievements_display').append(append_string);
	}	
}

function write_cookie(){
	var processing = Processing.getInstanceById('processing');
	var cookie_string = processing.cookieInfo();
	for(var i = 0; i < cookie_string.size(); i++){
		document.cookie = cookie_string.get(i) + "expires=Tue, 19 Jan 2038 03:14:07 UTC; path=/";
	}
}

function write_to_local_storage(){
	var processing = Processing.getInstanceById('processing');
	var storage_map = processing.localStorageInfo();
	var i = storage_map.entrySet().iterator();
	while (i.hasNext()) {
		var info = i.next();
		var key = info.getKey();
		localStorage.setItem(key, info.getValue());
	}
}

function get_cookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for(var i=0; i<ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return c.substring(name.length,c.length);
    }
    return "";
}

function update_button_text(button_name, text){
	$('#'+button_name).text(text)
}

function handle_plant_buttons(){
	var processing = Processing.getInstanceById('processing');
	if(processing.hasPlants()){
		$('#delete_plant').attr('hidden', false);
		$('#move_plant').attr('hidden', false);
		$('#rotate_plant').attr('hidden', false);
	}
	else{
		$('#delete_plant').attr('hidden', true);
		$('#move_plant').attr('hidden', true);
		$('#rotate_plant').attr('hidden', true);
	}
	if(processing.hasMaxPlants()){
		$('#add_plant').attr('hidden', true);
	}
	else{
		$('#add_plant').attr('hidden', false);
	}
}

function accordion_defaults(new_user){
	if(new_user){
		$('#tank_health_menu').removeClass('active');
		$('#fish_health_menu').removeClass('active');
		$('#add_fish_menu').addClass('active');
		$('#manage_plants_menu').removeClass('active');
		$('#help_menu').addClass('active');
		$('#feedback_menu').removeClass('active');
		$('#achievements_menu').removeClass('active');
	}
	else{
		$('#tank_health_menu').addClass('active');
		$('#fish_health_menu').addClass('active');
		$('#add_fish_menu').addClass('active');
		$('#manage_plants_menu').addClass('active');
		$('#help_menu').addClass('active');
		$('#feedback_menu').addClass('active');
		$('#achievements_menu').addClass('active');
	}
}

$('#fish_list').change(function(){
	selected_fish = $('#fish_list').find(':selected').val();
	update_fish_stats();
})

$('#species_list').change(function(){
	update_species_stats();
})

$('#achievements_list').change(function(){
	update_achievements_stats();
})

$('#help_topics').change(function(){
	var selected_topic = $('#help_topics').find(':selected').val();
	if(selected_topic == 'fish'){
		$('#help_text').text("Fish can be kept healthy by keeping water parameters such as pH and temperature within the safe range, and by ensuring that they do not get hungry. Fish's preferences depend on their species, but individuals will also adapt to your water over time. See the other items in this menu to learn how to influence the chemistry of your tank's water!");
	}
	if(selected_topic == 'change'){
		$('#help_text').text("Changing the water can help bring chemistry back to neutral values, but be careful of over-changing since this will also get rid of some of the helpful bacteria that live in the water.");
	}
	else if(selected_topic == 'pH'){
		$('#help_text').text("pH refers to the acidity of the tank water. Each fish has a range of pH's in which it can survive. pH is lowered by the presence of waste and food in the water. If you need to raise it, perform a water change.");
	}
	else if(selected_topic == 'temperature'){
		$('#help_text').text("Water temperature varies based on time of day. Each species of fish has a range of temperatures in which it can survive.");
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
	processing.waterChange(percent);
	update_button_text('perform_water_change', 'Changed ' + percent + '%')
	update_tank_stats();
	setTimeout(update_button_text, 1500, 'perform_water_change', 'Change ' + percent + '% of Water')
})

$('#add_fish').click(function(){
	var processing = Processing.getInstanceById('processing');
	var nickname = $('#nickname_entry').val();
	var species = $('#species_list').find(':selected').val();
	if(processing.hasMaxFish()){
		$('#nickname_entry').val('');
		update_button_text('add_fish', "Sorry, you can't have more than 20 fish.");
		setTimeout(update_button_text, 1500, 'add_fish', 'Add a ' + species + '!');
	}
	else if(nickname == ''){
		update_button_text('add_fish', 'Please select a nickname.');
		setTimeout(update_button_text, 1500, 'add_fish', 'Add a ' + species + '!');
	}
	else if(processing.haveFishWithName(nickname)){
		$('#nickname_entry').val('');
		update_button_text('add_fish', 'Please select a unique nickname.');
		setTimeout(update_button_text, 1500, 'add_fish', 'Add a ' + species + '!');
	}
	else{
		processing.addFishToTank(species, nickname);
		update_fish_dropdown();
		update_button_text('add_fish', species + ' added!');
		setTimeout(update_button_text, 1500, 'add_fish', 'Add a ' + species + '!');
	}
})

$('#add_plant').click(function(){
	$('#add_plant').attr('hidden', true);
	$('#new_plant').attr('hidden', false);
	$('#delete_plant').attr('hidden', true);
	$('#move_plant').attr('hidden', true);
	$('#rotate_plant').attr('hidden', true);
	$('#cancel_plant_add').attr('hidden', false);
	$('#plant_instructions').text("Click on the tank floor to place your new plant! Plant shapes and colors are randomly generated. If you don't like what you got, click 'Generate New Plant' to get a new one")
	var processing = Processing.getInstanceById('processing');
	processing.createPlantPreview();
})

$('#new_plant').click(function(){
	var processing = Processing.getInstanceById('processing');
	processing.createPlantPreview();
})

$('#add_reward').click(function(){
	var processing = Processing.getInstanceById('processing');
	var achievement_type = $('#achievements_list').find(':selected').val();
	processing.createAchievementPreview(achievement_type);
	reward_button_visibility();
})

$('#cancel_plant_add').click(function(){
	handle_plant_buttons();
	$('#new_plant').attr('hidden', true);
	$('#cancel_plant_add').attr('hidden', true);
	$('#plant_instructions').empty();
	var processing = Processing.getInstanceById('processing');
	processing.cancelPlant();
})

$('#cancel_reward_add').click(function(){
	var processing = Processing.getInstanceById('processing');
	processing.cancelPlant();
	reward_button_visibility();
})

$('#delete_plant').click(function(){
	$('#add_plant').attr('hidden', true);
	$('#move_plant').attr('hidden', true);
	$('#new_plant').attr('hidden', true);
	$('#delete_plant').attr('hidden', true);
	$('#rotate_plant').attr('hidden', true);
	$('#cancel_plant_delete').attr('hidden', false);
	$('#plant_instructions').text("Click the X at the base of a plant to delete it.");
	var processing = Processing.getInstanceById('processing');
	processing.setClickMode("DELETEPLANT");
})

$('#delete_reward').click(function(){
	reward_button_visibility();
	var selected_achievement = $('#achievements_list').find(':selected').val();
	var processing = Processing.getInstanceById('processing');
	processing.deleteAchievement(selected_achievement);
})

$('#cancel_plant_delete').click(function(){
	handle_plant_buttons();
	$('#cancel_plant_delete').attr('hidden', true);
	$('#plant_instructions').empty();
	var processing = Processing.getInstanceById('processing');
	processing.cancelPlant();
})

$('#move_plant').click(function(){
	$('#add_plant').attr('hidden', true);
	$('#new_plant').attr('hidden', true);
	$('#move_plant').attr('hidden', true);
	$('#rotate_plant').attr('hidden', true);
	$('#delete_plant').attr('hidden', true);
	$('#cancel_plant_move').attr('hidden', false);
	$('#plant_instructions').text("Click the grip at the base of a plant to move it.");
	var processing = Processing.getInstanceById('processing');
	processing.setClickMode("MOVEPLANT");
})

$('#cancel_plant_move').click(function(){
	handle_plant_buttons();
	$('#cancel_plant_move').attr('hidden', true);
	$('#plant_instructions').empty();
	var processing = Processing.getInstanceById('processing');
	processing.cancelPlant();
})

$('#move_reward').click(function(){
	reward_button_visibility();
	var processing = Processing.getInstanceById('processing');
	processing.setClickMode("MOVEACHIEVEMENT");
})

$('#cancel_reward_move').click(function(){
	reward_button_visibility();
	var processing = Processing.getInstanceById('processing');
	processing.cancelPlant();
})

$('#rotate_plant').click(function(){
	$('#add_plant').attr('hidden', true);
	$('#new_plant').attr('hidden', true);
	$('#move_plant').attr('hidden', true);
	$('#rotate_plant').attr('hidden', true);
	$('#delete_plant').attr('hidden', true);
	$('#cancel_plant_move').attr('hidden', true);
	$('#cancel_plant_rotate').attr('hidden', false);
	$('#plant_instructions').text("Click and hold the grip at the base of a plant to rotate it.");
	var processing = Processing.getInstanceById('processing');
	processing.setClickMode("ROTATEPLANT");
})

$('#cancel_plant_rotate').click(function(){
	handle_plant_buttons();
	$('#cancel_plant_rotate').attr('hidden', true);
	$('#plant_instructions').empty();
	var processing = Processing.getInstanceById('processing');
	processing.cancelPlant();
})

$('#rotate_reward').click(function(){
	handle_plant_buttons();
	var processing = Processing.getInstanceById('processing');
	processing.setClickMode("ROTATEACHIEVEMENT");
})

$('#cancel_reward_rotate').click(function(){
	handle_plant_buttons();
	var processing = Processing.getInstanceById('processing');
	processing.cancelPlant();
})

$('#food_type').change(function(){
	var processing = Processing.getInstanceById('processing');
	var boolValue = !$('#food_type').is(":checked");
	processing.setFloatingFood(boolValue);
})

$(document).ready(function() {
	$(document).foundation({
		slider: {
		    on_change: function(){
				var percent = $('#water_change_percentage').attr('data-slider');
				$('#perform_water_change').text('Change ' + percent + '% of Water');
			}
		},
		accordion: {
			multi_expand: true,
			callback : function (accordion) {
                $(document).foundation('reflow');
            }
		}
	});
});