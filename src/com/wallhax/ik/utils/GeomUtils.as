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
				const nextVertex:Vector3D = vertices[i + 1];

				x0 = vertex.x;
				y0 = vertex.y;
				x1 = nextVertex.x;
				y1 = nextVertex.y;
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


		public static function rotate2D(input:Vector3D, angle:Number):void
		{
			input.x = Math.cos(angle)*input.x - Math.sin(angle)*input.y;
			input.y = Math.sin(angle)*input.x + Math.cos(angle)*input.y;
		}

		public static function getPointsCentroid(vertices:Vector.<Vector3D>):Vector3D
		{
			var centroid:Vector3D = new Vector3D();
			for (var i:int = 0, len:int = vertices.length; i < len; i++)
			{
				var vector3D:Vector3D = vertices[i];
				centroid.x += vector3D.x;
				centroid.y += vector3D.y;
				centroid.z += vector3D.z;
			}
			centroid.x /= vertices.length;
			centroid.y /= vertices.length;
			centroid.z /= vertices.length;

			return centroid;
		}
	}
}
