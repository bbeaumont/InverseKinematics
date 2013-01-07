package com.wallhax.ik.solvers
{
	import com.wallhax.ik.IKBone;
	import com.wallhax.ik.IKSkeleton;

	import flash.geom.Vector3D;

	public class SingleChainCCDSolver implements IKSolver
	{
		private const MAX_TRIES:int = 100;
		private const IK_POS_THRESH:Number = 0.1;
		private const MAX_ANGLE:Number = 0.1;
		private var bonePosition:Vector3D = new Vector3D();
		private var boneToEndDelta:Vector3D = new Vector3D();
		private var boneToTargetDelta:Vector3D = new Vector3D();
		private var cosAngle:Number = 0.0;
		private var crossResult:Vector3D = new Vector3D();
		private var endBone:IKBone;
		private var endEffectorPosition:Vector3D = new Vector3D();
		private var targetPosition:Vector3D;
		private var tries:int;
		private var turnAngle:Number = 0.0;

		private var _skeleton:IKSkeleton;

		public function get skeleton():IKSkeleton
		{
			return _skeleton;
		}

		public function set skeleton(value:IKSkeleton):void
		{
			_skeleton = value;
			endBone = getEndJoint();
		}

		private var _target:Vector3D;

		public function get target():Vector3D
		{
			return _target;
		}

		public function set target(value:Vector3D):void
		{
			targetPosition = value;
			_target = value;
		}

		public function set damping(damping:Number):void
		{

		}

		public function solve():void
		{
			if (!targetPosition)
				return;

			tries = 0;

			var nextBone:IKBone;
			var bone:IKBone = endBone.parent;

			while (tries++ < MAX_TRIES && bone && targetPosition.subtract(endEffectorPosition).lengthSquared > IK_POS_THRESH)
			{
				nextBone = bone.children[0];

				bonePosition.copyFrom(bone.globalPosition);
				endEffectorPosition.copyFrom(endBone.globalPosition);
				targetPosition.copyFrom(_target);

				if (endEffectorPosition.subtract(targetPosition).lengthSquared > IK_POS_THRESH)
				{
					boneToEndDelta = endEffectorPosition.subtract(bonePosition);
					boneToTargetDelta = targetPosition.subtract(bonePosition);

					boneToEndDelta.normalize();
					boneToTargetDelta.normalize();

					cosAngle = boneToTargetDelta.dotProduct(boneToEndDelta);

					if (cosAngle < 0.99999)
					{
						crossResult = boneToTargetDelta.crossProduct(boneToEndDelta);
						turnAngle = Math.acos(cosAngle);

						if (turnAngle > MAX_ANGLE)
							turnAngle = MAX_ANGLE;

						var v:Vector.<Vector3D> = bone.transform.decompose();
						if (crossResult.z > 0.0)
						{
							v[1].z = v[1].z - turnAngle;
						}
						else if (crossResult.z < 0.0) // ROTATE COUNTER CLOCKWISE
						{
							v[1].z = v[1].z + turnAngle;
						}
						bone.transform.recompose(v);
					}

				}
				skeleton.updateTransforms();
				if (bone == _skeleton.root)
				{
					bone = endBone.parent;
				}
				else
				{
					bone = bone.parent;
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
	}
}