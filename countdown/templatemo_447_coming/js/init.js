// Edit the date here

$(document).ready(function() {
						   
	$("#countdown").countdown({
		date: "25 February 2025 10:00:00",
		
				format: "on"
			},
			
			function() {
				// callback function
			});

});	
