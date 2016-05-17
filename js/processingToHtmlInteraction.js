var selected_fish = 'select';
var tooltip_text = {
	'pH too low.': 'Have you been letting food and waste rot in the tank? Try a water change or adding some plants.',
	'pH too high.': 'Delete some plants or add some food.',
	'Temperature too low.': 'Your fish will adapt to the tank temperature over time!',
	'Temperature too high.': 'Your fish will adapt to the tank temperature over time!',
	'Hardness too low.': 'Try adding some shells or substrate if you can!',
	'Hardness too high.': 'Try a water change.',
	'Ammonia too high.': 'Have you been letting food and waste rot in the tank? Have you built up your bacteria populations? Allow a small amount of ammonia to remain in the tank so that the bacteria can eat. For a quick fix, do a small water change.',
	'Nitrite too high.': 'Have you built up your nitrobacter populations? Allow a small amount of nitrite to remain in the tank so that the bacteria can eat. For a quick fix, do a small water change.',
	'Nitrate too high.': 'Add some plants or do a water change.',
	'Hungry!': "Your fish's fullness bar is empty. Feed your fish!",
	'Happy.': 'When your fish is happy, it will slowly recover health until the health bar is full.'
}

window.setInterval(function(){
  	update_tank_stats();
  	update_fish_stats();
  	update_achievements_stats();
  	update_fish_dropdown();
  	update_species_stats();
  	write_to_local_storage();
}, 2000)

function update_tank_stats(){
	var processing = Processing.getInstanceById('processing');
	processing.updateTankStats();
	for(var i = 0; i < 12; i++){
		name = Object.keys(tank_stats)[i];
		stat = tank_stats[name];
		$('#' + name + '_val').text(stat);
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
	if(selected_fish == 'select'){
		$('#fish_stats_display').hide();
	}
	else{
		$('#fish_stats_display').show();
		fish_info = fish_stats[selected_fish];
		for(var i = 0; i < 12; i++){
			name = Object.keys(fish_info)[i];
			stat = fish_info[name];
			if(name == "health"){
				var health_percentage = stat * 100 / fish_info['max_health'];
				$('#fish_health_val').attr('style', 'width: ' + health_percentage + '%');
			}
			else if(name == "fullness"){
				var fullness_percentage = stat * 100 / fish_info['max_fullness'];
				$('#fish_fullness_val').attr('style', 'width: ' + fullness_percentage + '%');
			}
			else if(name == "image_url"){
				$('#fish_image_url_val').attr('src', stat);	
			}
			else if(name == 'Status'){
				$('#fish_Status_val').text(stat);
				var prev_tooltip = Foundation.libs.tooltip.getTip($('#fish_Status')).contents().first();
				if(prev_tooltip != tooltip_text[stat]){
					Foundation.libs.tooltip.getTip($('#fish_Status')).contents().first().replaceWith(tooltip_text[stat]);	
				}	
			}
			else{
				$('#fish_' + name + '_val').text(stat);
			}
		}
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
	var processing = Processing.getInstanceById('processing');
	processing.populateSpeciesStats();
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
	var move_val = selected_achievement != 'select'&& selected_achievement != 'Substrate' && selected_achievement != 'Vacuum' && clickMode == 'DEFAULT' && achievement_info['earned'] && achievement_info['used'];
	var rotate_val = selected_achievement != 'select' && selected_achievement != 'Substrate' && selected_achievement != 'Vacuum' && clickMode == 'DEFAULT' && achievement_info['earned'] && achievement_info['used'];
	var delete_val = selected_achievement != 'select' && clickMode == 'DEFAULT' && selected_achievement != 'Vacuum' && achievement_info['earned'] && achievement_info['used'];
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
			if(selected_achievement == 'Vacuum'){
				append_string += '<td>Congratulations! You earned the Vacuum. Click the button below, then click and hold inside your tank to use it.</td></tr>';
				update_button_text('add_reward', 'Use Vacuum');
				update_button_text('cancel_reward_add', 'Stop Using Vacuum');
			}
			else{
				append_string += '<td>Congratulations! You earned the ' + achievement_info['reward'] + ' by ' + achievement_info['condition'] + '. You can add it to your tank now.</td></tr>';
				update_button_text('add_reward', 'Add ' + achievement_info['reward']);
				update_button_text('cancel_reward_add', 'Cancel Add');
			}
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
		$('#feedback_menu').removeClass('active');
		$('#achievements_menu').removeClass('active');
	}
	else{
		$('#tank_health_menu').addClass('active');
		$('#fish_health_menu').addClass('active');
		$('#add_fish_menu').addClass('active');
		$('#manage_plants_menu').addClass('active');
		$('#feedback_menu').addClass('active');
		$('#achievements_menu').addClass('active');
	}
}

function enable_debug(){
	var processing = Processing.getInstanceById('processing');
	processing.enableDebugMode();
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
	if(achievement_type == "Vacuum"){
		processing.toggleVacuum(true);
	}
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
	var achievement_type = $('#achievements_list').find(':selected').val();
	if(achievement_type == "Vacuum"){
		processing.toggleVacuum(false);
	}
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

$('input:radio').click(function(){
	var mode = $(this).attr('value');
	var processing = Processing.getInstanceById('processing');
	processing.setMode(mode);
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