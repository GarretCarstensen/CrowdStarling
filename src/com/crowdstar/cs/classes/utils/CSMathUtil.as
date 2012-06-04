package com.crowdstar.cs.classes.utils
{
	public class CSMathUtil
	{
		public function CSMathUtil()
		{
			throw new Error("Do not construct static class CSMathUtil");
		}
		
		public static function limitNumber(x:Number, min:Number, max:Number):Number
		{
			if (x < min)
			{
				x = min;
			}
			if (x > max)
			{
				x = max;
			}
			return x;
		}
	}
}