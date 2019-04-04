package PromWeek 
{
	import com.greensock.motionPaths.RectanglePath2D;
	import flash.events.Event;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.preloaders.SparkDownloadProgressBar;
	import spark.components.Group;
	import spark.primitives.Rect;
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class DebugGroup extends Group
	{
		private var gameEngine:GameEngine;
		
		public var collisionGridSquares:Array;
		
		public var vacantFillColor:SolidColor;
		public var fullFillColor:SolidColor;
		public var staticObjectFillColor:SolidColor;
		public var strokeColor:SolidColorStroke;
		
		public var isCollisionGridEnabled:Boolean = false;
		public var isCameraVisualizationEnabled:Boolean = false;
		
		public var cameraVisScale:Number = .1;
		public var bg:Rect = new Rect();
		public var viewableBG:Rect = new Rect();
		public var viewport:Rect = new Rect();

		public var cameraVisGroup:Group;

		
		public function DebugGroup() 
		{
			vacantFillColor = new SolidColor(0x00FF00, 0.5);
			fullFillColor = new SolidColor(0x0000FF, 0.5);
			staticObjectFillColor = new SolidColor(0xFF0000, 0.5);
			strokeColor = new SolidColorStroke(0x000000, 5, 0.5);
			
			//if (isCollisionGridEnabled) createCollisionGrid(this.gameEngine.worldGroup.currentSetting);
			//if (isCameraVisualizationEnabled) createCameraVisualization();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function onEnterFrame(e:Event):void {
			update();
		}
		
		public function update():void
		{
			if (gameEngine == null)
			{
				gameEngine = GameEngine.getInstance();		
			}
			
			if (isCollisionGridEnabled) updateCollisionSquareGrid();
			if (isCameraVisualizationEnabled) updateCameraVisualization();
		}
		
		public function createCollisionGrid(setting:Setting):void
		{
			this.isCollisionGridEnabled = true;
			this.gameEngine = GameEngine.getInstance();
			//add a crap ton of squares
			var square:Rect;
			collisionGridSquares = new Array(setting.collisionGrid.length);
			for (var i:int = 0; i < setting.collisionGrid.length ; i++ )
			{
				collisionGridSquares[i] = new Array(setting.collisionGrid[i].length);
				for (var j:int = 0; j < setting.collisionGrid[i].length; j++) 
				{
					//create a rect there
					square = new Rect();
					square.width = setting.cellWidth;
					square.height = setting.cellHeight;
					square.x = i * setting.cellWidth;
					square.y = setting.horizonHeight + j * setting.cellHeight;
					square.stroke = strokeColor;
					square.fill = vacantFillColor;
					collisionGridSquares[i][j] = square;
					addElement(square);
				}
			}
		}
		
		
		
		public function updateCollisionSquareGrid():void
		{
			for (var i:int = 0; i < collisionGridSquares.length ; i++ )
			{
				for (var j:int = 0; j < collisionGridSquares[i].length; j++) 
				{
					if (gameEngine.worldGroup.currentSetting.collisionGrid[i][j] == 1)
					{
						collisionGridSquares[i][j].fill = fullFillColor;
					}
					else if (gameEngine.worldGroup.currentSetting.collisionGrid[i][j] == 2)
					{
						collisionGridSquares[i][j].fill = staticObjectFillColor;
					}
					else
					{
						collisionGridSquares[i][j].fill = vacantFillColor;
					}
				}
			}
/*			
			var avatar:Avatar;
			for (var i:int = 0; i < collisionGridSquares.length ; i++ )
			{
				for (var j:int = 0; j < collisionGridSquares[i].length; j++) 
				{
					var hasBeenSet:Boolean = false;
					//if (gameEngine.worldGroup.currentSetting.collisionGrid[i][j] == 1)
					//{
						//hasBeenSet = true;
						//collisionGridSquares[i][j].fill = fullFillColor;
					//}
					
					
					for each (avatar in gameEngine.worldGroup.avatars)
					{
						if ((Math.floor(avatar.locX / gameEngine.worldGroup.currentSetting.cellWidth) == i) && (Math.floor((avatar.locY - gameEngine.worldGroup.currentSetting.horizonHeight + avatar.clip.height/2) / gameEngine.worldGroup.currentSetting.cellHeight) == j))
						{
							hasBeenSet = true;
							collisionGridSquares[i][j].fill = fullFillColor;
						}
					}
					if (!hasBeenSet)
					{
						collisionGridSquares[i][j].fill = vacantFillColor;
					}
				}					
			}			
*/
		}
		
		public function updateCameraVisualization():void {
			if(this.gameEngine) {
				viewport.height = this.gameEngine.camera.getHeightOfViewableWorld();
				viewport.width = this.gameEngine.camera.getWidthOfViewableWorld();
				viewport.top = viewableBG.top + this.gameEngine.camera.destinationInWorldCoordinates.y;
				viewport.left = viewableBG.left + this.gameEngine.camera.destinationInWorldCoordinates.x;
			}
		}
		
		public function createCameraVisualization():void {
			//square.width = setting.cellWidth;
			//square.height = setting.cellHeight;
			//square.x = i * setting.cellWidth;
			//square.y = setting.horizonHeight + j * setting.cellHeight;
			//square.stroke = strokeColor;
			//square.fill = vacantFillColor;
			//collisionGridSquares[i][j] = square;
			//addElement(square);
			this.gameEngine = GameEngine.getInstance();
			
			this.isCameraVisualizationEnabled = true;
			
			//create the group
			this.cameraVisGroup = new Group();
			this.cameraVisGroup.height = this.gameEngine.worldGroup.currentSetting.imgHeight;
			this.cameraVisGroup.width = this.gameEngine.worldGroup.currentSetting.imgWidth;
			
			//create the full background image
			
			bg.width = this.gameEngine.worldGroup.currentSetting.imgWidth;
			bg.height = this.gameEngine.worldGroup.currentSetting.imgHeight;
			bg.top = 0.0;
			bg.left = 0.0;
			bg.stroke = new SolidColorStroke(0x444444, 2, .2);
			bg.fill = new SolidColor(0xaaaaaa, .2);
			
			
			//create the viewable background area
			viewableBG.height = this.gameEngine.worldGroup.currentSetting.viewableHeight;
			viewableBG.width = this.gameEngine.worldGroup.currentSetting.viewableWidth;
			viewableBG.top = - this.gameEngine.worldGroup.currentSetting.offsetY;
			viewableBG.left = - this.gameEngine.worldGroup.currentSetting.offsetX;
			viewableBG.stroke = new SolidColorStroke(0x117722, 2, .2);
			viewableBG.fill = new SolidColor(0x22ee44, .2);
			
			//create the camera area
			viewport.height = this.gameEngine.camera.getHeightOfViewableWorld();
			viewport.width = this.gameEngine.camera.getWidthOfViewableWorld();
			viewport.top = viewableBG.top + this.gameEngine.camera.destinationInWorldCoordinates.y;
			viewport.left = viewableBG.left + this.gameEngine.camera.destinationInWorldCoordinates.x;
			viewport.stroke = new SolidColorStroke(0x772211, 2, .2);
			viewport.fill = new SolidColor(0xee4422, .2);
			
			//bg.scaleX = this.cameraVisScale;
			//bg.scaleY = this.cameraVisScale;
			//viewableBG.scaleX = this.cameraVisScale;
			//viewableBG.scaleY = this.cameraVisScale;
			//viewport.scaleX = this.cameraVisScale;
			//viewport.scaleY = this.cameraVisScale;

			
			cameraVisGroup.scaleX = this.cameraVisScale;
			cameraVisGroup.scaleY = this.cameraVisScale;
			
			cameraVisGroup.addElement(bg);
			cameraVisGroup.addElement(viewableBG);
			cameraVisGroup.addElement(viewport);
			
			addElement(cameraVisGroup);
			cameraVisGroup.top = 0.0;
			cameraVisGroup.left = 0.0;
			//display zoom
			//display current and destination world coordinates
		}
		
		
	}

}