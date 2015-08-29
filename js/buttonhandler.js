window.setInterval(function(){
  update_tank_stats();
}, 5000)

function update_tank_stats(){
	$('#tank_stats').html('<b>Tank Stats</b><p align="left">')
	for(var name in tank_stats){
		stat = tank_stats[name];
		$('#tank_stats').append(name + ': ' + stat + '<br>');
	}
	$('#tank_stats').append('</p>')
}	

$('#test_button').click(function() {
});