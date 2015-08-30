window.setInterval(function(){
	//print_debug_string();
  	update_tank_stats();
  	update_fish_dropdown();
}, 2000)

function print_debug_string(){
	$('#debug').text(debug_string);
}

function update_tank_stats(){
	$('#tank_stats_display').empty();
	for(var name in tank_stats){
		stat = tank_stats[name];
		$('#tank_stats_display').append(name + ': ' + stat + '<br>');
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
		for(var name in fish_info){
			stat = fish_info[name];
			$('#fish_stats_display').append(name + ': ' + stat +'<br>');	
		}
	}	
}

$('#fish_list').change(function(){
	update_fish_stats();
})