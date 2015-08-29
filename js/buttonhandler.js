function update_tank_stats(){
	$('#tank_stats').text('')
	for(var name in tank_stats){
		stat = tank_stats[name];
		$('#tank_stats').append(name + ': ' + stat + '<br>');
	}
}	

$('#test_button').click(function() {
	update_tank_stats();
});