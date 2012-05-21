package com.crowdstar.cs.classes.utils
{
	public class CSUtilString
	{
		public function CSUtilString()
		{
		}
		
		public static function getNumberString(num:Number, minTensPlaces:uint = 1, minDecimalPlaces:uint = 0, maxDecimalPlaces:uint = int.MAX_VALUE):String
		{
			var retString:String;
			
			// Create a vector of each digit in the tens places
			// The vector is orderd from ones place to increasing tens places
			
			// Convert the whole number portion into an string
			// Clear the string if number is 0
			var tensString:String = String(int(num));
			if (tensString == "0" && minTensPlaces == 0)
			{
				tensString = "";
			}
			
			// Add leading 0s as necessary
			while (tensString.length < minTensPlaces)
			{
				tensString = "0"+tensString;
			}
			
			retString = tensString;
			
			// Convert the decimal digits to a string
			if (maxDecimalPlaces > 0)
			{
				// Get digits from available decimal places
				var decimalNum:Number = num - int(num);
				var decimalString:String = "";
				if (decimalNum != 0)
				{
					decimalString += String(decimalNum).substr(2, maxDecimalPlaces);
					// Remove ending 0s to compensate rounding errors
					while (decimalString.charAt(decimalString.length - 1) == "0" && decimalString.length > minDecimalPlaces)
					{
						decimalString = decimalString.substr(0, decimalString.length - 1);
					}
				}
				
				// Add extra 0s to end of string if decimal places are less than the minimum
				while(decimalString.length < minDecimalPlaces)
				{
					decimalString += 0;
				}
				
				// Add the decimal string if decimal digits are available
				if (decimalString.length != 0)
				{
					retString += "."+decimalString;
				}
			}
			
			return retString;
		}
	}
}