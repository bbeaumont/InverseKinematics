package
{

	import com.wallhax.ik.IKBone;
	import com.wallhax.ik.IKSkeleton;
	import com.wallhax.ik.debug.IKSkeletonRenderer;
	import com.wallhax.ik.solvers.IKSolver;
	import com.wallhax.ik.solvers.SingleChainCCDSolver;
	import com.wallhax.ik.solvers.SingleChainFABRIKSolver;

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
		private const GAP:int = 2;
		private const CENTER:Point = new Point(500, 500);

		private var _CCDrenderer:IKSkeletonRenderer;
		private var _CCDskeleton:IKSkeleton;
		private var _CCDsolver:IKSolver;
		private var _debug:TextField;
		private var _target:Vector3D = new Vector3D();
		private var _FABRIKskeleton:IKSkeleton;
		private var _FABRIKsolver:IKSolver;
		private var _FABRIKdebug:Shape;
		private var _FABRIKrenderer:IKSkeletonRenderer;
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
			var rootBone:IKBone = new IKBone();
			rootBone.fixed = true;
			rootBone.position = new Vector3D(CENTER.x, CENTER.y);
			rootBone.length = GAP;

			generateSingleChain(rootBone);

			_FABRIKskeleton = new IKSkeleton();
			_FABRIKskeleton.addRoot(rootBone);

			_FABRIKsolver = new SingleChainFABRIKSolver();
			_FABRIKsolver.skeleton = _FABRIKskeleton;

			_FABRIKskeleton.updateTransforms();

			_FABRIKdebug = new Shape();
			addChild(_FABRIKdebug);
			_FABRIKrenderer = new IKSkeletonRenderer(_FABRIKskeleton, _FABRIKdebug.graphics, 0xFF0000);
		}

		private function CCDRoute():void
		{
			var rootBone:IKBone = new IKBone();
			rootBone.fixed = true;
			rootBone.position = new Vector3D(CENTER.x, CENTER.y);
			rootBone.length = GAP;

			generateSingleChain(rootBone);

			_CCDskeleton = new IKSkeleton();
			_CCDskeleton.addRoot(rootBone);

			_CCDsolver = new SingleChainCCDSolver();
			_CCDsolver.skeleton = _CCDskeleton;

			_CCDskeleton.updateTransforms();

			_CCDdebug = new Shape();
			addChild(_CCDdebug);
			_CCDrenderer = new IKSkeletonRenderer(_CCDskeleton, _CCDdebug.graphics, 0x006600);
		}

		private function generateSingleChain(bone:IKBone):void
		{
			bone = bone.createChild(GAP, 0.0);
			for (var i:int = 0; i < 100; i++)
			{
				bone = bone.createChild(GAP, 0.0);
			}
			bone.createChild(0.0, 0.0);
		}

		private function generateMultiChain():IKBone
		{
//			var rootJoint:IKJoint = new IKJoint(new Vector3D(CENTER.x, CENTER.y));
//			rootJoint.fixed = true;
//			var bone:IKBone = rootJoint.createBone(new Vector3D(CENTER.x, CENTER.y + GAP));
//			bone = bone.joint.createBone(new Vector3D(CENTER.x, bone.joint.position.y + GAP));
//
//			var bone2:IKBone = bone.joint.createBone(new Vector3D(CENTER.x - GAP, bone.joint.position.y + GAP));
//			bone2.joint.createBone(new Vector3D(CENTER.x - GAP, bone2.joint.position.y + GAP));
//
//			var bone3:IKBone = bone.joint.createBone(new Vector3D(CENTER.x + GAP, bone.joint.position.y + GAP));
//			bone3.joint.createBone(new Vector3D(CENTER.x + GAP, bone3.joint.position.y + GAP));
//			return rootJoint;
			return null;
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
//			_solver.target = new Vector3D(500, 2000);
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
//			_solver.target = new Vector3D(500, 2000);
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
