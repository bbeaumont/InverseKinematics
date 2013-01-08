package com.wallhax.ik.debug
{
	import com.wallhax.ik.Bone;
	import com.wallhax.ik.Skeleton;

	import flash.display.Graphics;
	import flash.geom.Vector3D;

	public class SkeletonRenderer
	{

		private static const JOINT_SIZE:int = 10;

		private var _color:uint;
		private var _graphics:Graphics;
		private var _skeleton:Skeleton;

		public function SkeletonRenderer(skeleton:Skeleton, graphics:Graphics, color:uint)
		{
			_skeleton = skeleton;
			_graphics = graphics;
			_color = color;
		}

		public function render():void
		{
			_graphics.clear();
			_graphics.lineStyle(1, _color);
			_graphics.beginFill(_color, 0.2);

			var rootBone:Bone = _skeleton.root;
			_graphics.moveTo(rootBone.position.x, rootBone.position.y);
			renderChain(rootBone);

			_graphics.beginFill(_color, 0.0);
			_graphics.drawCircle(_skeleton.root.position.x, _skeleton.root.position.y, _skeleton.totalLength);
		}

		private function renderChain(rootBone:Bone):void
		{

			var bone:Bone = rootBone;
			while (true)
			{
				if (bone.length > 0)
					renderBone(bone);
				else
					renderEffector(bone);

				if (bone.hasChildren)
				{

					bone = bone.children[0];
				}
				else
					break;
			}
		}

		private function renderEffector(bone:Bone):void
		{
			_graphics.drawCircle(bone.globalPosition.x, bone.globalPosition.y, 5);
		}

		private function renderBone(bone:Bone):void
		{
			var v:Vector3D;
			const quarter:Number = bone.length*0.25;
			_graphics.moveTo(bone.globalPosition.x, bone.globalPosition.y);
			v = bone.globalTransform.transformVector(new Vector3D(5, quarter, 5));
			_graphics.lineTo(v.x, v.y);
			v = bone.globalTransform.transformVector(new Vector3D(0, bone.length, 0));
			_graphics.lineTo(v.x, v.y);
			v = bone.globalTransform.transformVector(new Vector3D(-5, quarter, -5));
			_graphics.lineTo(v.x, v.y);
			_graphics.lineTo(bone.globalPosition.x, bone.globalPosition.y);


//			_graphics.drawCircle(bone.position.x, bone.position.y, JOINT_SIZE);
//
//			_graphics.lineStyle(2, 0xFF0000);
//			_graphics.moveTo(bone.position.x, bone.position.y);
//			_graphics.lineTo(rot.x, rot.y);
//			_graphics.lineStyle(1, 0);
//			_graphics.moveTo(bone.position.x, bone.position.y);
//			_graphics.lineTo(bone.position.x, bone.position.y);
		}
	}
}
