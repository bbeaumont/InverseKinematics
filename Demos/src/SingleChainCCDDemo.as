package
{

	import com.wallhax.ik.Bone;
	import com.wallhax.ik.Skeleton;
	import com.wallhax.ik.debug.SkeletonRenderer;
	import com.wallhax.ik.solvers.SingleChainCCD;
	import com.wallhax.ik.solvers.Solver;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.utils.getTimer;

	[SWF(frameRate="60", width="1000", height="1000", backgroundColor="#EEEEEE")]
	public class SingleChainCCDDemo extends Sprite
	{
		private const GAP:int = 30;
		private const CENTER:Point = new Point(500, 500);
		private var _debugCanvas:Shape;
		private var _output:TextField;
		private var _skeleton:Skeleton;
		private var _skeletonRenderer:SkeletonRenderer;
		private var _solver:Solver;
		private var _target:Vector3D = new Vector3D();

		public function SingleChainCCDDemo()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_output = new TextField();
			addChild(_output);

			buildSkeleton();
			createSolver();
			createDebug();

			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function createDebug():void
		{
			_debugCanvas = new Shape();
			addChild(_debugCanvas);

			_skeletonRenderer = new SkeletonRenderer(_skeleton, _debugCanvas.graphics, 0xFF0000);
		}

		private function createSolver():void
		{
			_solver = new SingleChainCCD();
			_solver.skeleton = _skeleton;
//			_skeleton.updateTransforms();
		}

		private function buildSkeleton():void
		{
			var rootBone:Bone = new Bone();
			rootBone.position = new Vector3D(CENTER.x, CENTER.y);
			rootBone.length = GAP;

			var bone:Bone = rootBone.createChild(GAP, 0.0);
			for (var i:int = 0; i < 10; i++)
				bone = bone.createChild(GAP, 0.0);
			bone.createEndEffector();

			_skeleton = new Skeleton();
			_skeleton.addRoot(rootBone);
		}

		private function runSolver():void
		{
			if (!_solver)
				return;

			_target.x = stage.mouseX;
			_target.y = stage.mouseY;
			_solver.target = _target;

			const t:int = getTimer();
			_solver.solve();
			_output.text += 'FABRIK Solver: ' + (getTimer() - t).toString() + '\n';
		}

		private function clearOutput():void
		{
			_output.text = '';
		}

		private function runRenderer():void
		{
			if (_skeletonRenderer)
				_skeletonRenderer.render();
		}

		private function onEnterFrame(event:Event):void
		{
			clearOutput();
			runSolver();
			runRenderer();
		}
	}
}
