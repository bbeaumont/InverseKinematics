package com.wallhax.ik
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class Bone
	{
		public var children:Vector.<Bone> = new Vector.<Bone>();
		public var parent:Bone;
		public var transform:Matrix3D = new Matrix3D();
		public var length:Number = 0.0;
		private var _globalTransform:Matrix3D = new Matrix3D();

		public function get globalTransform():Matrix3D
		{
			return _globalTransform;
		}

		public function get globalPosition():Vector3D
		{
			return _globalTransform.position;
		}

		public function set globalPosition(globalPosition:Vector3D):void
		{
			transform.identity();

			var bone:Bone = parent;
			while (bone)
			{
				transform.prepend(bone.transform);
				bone = bone.parent;
			}
			transform.invert();
			transform.prependTranslation(globalPosition.x, globalPosition.y, globalPosition.z);

			updateGlobalTransform();
		}

		public function get hasChildren():Boolean
		{
			return children.length > 0;
		}

		public function get isEndEffector():Boolean
		{
			return children.length == 0 && length == 0.0;
		}

		public function get isSubBase():Boolean
		{
			return children.length > 1;
		}

		public function get position():Vector3D
		{
			return transform.position;
		}

		public function set position(value:Vector3D):void
		{
			transform.position = value;
			updateGlobalTransform();
		}

		public function createChild(length:Number, angle:Number = 0.0):Bone
		{
			var childTransform:Matrix3D = new Matrix3D();
			childTransform.prependRotation(angle, Vector3D.Z_AXIS);
			childTransform.prependTranslation(0.0, this.length, 0.0);

			var child:Bone = new Bone();
			child.parent = this;
			child.length = length;
			child.transform = childTransform;
			child.updateGlobalTransform();

			children.push(child);

			return child;
		}

		public function createEndEffector():Bone
		{
			return createChild(0.0, 0.0);
		}

		public function updateGlobalTransform():void
		{
			if (parent)
			{
				globalTransform.copyFrom(parent.globalTransform);
				globalTransform.prepend(transform);
			}
			else
			{
				globalTransform.copyFrom(transform);
			}
		}
	}
}
