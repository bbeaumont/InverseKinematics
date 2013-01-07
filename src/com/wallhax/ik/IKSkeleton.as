package com.wallhax.ik
{
	import flash.geom.Matrix3D;

	public class IKSkeleton
	{
		public var root:IKBone;

		private var _totalLength:Number;

		public function get totalLength():Number
		{
			getLength();
			return _totalLength;
		}

		private var _totalLengthSquared:Number;

		public function get totalLengthSquared():Number
		{
			getLength();
			return _totalLengthSquared;
		}

		public function IKSkeleton()
		{
		}

		public function addRoot(rootJoint:IKBone):void
		{
			root = rootJoint;
		}

		private function getLength():void
		{
			if (isNaN(_totalLength))
			{
				_totalLength = 0.0;
				var bone:IKBone = root;
				while (bone)
				{
					_totalLength += bone.length;
					if (bone.hasChildren)
						bone = bone.children[0];
					else
						bone = null;
				}
				_totalLengthSquared = _totalLength*_totalLength;
			}
		}

		public function updateTransforms():void
		{
			var bone:IKBone = root;
			while (bone)
			{
				if (bone.parent)
				{
					bone.globalTransform.copyFrom(bone.parent.globalTransform);
					bone.globalTransform.prepend(bone.transform);
				}
				else
				{
					bone.globalTransform.copyFrom(bone.transform);
				}

				bone = (bone.hasChildren) ? bone.children[0] : null;
			}
		}
	}
}
