package
{
	import com.wallhax.ik.utils.GeomUtils;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

	[SWF(frameRate="60", width="1000", height="800", backgroundColor="#EEEEEE")]
	public class PointsCentroidDemo extends Sprite
	{
		private var _vertices:Vector.<Vector3D>;
		private var _centroidMarker:CentroidMarker;

		public function PointsCentroidDemo()
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
				var v:Vector3D = GeomUtils.getPointsCentroid(_vertices);
				_centroidMarker.x = v.x;
				_centroidMarker.y = v.y;
			}

		}
	}
}

import flash.display.Shape;

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
