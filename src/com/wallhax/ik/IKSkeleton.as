package com.wallhax.ik
{
	public class IKSkeleton
	{
		public var root:IKJoint;

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

		public function addRoot(rootJoint:IKJoint):void
		{
			root = rootJoint;
		}

		private function getLength():void
		{
			if (isNaN(_totalLength))
			{
				_totalLength = 0.0;
				var bone:IKBone = root.bone;
				while (bone)
				{
					_totalLength += bone.length;
					bone = bone.joint.bone;
				}
				_totalLengthSquared = _totalLength*_totalLength;
			}
		}
	}
}
