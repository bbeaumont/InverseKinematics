package com.wallhax.ik
{
	public class Skeleton
	{
		public var root:Bone;

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

		public function addRoot(rootJoint:Bone):void
		{
			root = rootJoint;
		}

		public function updateTransforms():void
		{
			var bone:Bone = root;
			while (bone)
			{
				bone.updateGlobalTransform();
				bone = (bone.hasChildren) ? bone.children[0] : null;
			}
		}

		private function getLength():void
		{
			if (isNaN(_totalLength))
			{
				_totalLength = 0.0;
				var bone:Bone = root;
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
	}
}
