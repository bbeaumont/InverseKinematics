package com.wallhax.ik
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class IKJoint
	{
		public var bones:Vector.<IKBone> = new Vector.<IKBone>();
		public var fixed:Boolean;
		public var parent:IKJoint;
		public var transform:Matrix3D = new Matrix3D();

		public function get bone():IKBone
		{
			return (bones.length) ? bones[0] : null;
		}

		public function get isEnd():Boolean
		{
			return bones.length == 0;
		}

		public function get isSubBase():Boolean
		{
			return bones.length > 1;
		}

		public function IKJoint()
		{
		}

		public function createBone(length:Number, angle:Number):IKBone
		{
			var joint:IKJoint = new IKJoint();
			joint.parent = this;
			var p:Vector3D = new Vector3D();
			p.x = Math.sin(angle);
			p.y = Math.cos(angle);
			p.scaleBy(length);
			joint.transform.position = transform.position.add(p);
			joint.transform.pointAt(transform.position);

			var bone:IKBone = new IKBone(joint);
			bone.length = length;
			bones.push(bone);
			return bone;
		}

		public function get position():Vector3D
		{
			return transform.position;
		}

		public function set position(value:Vector3D):void
		{
			transform.position = value;
		}

	}
}
