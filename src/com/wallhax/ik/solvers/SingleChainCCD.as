package com.wallhax.ik.solvers
{
	import com.wallhax.ik.Bone;
	import com.wallhax.ik.Skeleton;

	import flash.geom.Vector3D;

	public class SingleChainCCD implements Solver
	{
		private static const MAX_TRIES:int = 100;
		private static const TARGET_THRESHOLD:Number = 0.1;
		private static const MAX_ANGLE:Number = 0.1;

		private var _bonePosition:Vector3D = new Vector3D();
		private var _boneToEndDelta:Vector3D = new Vector3D();
		private var _boneToTargetDelta:Vector3D = new Vector3D();
		private var _cosAngle:Number = 0.0;
		private var _crossResult:Vector3D = new Vector3D();
		private var _endBone:Bone;
		private var _endEffectorPosition:Vector3D = new Vector3D();
		private var _targetPosition:Vector3D;
		private var _tries:int;
		private var _turnAngle:Number = 0.0;

		private var _skeleton:Skeleton;

		public function set skeleton(value:Skeleton):void
		{
			_skeleton = value;
			_endBone = getEndJoint();
		}

		private var _target:Vector3D;

		public function set target(value:Vector3D):void
		{
			_targetPosition = value;
			_target = value;
		}

		public function solve():void
		{
			if (!_targetPosition)
				return;

			_tries = 0;

			var nextBone:Bone;
			var bone:Bone = _endBone.parent;

			while (_tries++ < MAX_TRIES && bone && _targetPosition.subtract(_endEffectorPosition).lengthSquared > TARGET_THRESHOLD)
			{
				nextBone = bone.children[0];

				_bonePosition.copyFrom(bone.globalPosition);
				_endEffectorPosition.copyFrom(_endBone.globalPosition);
				_targetPosition.copyFrom(_target);

				if (_endEffectorPosition.subtract(_targetPosition).lengthSquared > TARGET_THRESHOLD)
				{
					_boneToEndDelta = _endEffectorPosition.subtract(_bonePosition);
					_boneToEndDelta.normalize();

					_boneToTargetDelta = _targetPosition.subtract(_bonePosition);
					_boneToTargetDelta.normalize();

					_cosAngle = _boneToTargetDelta.dotProduct(_boneToEndDelta);

					if (_cosAngle < 0.99999)
					{
						_crossResult = _boneToTargetDelta.crossProduct(_boneToEndDelta);
						if (_crossResult.z != 0.0)
						{
							_turnAngle = Math.acos(_cosAngle);

							if (_turnAngle > MAX_ANGLE)
								_turnAngle = MAX_ANGLE;

							var components:Vector.<Vector3D> = bone.transform.decompose();
							var rotation:Vector3D = components[1];
							if (_crossResult.z > 0.0)
							{
								rotation.z -= _turnAngle;
							}
							else if (_crossResult.z < 0.0)
							{
								rotation.z += _turnAngle;
							}
							bone.transform.recompose(components);
						}
					}
				}
				_skeleton.updateTransforms();
				if (bone == _skeleton.root)
				{
					bone = _endBone.parent;
				}
				else
				{
					bone = bone.parent;
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
	}
}