package com.wallhax.ik.solvers
{
	import com.wallhax.ik.IKSkeleton;

	import flash.geom.Vector3D;

	public interface IKSolver
	{
		function get skeleton():IKSkeleton;

		function set skeleton(value:IKSkeleton):void;

		function solve():void;

		function get target():Vector3D;

		function set target(value:Vector3D):void;

		function set damping(damping:Number):void;
	}
}
