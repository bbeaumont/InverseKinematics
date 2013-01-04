package com.wallhax.ik.utils
{
	import flash.geom.Vector3D;

	public class GeomUtils
	{
		public static function getPolygonCentroid(vertices:Vector.<Vector3D>):Vector3D
		{
			var centroid:Vector3D = new Vector3D();
			var signedArea:Number = 0.0;
			var x0:Number = 0.0;
			var y0:Number = 0.0;
			var x1:Number = 0.0;
			var y1:Number = 0.0;
			var a:Number = 0.0;

			for (var i:int = 0, len:int = vertices.length - 1; i < len; i++)
			{
				const vertex:Vector3D = vertices[i];

				x0 = vertex.x;
				y0 = vertex.y;
				x1 = vertex.x;
				y1 = vertex.y;
				a = x0*y1 - x1*y0;
				signedArea += a;
				centroid.x += (x0 + x1)*a;
				centroid.y += (y0 + y1)*a;
			}

			x0 = vertices[i].x;
			y0 = vertices[i].y;
			x1 = vertices[0].x;
			y1 = vertices[0].y;
			a = x0*y1 - x1*y0;
			signedArea += a;
			centroid.x += (x0 + x1)*a;
			centroid.y += (y0 + y1)*a;

			signedArea *= 0.5;
			centroid.x /= (6.0*signedArea);
			centroid.y /= (6.0*signedArea);

			return centroid;
		}


		public static function toDeg(radians:Number):Number
		{
			return radians*180/Math.PI;
		}

		public static function rotate2D(input:Vector3D, angle:Number):void
		{
			input.x = Math.cos(angle)*input.x - Math.sin(angle)*input.y;
			input.y = Math.sin(angle)*input.x + Math.cos(angle)*input.y;
		}
	}
}
