package com.wallhax.ik.utils
{
	public class MathUtils
	{
		public static const TO_DEG:Number = 180.0/Math.PI;

		public static function toDegrees(radians:Number):Number
		{
			return radians*TO_DEG;
		}
	}
}
