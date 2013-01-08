package com.wallhax.ik.solvers
{
	import com.wallhax.ik.Skeleton;

	import flash.geom.Vector3D;

	public interface Solver
	{
		function set skeleton(value:Skeleton):void;

		function solve():void;

		function set target(value:Vector3D):void;

		function set damping(damping:Number):void;
	}
}
