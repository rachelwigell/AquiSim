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
	for(var fish in fish_stats){
		$('#fish_list').append(new Option(fish, fish));
	}
	if($('#fish_list').length < 2){
		$('#fish_list').append(new Option("You don't have any fish!", 'no_fish'));
	}
}

function update_fish_stats(){
	$('#fish_stats_display').empty();
}

$('#fish_list').change(function(){
	update_fish_stats();
})