package
{

	import com.wallhax.ik.Bone;
	import com.wallhax.ik.Skeleton;
	import com.wallhax.ik.debug.SkeletonRenderer;
	import com.wallhax.ik.solvers.Solver;
	import com.wallhax.ik.solvers.SingleChainCCD;
	import com.wallhax.ik.solvers.SingleChainFABRIK;

	import flash.display.Graphics;

	import flash.display.Shape;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;

	[SWF(frameRate="60", width="1000", height="1000", backgroundColor="#EEEEEE")]
	public class Demos extends Sprite
	{
		private const GAP:int = 30;
		private const CENTER:Point = new Point(500, 500);

		private var _CCDrenderer:SkeletonRenderer;
		private var _CCDskeleton:Skeleton;
		private var _CCDsolver:Solver;
		private var _debug:TextField;
		private var _target:Vector3D = new Vector3D();
		private var _FABRIKskeleton:Skeleton;
		private var _FABRIKsolver:Solver;
		private var _FABRIKdebug:Shape;
		private var _FABRIKrenderer:SkeletonRenderer;
		private var _CCDdebug:Shape;


		public function Demos()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_debug = new TextField();
			addChild(_debug);

			CCDRoute();
			FABRIKRoute();

			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUpHandler);
		}

		private function FABRIKRoute():void
		{
			var rootBone:Bone = new Bone();
			rootBone.position = new Vector3D(CENTER.x, CENTER.y);
			rootBone.length = GAP;

			generateSingleChain(rootBone);

			_FABRIKskeleton = new Skeleton();
			_FABRIKskeleton.addRoot(rootBone);

			_FABRIKsolver = new SingleChainFABRIK();
			_FABRIKsolver.skeleton = _FABRIKskeleton;

			_FABRIKskeleton.updateTransforms();

			_FABRIKdebug = new Shape();
			addChild(_FABRIKdebug);
			_FABRIKrenderer = new SkeletonRenderer(_FABRIKskeleton, _FABRIKdebug.graphics, 0xFF0000);
		}

		private function CCDRoute():void
		{
			var rootBone:Bone = new Bone();
			rootBone.position = new Vector3D(CENTER.x, CENTER.y);
			rootBone.length = GAP;

			generateSingleChain(rootBone);

			_CCDskeleton = new Skeleton();
			_CCDskeleton.addRoot(rootBone);

			_CCDsolver = new SingleChainCCD();
			_CCDsolver.skeleton = _CCDskeleton;

			_CCDskeleton.updateTransforms();

			_CCDdebug = new Shape();
			addChild(_CCDdebug);
			_CCDrenderer = new SkeletonRenderer(_CCDskeleton, _CCDdebug.graphics, 0x006600);
		}

		private function generateSingleChain(bone:Bone):void
		{
			bone = bone.createChild(GAP, 0.0);
			for (var i:int = 0; i < 10; i++)
				bone = bone.createChild(GAP, 0.0);
			bone.createEndEffector();
		}

		private function onEnterFrame(event:Event):void
		{
			clearOutput();
			runCCDSolver();
			runFABRIKSolver();
			runRenderers();
		}

		private function runFABRIKSolver():void
		{
			if (!_FABRIKsolver)
				return;

			_target.x = stage.mouseX;
			_target.y = stage.mouseY;
			_FABRIKsolver.target = _target;

			const t:int = getTimer();
			_FABRIKsolver.solve();
			_debug.text += 'FABRIK Solver: ' + (getTimer() - t).toString() + '\n';
		}

		private function clearOutput():void
		{
			_debug.text = '';
		}

		private function runRenderers():void
		{
			if (_CCDrenderer)
				_CCDrenderer.render();
			if (_FABRIKrenderer)
				_FABRIKrenderer.render();
		}

		private function runCCDSolver():void
		{
			if (!_CCDsolver)
				return;

			_target.x = stage.mouseX;
			_target.y = stage.mouseY;
			_CCDsolver.target = _target;

			const t:int = getTimer();
			_CCDsolver.solve();
			_debug.text += 'CCD Solver: ' + (getTimer() - t).toString() + '\n';
		}

		private function stage_keyUpHandler(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.PERIOD)
				onEnterFrame(null);
		}
	}
}
