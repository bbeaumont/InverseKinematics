package com.wallhax.ik.solvers
{
	import com.wallhax.ik.IKBone;
	import com.wallhax.ik.IKSkeleton;

	import flash.geom.Vector3D;

	public class SingleChainFABRIKSolver implements IKSolver
	{
		private static const TOL:Number = 0.1;
		private static const TOL_SQ:Number = TOL*TOL;
		private var _endJoint:IKBone;

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

			_dtp = _endJoint.globalPosition;
			const targetDelta:Number = _skeleton.root.globalPosition.subtract(_target).lengthSquared;

			if (targetDelta > _skeleton.totalLengthSquared)
			{
				solveUnreachable(_target);
			}
			else
			{
				solveReachable(_target);
			}
		}

		private var _dtp:Vector3D;

		private function solveReachable(target:Vector3D):void
		{
			var difa:Number = _endJoint.globalPosition.subtract(target).lengthSquared;
			var tries:int = 0;
			while (difa > TOL_SQ && tries++ < 100)
			{
				_dtp = _endJoint.globalPosition;
				_dtp.x = _dtp.x + (target.x - _dtp.x)*_damping;
				_dtp.y = _dtp.y + (target.y - _dtp.y)*_damping;
				_endJoint.globalPosition = _dtp;
				forwardReaching(target, _endJoint);
				backwardReaching(target);
				difa = _endJoint.globalPosition.subtract(target).lengthSquared;
			}
		}

		private function backwardReaching(target:Vector3D):void
		{

			var r:Number, gamma:Number, gamma2:Number;
			var nextBone:IKBone;
			var bone:IKBone = _skeleton.root;
			while (!bone.isEnd)
			{
				nextBone = bone.children[0];

				r = nextBone.globalPosition.subtract(bone.globalPosition).length;

				gamma = bone.length/r;
				gamma2 = 1 - gamma;

				var p:Vector3D = nextBone.globalPosition;
				p.x = gamma2*bone.globalPosition.x + gamma*nextBone.globalPosition.x;
				p.y = gamma2*bone.globalPosition.y + gamma*nextBone.globalPosition.y;
				nextBone.globalPosition = p;
				bone.globalTransform.pointAt(nextBone.globalPosition);

				bone = nextBone;
			}
		}

		private function forwardReaching(target:Vector3D, endJoint:IKBone):void
		{

			var r:Number, gamma:Number, gamma2:Number;
			var nextBone:IKBone;
			var bone:IKBone = endJoint;

			while (bone)
			{
				if (bone != _skeleton.root || !_skeleton.root.fixed)
				{
					if (!bone.isEnd)
					{
						nextBone = bone.children[0];

						r = nextBone.globalPosition.subtract(bone.globalPosition).length;
						gamma = bone.length/r;
						gamma2 = 1 - gamma;

						var p:Vector3D = bone.globalPosition;

						p.x = gamma2*nextBone.globalPosition.x + gamma*bone.globalPosition.x;
						p.y = gamma2*nextBone.globalPosition.y + gamma*bone.globalPosition.y;

						bone.globalPosition = p;

					}

					bone = bone.parent;
				}
				else
				{
					break;
				}
			}
		}

		private function getEndJoint():IKBone
		{
			var endBone:IKBone = _skeleton.root;
			do
			{
				if (endBone.hasChildren)
					endBone = endBone.children[0];
				else
					break;
			}
			while (true);

			return endBone;
		}

		private function solveUnreachable(target:Vector3D):void
		{
			var r:Number, gamma:Number, gamma2:Number;
			var nextBone:IKBone;
			var bone:IKBone = _skeleton.root;
			while (bone.hasChildren)
			{
				nextBone = bone.children[0];

				r = target.subtract(bone.globalPosition).length;
				gamma = bone.length/r;
				gamma2 = 1 - gamma;

				var p:Vector3D = nextBone.globalPosition;

				p.x = gamma2*bone.globalPosition.x + gamma*target.x;
				p.y = gamma2*bone.globalPosition.y + gamma*target.y;
				nextBone.globalPosition = p;
				bone.globalTransform.pointAt(nextBone.globalPosition);

				bone = nextBone;
			}
		}
	}
}
