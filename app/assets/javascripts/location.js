function tellMeLocation(){

    var output = document.getElementById("out");
    
    if(!navigator.geolocation){
	output.innerHTML = "<p>Geolocation is not supported by your browser</p>";
	return;
    }

    function success(position){
	var latitude = position.coords.latitude;
	var longitude = position.coords.longitude;
	output.innerHTML = '<p>Latittude is ' + latitude + '" <br> longitude is ' + longitude + '"</p>';
    }

    function error(){
	output.innerHTML="Unable to retrieve your location";
    };

    output.innerHTML = "<p>locating...</p>";

    navigator.geolocation.getCurrentPosition(success, error);
}
    
