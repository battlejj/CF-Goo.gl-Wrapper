<html>
	<head>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>		
	</head>
	<body>
		<form id="shortenform">
			<label for="longurl">Enter a URL to shorten:</label>
			<input type="text" id="longurl" name="longurl">
			<button id="Shorten">Shorten</button>
		</form>

		<div id="shortened"></div>

		<form id="expandform">
			<label for="shorturl">Enter a URL to expand:</label>
			<input type="text" id="shorturl" name="shorturl">
			<button id="expand">expand</button>
		</form>
		
		<div id="expanded"></div>
		
		<script>
			function shortenURL(){	
				$.ajax({
					url: "googl.cfc?method=shorten&returnformat=json",
					data: {
						"longUrl": $('#longurl').val()
					},
					dataType:"json",
					success: function(response){
						$('#shortened').html('<a href="' + response.id + '">' + response.id + '</a>');
					}
				});
			}	
					
			function expandURL(){	
				$.ajax({
					url: "googl.cfc?method=expand&returnformat=json",
					data: {
						"shortUrl": $('#shorturl').val()
					},
					dataType:"json",
					success: function(response){
						$('#expanded').html('<a href="' + response.longUrl + '">' + response.longUrl + '</a>');
					}
				});
			}
			
			$(document).ready(function(){
				$('#shortenform').submit(function(e){ e.preventDefault(); shortenURL(); });
				$('#expandform').submit(function(e){ e.preventDefault(); expandURL(); });
			})	
		</script>
	</body>	
</html>