package
{
	import com.wallhax.ik.utils.GeomUtils;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	[SWF(frameRate="60", width="1000", height="800", backgroundColor="#EEEEEE")]
	public class PolygonCentroidDemo extends Sprite
	{
		private var _vertices:Vector.<Vector3D>;
		private var _centroidMarker:CentroidMarker;

		public function PolygonCentroidDemo()
		{
			super();
			_vertices = new Vector.<Vector3D>();

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;


			stage.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event:MouseEvent):void
		{
			var vm:VertexMarker = new VertexMarker();
			vm.x = event.stageX;
			vm.y = event.stageY;
			addChild(vm);

			_vertices.push(new Vector3D(vm.x, vm.y));


			if (_vertices.length > 1)
			{
				if (!_centroidMarker)
				{

					_centroidMarker = new CentroidMarker();
					addChild(_centroidMarker);
				}
				var v:Vector3D = GeomUtils.getPolygonCentroid(_vertices);
				_centroidMarker.x = v.x;
				_centroidMarker.y = v.y;

				var pl:PolygonLine = new PolygonLine(_vertices[_vertices.length - 2], _vertices[_vertices.length - 1]);
				addChild(pl);
			}

		}
	}
}

import flash.display.Shape;
import flash.geom.Vector3D;

class VertexMarker extends Shape
{
	public function VertexMarker()
	{
		graphics.beginFill(0);
		graphics.drawCircle(0, 0, 5);
	}
}

class CentroidMarker extends Shape
{
	public function CentroidMarker()
	{
		graphics.beginFill(0xFF0000);
		graphics.drawCircle(0, 0, 5);
	}
}

class PolygonLine extends Shape
{
	public function PolygonLine(from:Vector3D, to:Vector3D)
	{
		graphics.lineStyle(1);
		graphics.moveTo(from.x, from.y);
		graphics.lineTo(to.x, to.y);

		var delta:Vector3D = to.subtract(from);
		delta.scaleBy(0.5);
		var half:Vector3D = from.add(delta);

		graphics.moveTo(half.x, half.y);

		var cross:Vector3D = delta.crossProduct(Vector3D.Z_AXIS);
		cross.normalize();
		cross.scaleBy(5);

		var d_normal:Vector3D = delta.clone();
		d_normal.normalize();
		d_normal.scaleBy(5);

		var line:Vector3D = half.subtract(cross);
		line.decrementBy(d_normal);

		graphics.lineTo(line.x, line.y);

		cross.negate();
		line = half.subtract(cross);
		line.decrementBy(d_normal);

		graphics.moveTo(half.x, half.y);
		graphics.lineTo(line.x, line.y);

	}
}
