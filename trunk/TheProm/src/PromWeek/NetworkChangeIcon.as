package PromWeek 
{
	import flash.geom.Point;
	import mx.controls.Image;  import com.util.SmoothImage;
	import spark.components.Group;
	import spark.components.RichText;
	import PromWeek.GameEngine;
	import PromWeek.assets.ResourceLibrary;
	import com.util.SmoothImage;
	import CiF.Debug;
	
	import flash.text.engine.FontWeight;
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class NetworkChangeIcon extends Group
	{
		private var gameEngine:GameEngine;
		
		/**
		 * Name of the character who this social change is happening to
		 */
		public var toWho:String;
		public var fromWho:String;
		public var textColor:uint;
		public var fontSize:int = 34;
		
		public var networkChangeGroup:Group;
		public var textBox:RichText;
		public var toImage:SmoothImage;
		
		public var offsetX:Number = 50;
		public var offsetY:Number = -100;
		
		public var moveSpeed:int = -35;
		public var deltaY:Number = 0;
		
		public var alphaSpeed:Number = 0.3;
		public var deltaAlpha:Number = 0;
		
		public var timeLength:Number = 4000;
		
		private var startTime:Number;
		
		private var op:String;
		
		public var networkImage:SmoothImage;
		public var extraToKeepMultipleFromBeingOnTopOfEachother:Number;
		
		public function NetworkChangeIcon(fromWho1:String, toWho1:String, networkType:String, amount:Number, operator:String, subjectiveOpinionNoNumber:Boolean = false)
		{
			gameEngine = GameEngine.getInstance();
			
			fromWho = fromWho1.toLowerCase();
			toWho = toWho1.toLowerCase();
			
			var nowTime:Number = new Date().time;
			if (nowTime - gameEngine.worldGroup.avatars[fromWho].lastTimeOfNetworkChange < 500)
			{
				this.extraToKeepMultipleFromBeingOnTopOfEachother = 60;
			}
			else
			{
				this.extraToKeepMultipleFromBeingOnTopOfEachother = 0;
			}
			gameEngine.worldGroup.avatars[fromWho].lastTimeOfNetworkChange = nowTime;
			
			startTime = nowTime;
			
			deltaY = 0;
			
			var changeName:String;
			switch (networkType)
			{
				case "buddy":
					//textColor = GameEngine.BUDDY_COLOR;
					if (operator == "+")
					{
						changeName = "buddyUp"
					}
					else
					{
						changeName = "buddyDown"
					}
					break;
				case "romance":
					//textColor = GameEngine.ROMANCE_COLOR;
					if (operator == "+")
					{
						changeName = "romanceUp"
					}
					else
					{
						changeName = "romanceDown"
					}
					break;
				case "cool":
					//textColor = GameEngine.COOL_COLOR;
					if (operator == "+")
					{
						changeName = "coolUp"
					}
					else
					{
						changeName = "coolDown"
					}
					break;
			}
			
			if (operator == "-")
				op = "-";
			
			networkChangeGroup = new Group();
			
			/*
			textBox = new RichText();
			if (operator == "+")
			{
				textBox.text = "+";
			}
			else
			{
				textBox.text = "-";
			}
			
			if (!subjectiveOpinionNoNumber)
			{
				textBox.text += amount.toString();
			}
			else 
			{
				textBox.x += 35;
			}
			textBox.setStyle("color", textColor);
			textBox.setStyle("fontSize", fontSize);
			textBox.setStyle("fontWeight", FontWeight.BOLD);
			this.addElement(textBox);
			*/
			
			this.networkImage = new SmoothImage();
			this.networkImage.width = 25;
			this.networkImage.height = 60;
			this.networkImage.top = -15;
			this.networkImage.source = PromWeek.assets.ResourceLibrary.getInstance().networkArrowIcons[changeName];
			this.addElement(this.networkImage);
			
			this.toImage = new SmoothImage();
			this.toImage.width = 45;
			this.toImage.height = 45;
			this.toImage.left = 25;
			this.toImage.top = -15;
			this.toImage.source = PromWeek.assets.ResourceLibrary.getInstance().portraits[this.toWho.toLowerCase()];
			this.addElement(this.toImage);
			
			this.left = -10000;
			this.top = -10000;
		}

		public function update(elapsedTime:Number):void
		{	
			//if we should be over then go invisible
			if ((((new Date().time) - this.startTime) > timeLength) || gameEngine.worldGroup.avatars[fromWho] == null)
			{
				//remove this from the list of networkChangeIcons
				gameEngine.hudGroup.networkChangeIcons.splice(gameEngine.hudGroup.networkChangeIcons.indexOf(this),1);
				gameEngine.hudGroup.removeElement(this);
				
				return;
			}

			
			deltaAlpha += (elapsedTime / 1000.0) * alphaSpeed;
			this.alpha = 1 - deltaAlpha;
			
			
			var charX:Number = gameEngine.worldGroup.avatars[fromWho].locX + this.extraToKeepMultipleFromBeingOnTopOfEachother;
			var charY:Number = gameEngine.worldGroup.avatars[fromWho].locY;
			
			
			
			//Ben experimenting with making negative network things go down.
			if (op == "-")
				deltaY -= (elapsedTime / 1000.0) * this.moveSpeed;
			else
				deltaY += (elapsedTime / 1000.0) * this.moveSpeed;
				
			//var newLoc:Point = gameEngine.worldGroup.avatars[fromWho].localToGlobal(new Point(charX + offsetX, charY + offsetY + deltaY));
			var newLoc:Point = new Point(charX, charY);
			newLoc = Utility.translatePoint(newLoc, gameEngine.worldGroup, gameEngine.hudGroup);

			
			
			Debug.debug(this, "charX: " + charX + " charY: " + charY + " newLocX after translation: " + newLoc.x + " newLocY after translation: " + newLoc.y);
			
			this.top = newLoc.y + deltaY + offsetY;
			this.left = newLoc.x + offsetX;
		}
	}
		
}