var message = "Hello from Processing!"

$('#test_button').click(function() {
	message = "Hello from Javascript!" 
	$('#messages').text(message);
});