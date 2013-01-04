package com.wallhax.ik
{
	public class IKBone
	{
		public var joint:IKJoint;
		public var length:Number = 0.0;

		public function IKBone(joint:IKJoint)
		{
			this.joint = joint;
		}
	}
}
