/*
Name: Google Website Optimizer Google Analytics Integration Tool
Version: 1.2a for ga.js and urchin.js users
Original Author: Shawn Purtell
Algorithm: Ophir Prusak
Created: May 12, 2008
Description: Grabs data from Google Website Optimizer tracking cookie (__utmx) and returns the combination
			 number for use in the Google Analytics tracking functions.
			 Now features Error Handling for paused or completed experiments.
			 
Implementation:
--------------------------------------------------
FOR GA.JS ONLY
--------------------------------------------------
Simply add the following code immediately after the Google Analytics code (ga.js version) on the page:

GA CODE WOULD BE HERE
<!-- Begin Google Website Optimizer/ Google Analytics Integration for ga.js !-->
<script language="JavaScript" src="http://www.yoursite.com/path/to/ga_gwo.js" type="text/javascript"></script>
<script>
var gwoTracker = _gat._getTracker("UA-XXXXXX-X");
getcombo_ga("a-b-c-...");
</script>
<!-- End Google Website Optimizer/ Google Analytics Integration for ga.js !-->

-Make sure the ga_gwo.js line is pointing to the right place.
-Replace the UA-XXXXXX-X string with your actual account number.

To properly use the getcombo function, you need to pass in a string with the number of variations in each section, seperated with dashes.
For example, if the first section has three variations, the second section has four variations and the third section has two variations you'd call the function as such:

getcombo_ga('3-4-2');

If you do not pass in any paramater, it will use the same calculations as version 1.0, which did not require a parameter
-----------------------------------------------------
FOR URCHIN.JS ONLY
-----------------------------------------------------
Simply add the following code immediately after the Google Analytics code (urchin.js version) on the page:

GA CODE WOULD BE HERE
<!-- Begin Google Website Optimizer/ Google Analytics Integration for urchin.js !-->
<script language="JavaScript" src="http://www.yoursite.com/path/to/ga_gwo.js" type="text/javascript"></script>
<script>
getcombo_urchin("a-b-c-...");
</script>
<!-- End Google Website Optimizer/ Google Analytics Integration for urchin.js !-->

To properly use the getcombo function, you need to pass in a string with the number of variations in each section, seperated with dashes.
For example, if the first section has three variations, the second section has four variations and the third section has two variations you'd call the function as such:

getcombo_urchin('3-4-2');

If you do not pass in any paramater, it will use the same calculations as version 1.0, which did not require a parameter

~~~~~~
Last Modified by Shawn Purtell on May 12, 2008

*/

function readCookie(name)
{
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++)
	{
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
}

/*
To properly use the getcombo function, you need to pass in a string with the number of variations in each section, seperated with dashes.
For example, if the first section has three variations, the second section has four variations and the third section has two variations you'd call the function as such:

getcombo_urchin('3-4-2');

If you do not pass in any paramater, it will use the same calculations as version 1.0, which did not require a parameter
*/ 
function getcombo_ga(variations)
{
	if (document.cookie.indexOf("__utmx=") != -1)
	{
		var utmx_cookie_value = readCookie('__utmx');  
		var cookie_data_array = utmx_cookie_value.split(':');	
		var combination_id = cookie_data_array[2];
		if (combination_id){
			var temp = combination_id.split('.');
			var ids = temp[0].split('-');
			var x = ids.length;
			var multiplier = [];
			var factor = 1;
			var sum = 0;
			if (variations != undefined) {
				multiplier = variations.split('-');
			}
	
			for(i=0; i<x; i++){
				sum += ids[i] * factor;
				factor = (multiplier[i] > 0) ? factor * multiplier[i] : Math.pow(x,i+1) ;
			}
			
			var sPath = window.location.pathname;
			//var sPage = sPath.substring(sPath.lastIndexOf('\\') + 1);
			var sPage = sPath.substring(sPath.lastIndexOf('//') + 1) + "?combo=" + sum;
			//insert var gwoTracker = _gat._getTracker("UA-XXXXXX-X"); before the getcombo call;
			gwoTracker._initData();
			gwoTracker._trackPageview(sPage);
		}
	}
}

 
function getcombo_urchin(variations)
{
	if (document.cookie.indexOf("__utmx=") != -1)
	{
		var utmx_cookie_value = readCookie('__utmx');  
		var cookie_data_array = utmx_cookie_value.split(':');	
		var combination_id = cookie_data_array[2];
		if (combination_id){
			var temp = combination_id.split('.');
			var ids = temp[0].split('-');
			var x = ids.length;
			var multiplier = [];
			var factor = 1;
			var sum = 0;
			if (variations != undefined) {
				multiplier = variations.split('-');
			}
	
			for(i=0; i<x; i++){
				sum += ids[i] * factor;
				factor = (multiplier[i] > 0) ? factor * multiplier[i] : Math.pow(x,i+1) ;
			}
			
			var sPath = window.location.pathname;
			//var sPage = sPath.substring(sPath.lastIndexOf('\\') + 1);
			var sPage = sPath.substring(sPath.lastIndexOf('//') + 1) + "?combo=" + sum;
			urchinTracker(sPage);
		}
	}
}