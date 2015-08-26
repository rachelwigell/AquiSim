var message = "Hello from Processing!"

$('#test_button').click(function() {
	alert("Well, the button does something at least.")
	message = "Hello from Javascript!" 
	$('#messages').text(message);
});