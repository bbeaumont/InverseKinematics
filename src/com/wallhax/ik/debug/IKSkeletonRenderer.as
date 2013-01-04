package com.wallhax.ik.debug
{
	import com.wallhax.ik.IKBone;
	import com.wallhax.ik.IKJoint;
	import com.wallhax.ik.IKSkeleton;

	import flash.display.Graphics;
	import flash.geom.Vector3D;

	public class IKSkeletonRenderer
	{

		private var _graphics:Graphics;
		private var _skeleton:IKSkeleton;

		public function IKSkeletonRenderer(skeleton:IKSkeleton, graphics:Graphics)
		{
			_skeleton = skeleton;
			_graphics = graphics;
		}

		public function render():void
		{
			_graphics.clear();
			_graphics.lineStyle(1);
			_graphics.beginFill(0, 0.2);

			var joint:IKJoint = _skeleton.root;
			renderJoint(joint);
			renderChain(joint.bone);

			_graphics.beginFill(0, 0.0);
			_graphics.drawCircle(_skeleton.root.position.x, _skeleton.root.position.y, _skeleton.totalLength);
		}

		private function renderChain(bone:IKBone):void
		{
			var joint:IKJoint = bone.joint;
			renderBone(bone.joint.parent, bone);
			renderJoint(joint);
			while (joint)
			{
				if (joint.isSubBase)
				{
					for (var i:int = 0, len:int = joint.bones.length; i < len; i++)
					{
						var bone:IKBone = joint.bones[i];
						renderChain(bone);
					}
				}
				else if (joint.isEnd)
				{
					break;
				}
				else
				{
					renderBone(joint, joint.bone);
				}
				joint = joint.bone.joint;
			}
		}

		private function renderBone(preJoint:IKJoint, bone:IKBone):void
		{
			_graphics.moveTo(preJoint.position.x, preJoint.position.y);
			_graphics.lineTo(bone.joint.position.x, bone.joint.position.y);
			renderJoint(bone.joint);
		}

		private static const JOINT_SIZE:int = 10;

		private function renderJoint(joint:IKJoint):void
		{
			_graphics.drawCircle(joint.position.x, joint.position.y, JOINT_SIZE);
			_graphics.lineStyle(3, 0xFF0000);
			_graphics.moveTo(joint.position.x, joint.position.y);
			var rot:Vector3D = joint.transform.transformVector(new Vector3D(0, JOINT_SIZE, 0));
			_graphics.lineTo(rot.x, rot.y);
			_graphics.lineStyle(1, 0);
		}
	}
}
