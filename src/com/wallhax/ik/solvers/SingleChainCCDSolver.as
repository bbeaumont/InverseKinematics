package com.wallhax.ik.solvers
{
	import com.wallhax.ik.IKJoint;
	import com.wallhax.ik.IKSkeleton;
	import com.wallhax.ik.utils.GeomUtils;

	import flash.geom.Matrix3D;

	import flash.geom.Vector3D;

	public class SingleChainCCDSolver implements IKSolver
	{
		private const MAX_TRIES:int = 100;
		private const IK_POS_THRESH:Number = 1.0;

		private var _cosAngle:Number = 0.0;
		private var _crossResult:Vector3D = new Vector3D();
		private var _curEnd:Vector3D = new Vector3D();
		private var _curVector:Vector3D = new Vector3D();
//		private var _target:Vector3D = new Vector3D();
//		private var _link:int;
		private var _rootPos:Vector3D = new Vector3D();
		private var _targetVector:Vector3D = new Vector3D();
		private var _tries:int;
		private var _turnAngle:Number = 0.0;
		private var _turnDeg:Number = 0.0;

		public var m_Damping:Boolean = true;

		private var _skeleton:IKSkeleton;
		private var _endJoint:IKJoint;

		public function get skeleton():IKSkeleton
		{
			return _skeleton;
		}

		public function set skeleton(value:IKSkeleton):void
		{
			_skeleton = value;
			_endJoint = getEndJoint();
		}

		private var _target:Vector3D;

		public function get target():Vector3D
		{
			return _target;
		}

		public function set target(value:Vector3D):void
		{
			_target = value;
//			_target = _target;
		}

		public function solve():void
		{
			if (!_target)
				return;

			_tries = 0;

			var nextJoint:IKJoint;
			var joint:IKJoint = _endJoint.parent;

			trace(_target.subtract(_curEnd).lengthSquared);
			while (_tries++ < MAX_TRIES && joint && _target.subtract(_curEnd).lengthSquared > IK_POS_THRESH)
			{
					nextJoint = joint.bone.joint;

					_rootPos.copyFrom(joint.position);
					_curEnd.copyFrom(_endJoint.position);
					_target.copyFrom(_target);

//					if (_target.subtract(_curEnd).lengthSquared > IK_POS_THRESH)
//					{
						_curVector = _curEnd.subtract(_rootPos);
						_targetVector = _target.subtract(_rootPos);
						_curVector.normalize();
						_targetVector.normalize();

						_cosAngle = _targetVector.dotProduct(_curVector);

						if (_cosAngle < 0.99999)
						{
							_crossResult = _targetVector.crossProduct(_curVector);

							if (_crossResult.z > 0.0)
							{
								_turnAngle = Math.acos(_cosAngle);
								GeomUtils.rotate2D(joint.position, _turnAngle);
							}
							else if (_crossResult.z < 0.0) // ROTATE COUNTER CLOCKWISE
							{
								_turnAngle = Math.acos(_cosAngle);
								GeomUtils.rotate2D(joint.position, -_turnAngle);
							}
						}

//					}
					if (joint == _skeleton.root)
						joint = _endJoint.parent;
					else
						joint = joint.parent;

			}

		}

		private function getEndJoint():IKJoint
		{
			var endJoint:IKJoint = _skeleton.root;
			while (endJoint.bone)
			{
				endJoint = endJoint.bone.joint;
			}
			return endJoint;
		}

		public function set damping(damping:Number):void
		{
		}
	}
}