package com.wallhax.ik
{
	import com.wallhax.ik.utils.GeomUtils;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import mx.collections.HierarchicalData;

	public class IKBone
	{
		public var children:Vector.<IKBone> = new Vector.<IKBone>();
		public var fixed:Boolean;
		public var parent:IKBone;
		public var transform:Matrix3D = new Matrix3D();
		public var length:Number = 0.0;
		private var _globalTransform:Matrix3D = new Matrix3D();

		public function get isEnd():Boolean
		{
			return children.length == 0;
		}

		public function get isSubBase():Boolean
		{
			return children.length > 1;
		}

		public function get hasChildren():Boolean
		{
			return children.length > 0;
		}

		public function IKBone()
		{
		}

		public function createChild(length:Number, angle:Number):IKBone
		{
			var child:IKBone = new IKBone();
			child.parent = this;
//			child.transform.prepend(transform);

			var tf:Matrix3D = new Matrix3D();
			tf.prependRotation(GeomUtils.toDeg(angle), new Vector3D(0, 0, 1));
			tf.prependTranslation(0.0, this.length, 0.0);
			child.transform = tf;


//			child.transform.prependRotation(GeomUtils.toDeg(angle), new Vector3D(0, 0, 1));
//			child.transform.prependTranslation(0.0, length, 0.0);
			child.length = length;

			children.push(child);
			return child;
		}

		public function get position():Vector3D
		{
			return transform.position;
		}

		public function set position(value:Vector3D):void
		{
			transform.position = value;
		}

		public function get globalPosition():Vector3D
		{
			return _globalTransform.position;
		}

		public function set globalTransform(globalTransform:Matrix3D):void
		{
			_globalTransform = globalTransform;
		}

		public function get globalTransform():Matrix3D
		{
			return _globalTransform;
		}

		public function set globalPosition(globalPosition:Vector3D):void
		{
			_globalTransform.position = globalPosition;
		}
	}
}
