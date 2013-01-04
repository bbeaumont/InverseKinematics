package com.wallhax.ik.solvers
{
	import com.wallhax.ik.IKJoint;
	import com.wallhax.ik.IKSkeleton;

	import flash.geom.Vector3D;

	public class SingleChainFABRIKSolver implements IKSolver
	{
		private static const TOL:Number = 0.1;
		private static const TOL_SQ:Number = TOL*TOL;
		private var _endJoint:IKJoint;

		private var _damping:Number = 1.0;

		public function set damping(damping:Number):void
		{
			_damping = damping;
		}

		private var _skeleton:IKSkeleton;

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

//		private static const DAMPING:Number = 0.001;

		public function set target(value:Vector3D):void
		{
			_target = value;
		}

		public function solve():void
		{
			if (!_target)
				return;

//			_dtp = _endJoint.position;
//			const targetDelta:Number = _skeleton.root.position.subtract(_dtp).length;
//			if (targetDelta > _skeleton.totalLength)
//			{
//				solveUnreachable(_target);
//			}
//			else
//			{
				solveReachable(_target);
//			}
		}

		private var _dtp:Vector3D;

		private function solveReachable(target:Vector3D):void
		{
			var difa:Number = _endJoint.position.subtract(target).lengthSquared;
			var tries:int = 0;
			while (difa > TOL_SQ && tries++ < 100)
			{
				_dtp = _endJoint.position;
				_dtp.x = _dtp.x + (target.x - _dtp.x)*_damping;
				_dtp.y = _dtp.y + (target.y - _dtp.y)*_damping;
				_endJoint.position = _dtp;
				forwardReaching(target, _endJoint);
				backwardReaching(target);
				difa = _endJoint.position.subtract(target).lengthSquared;
			}
		}

		private function backwardReaching(target:Vector3D):void
		{

			var r:Number, gamma:Number, gamma2:Number;
			var nextJoint:IKJoint;
			var joint:IKJoint = _skeleton.root;
			while (joint.bone)
			{
				nextJoint = joint.bone.joint;

				r = nextJoint.position.subtract(joint.position).length;

				gamma = joint.bone.length/r;
				gamma2 = 1 - gamma;

				var p:Vector3D = nextJoint.position;
				p.x = gamma2*joint.position.x + gamma*nextJoint.position.x;
				p.y = gamma2*joint.position.y + gamma*nextJoint.position.y;
				nextJoint.position = p;
				nextJoint.transform.pointAt(joint.transform.position);

				joint = nextJoint;
			}
		}

		private function forwardReaching(target:Vector3D, endJoint:IKJoint):void
		{

			var r:Number, gamma:Number, gamma2:Number;
			var nextJoint:IKJoint;
			var joint:IKJoint = endJoint;

			while (joint)
			{
				if (joint != _skeleton.root || !_skeleton.root.fixed)
				{
					if (joint.bone)
					{
						nextJoint = joint.bone.joint;

						r = nextJoint.position.subtract(joint.position).length;
						gamma = joint.bone.length/r;
						gamma2 = 1 - gamma;

						var p:Vector3D = joint.position;

						p.x = gamma2*nextJoint.position.x + gamma*joint.position.x;
						p.y = gamma2*nextJoint.position.y + gamma*joint.position.y;

						joint.position = p;

					}

					joint = joint.parent;
				}
				else
				{
					break;
				}
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

		private function solveUnreachable(target:Vector3D):void
		{
			var r:Number, gamma:Number, gamma2:Number;
			var nextJoint:IKJoint;
			var joint:IKJoint = _skeleton.root;
			while (joint.bone)
			{
				nextJoint = joint.bone.joint;

				r = target.subtract(joint.position).length;
				gamma = joint.bone.length/r;
				gamma2 = 1 - gamma;

				var p:Vector3D = nextJoint.position;

				p.x = gamma2*joint.position.x + gamma*target.x;
				p.y = gamma2*joint.position.y + gamma*target.y;
				nextJoint.transform.position = p;

				joint = nextJoint;
			}
		}
	}
}
