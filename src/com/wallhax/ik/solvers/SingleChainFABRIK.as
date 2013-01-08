package com.wallhax.ik.solvers
{
	import com.wallhax.ik.Bone;
	import com.wallhax.ik.Skeleton;

	import flash.geom.Vector3D;

	public class SingleChainFABRIK implements Solver
	{
		private static const TOL:Number = 0.1;
		private static const TOL_SQ:Number = TOL*TOL;

		private var _endEffector:Bone;
		private var _damping:Number = 1.0;

		public function set damping(damping:Number):void
		{
			_damping = damping;
		}

		private var _skeleton:Skeleton;

		public function set skeleton(value:Skeleton):void
		{
			_skeleton = value;
			_endEffector = getEndJoint();
		}

		private var _target:Vector3D;

		public function set target(value:Vector3D):void
		{
			_target = value;
		}

		public function solve():void
		{
			if (!_target)
				return;

			const targetDelta:Number = _skeleton.root.globalPosition.subtract(_target).lengthSquared;

			if (targetDelta > _skeleton.totalLengthSquared)
				solveUnreachable();
			else
				solveReachable();
		}

		private function solveReachable():void
		{
			var targetToEndEffectorDelta:Number = _endEffector.globalPosition.subtract(_target).lengthSquared;
			var tries:int = 0;
			var endEffectorPosition:Vector3D;
			while (targetToEndEffectorDelta > TOL_SQ && tries++ < 100)
			{
				endEffectorPosition = _endEffector.globalPosition;
				endEffectorPosition.x = endEffectorPosition.x + (_target.x - endEffectorPosition.x)*_damping;
				endEffectorPosition.y = endEffectorPosition.y + (_target.y - endEffectorPosition.y)*_damping;
				_endEffector.globalPosition = endEffectorPosition;

				forwardReaching();
				backwardReaching();

				targetToEndEffectorDelta = _endEffector.globalPosition.subtract(_target).lengthSquared;
			}
		}

		private function backwardReaching():void
		{
			var delta:Number, gamma:Number, inverseGamma:Number;
			var nextBone:Bone;
			var globalPosition:Vector3D;
			var bone:Bone = _skeleton.root;

			while (!bone.isEndEffector)
			{
				nextBone = bone.children[0];

				delta = nextBone.globalPosition.subtract(bone.globalPosition).length;

				gamma = bone.length/delta;
				inverseGamma = 1.0 - gamma;

				globalPosition = nextBone.globalPosition;
				globalPosition.x = inverseGamma*bone.globalPosition.x + gamma*nextBone.globalPosition.x;
				globalPosition.y = inverseGamma*bone.globalPosition.y + gamma*nextBone.globalPosition.y;

				nextBone.globalPosition = globalPosition;
				bone.globalTransform.pointAt(nextBone.globalPosition, Vector3D.X_AXIS);

				bone = nextBone;
			}
		}

		private function forwardReaching():void
		{
			var delta:Number, gamma:Number, inverseGamma:Number;
			var nextBone:Bone;
			var globalPosition:Vector3D;
			var bone:Bone = _endEffector;

			while (bone)
			{
				if (bone != _skeleton.root)
				{
					if (!bone.isEndEffector)
					{
						nextBone = bone.children[0];

						delta = nextBone.globalPosition.subtract(bone.globalPosition).length;
						gamma = bone.length/delta;
						inverseGamma = 1.0 - gamma;

						globalPosition = bone.globalPosition;
						globalPosition.x = inverseGamma*nextBone.globalPosition.x + gamma*bone.globalPosition.x;
						globalPosition.y = inverseGamma*nextBone.globalPosition.y + gamma*bone.globalPosition.y;

						bone.globalPosition = globalPosition;
					}
					bone = bone.parent;
				}
				else
				{
					break;
				}
			}
		}

		private function getEndJoint():Bone
		{
			var endBone:Bone = _skeleton.root;
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

		private function solveUnreachable():void
		{
			var delta:Number, gamma:Number, inverseGamma:Number;
			var nextBone:Bone;
			var globalPosition:Vector3D;
			var bone:Bone = _skeleton.root;

			while (bone.hasChildren)
			{
				nextBone = bone.children[0];

				delta = _target.subtract(bone.globalPosition).length;
				gamma = bone.length/delta;
				inverseGamma = 1.0 - gamma;

				globalPosition = nextBone.globalPosition;
				globalPosition.x = inverseGamma*bone.globalPosition.x + gamma*_target.x;
				globalPosition.y = inverseGamma*bone.globalPosition.y + gamma*_target.y;

				nextBone.globalPosition = globalPosition;
				bone.globalTransform.pointAt(nextBone.globalPosition, Vector3D.X_AXIS);

				bone = nextBone;
			}
		}
	}
}
