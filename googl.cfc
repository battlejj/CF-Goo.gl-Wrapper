component {
	
	response = getPageContext().getResponse();
	
	remote function shorten(required string longURL){
		//set api key here if you want to track the URLs
		var apiKey = "";
		
		//if the URL doesnt start with http or https lets add it 
		if(left(longURL,7) != "http://" && left(longURL,8) != "https://"){
			longURL = "http://" & longURL;	
		}
		
		/* 
			by default i restrict the shortener to the current domain unless a 2nd argument is passed to the cfc with the value of external 
			I am sure there is a better way to determine the domain, but this should work for any number of subdomains
		*/
		var domain = listGetAt(cgi.SERVER_NAME, listLen(cgi.SERVER_NAME, ".") - 1, ".") & "." & listLast(cgi.SERVER_NAME,".");
		
		
		if(isValid("url",longURL) && find('.',longURL)){
			if(longURL contains domain || (arrayLen(arguments) GT 1 && arguments[2] == "external")){
				var json = '{"longUrl": "#longURL#"}';
				var googlRequest = new http();
				googlRequest.setURL("https://www.googleapis.com/urlshortener/v1/url?#len(trim(apiKey)) ? 'key=#apiKey#' :''#");
				googlRequest.setMethod("POST");
				googlRequest.addParam(type="header", name="Content-Type", value="application/json");
				googlRequest.addParam(type="body", value="#json#"); 
				result = googlRequest.send().getPrefix();
				
				result = deserializeJSON(result.filecontent.toString());
				
				if(structKeyExists(result,"error")){
					return "The following error message was returned from goo.gl: #result.error.message#";	
				}
				
				return result;
			} else {
				response.setstatus(400);
				return "<h1>Invalid Request. Off-domain request.</h1>";
			}
		} else {			
			response.setstatus(400);
			return "<h1>Invalid Request. Invalid URL.</h1>";
		}
	}
	
	remote function expand(required string shortURL){
		//set api key here if you want to track the URLs
		var apiKey = "";
		var googlRequest = new http();
		googlRequest.setURL("https://www.googleapis.com/urlshortener/v1/url?#len(trim(apiKey)) ? 'key=#apiKey#&' :''#shortUrl=#shortURL#");
		result = googlRequest.send().getPrefix();
		return deserializeJSON(result.filecontent.toString());
	}	
	
}