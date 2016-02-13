function tellMeLocation(){

    var output = document.getElementById("out");
    var geolocation = document.getElementById("user_location");

    if(!navigator.geolocation){
	output.innerHTML = "<p>Geolocation is not supported by your browser</p>";
	return;
    }

    function success(position){
	var latitude = position.coords.latitude;
	var longitude = position.coords.longitude;
	geolocation.value = latitude + ',' + longitude;
	output.innerHTML = "";
    }

    function error(){
	output.innerHTML="Unable to retrieve your location";
    };

    output.innerHTML = "<p>locating...</p>";

    navigator.geolocation.getCurrentPosition(success, error);
}

