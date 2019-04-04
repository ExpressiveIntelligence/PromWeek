package eis 
{
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import mx.controls.Button;
	import spark.components.Group;
	import spark.components.Button;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import spark.primitives.*;
	import flash.text.TextField;
	import spark.components.Label;
	import mx.controls.Image;  import com.util.SmoothImage;
	import flash.events.*;
	import spark.filters.*;
	
	public class MainUI extends Group
	{		
		public var mainBodyFill:SolidColor;
		public var mainBodyStroke:SolidColorStroke;
		private var mainBody:Rect;
		
		public var innerBodyStroke:SolidColorStroke;
		
		//get all of the porttraits
		private var portraitGroup:Group;
		[Embed(source="../../assets/portraits/edward_portrait.png")] 
		[Bindable] 
		private var edwardPortraitCls:Class;
		[Embed(source="../../assets/portraits/robert_portrait.png")] 
		[Bindable] 
		private var robertPortraitCls:Class;
		[Embed(source="../../assets/portraits/karen_portrait.png")] 
		[Bindable] 
		private var karenPortraitCls:Class;		
		private var portraitRect:Rect;
		private var portraitImg:SmoothImage;
		
		private var isConsideringGroup:Group;
		
		private var socialGameButtonHandle:Function;
		
		public var currentNetwork:String;
		private var socialNetworksGroup:Group;
		
		private var characterName:String;
		private var isConsidering_text:Label;
		private var goal_text:Label;
		
		private var intent:Intent;
		
		public function MainUI(locX:int,locY:int,charName:String, intentForChar:Intent, handle:Function)
		{
			super();
			
			socialGameButtonHandle = handle;
			
			currentNetwork = null;
			characterName = charName;
		
			intent = intentForChar;
			
			this.x = locX;
			this.y = locY;
			
			this.mainBody = new Rect();
			
			//default values
			mainBodyFill= new SolidColor(0x1F497D, 0.7);
			mainBodyStroke = new SolidColorStroke(0x000033, 1.0);
			mainBodyStroke.weight = 10;
			this.mainBody.x = 0;
			this.mainBody.y = 0;
			this.mainBody.height = 150;
			this.mainBody.width = 900;//1080;
			this.mainBody.stroke = mainBodyStroke;
			this.mainBody.fill = mainBodyFill;
			this.addElement(mainBody);
			
			this.innerBodyStroke = new SolidColorStroke(0x000033, 1.0);
			this.innerBodyStroke.weight = 3;
			
			//draw the goal label
			goal_text = new Label();
			goal_text.x = 17;
			goal_text.y = 12;
			goal_text.text = "Level Objective:\nGet Edward and\nKaren to date";
			goal_text.styleName = "GoalLabel";
			this.addElement(goal_text);
			
			//draw the portrait and border
			portraitGroup = new Group();
			this.portraitImg = new SmoothImage();
			switch (charName) {
				case ("Edward"):
					this.portraitImg.source = this.edwardPortraitCls;
					break;
				case ("Robert"):
					this.portraitImg.source = this.robertPortraitCls;
					break;
				case ("Karen"):
					this.portraitImg.source = this.karenPortraitCls;
					break;
			}
			//this.portraitImg.x = 200;
			//this.portraitImg.y = 10;
			portraitGroup.addElement(this.portraitImg);
			
			this.portraitRect = new Rect();
			//this.portraitRect.x = 200;
			//this.portraitRect.y = 10;
			this.portraitRect.width = 135;
			this.portraitRect.height = 130;
			this.portraitRect.stroke = this.innerBodyStroke;
			portraitGroup.addElement(this.portraitRect);
			
			this.portraitGroup.x = 200;
			this.portraitGroup.y = 10;
			this.addElement(portraitGroup);			

			//draw the in considering buttons and such
			this.isConsideringGroup = new Group();
			//draw isConsideringText
			this.isConsidering_text = new Label();
			this.isConsidering_text.x = 0;
			this.isConsidering_text.y = 0;
			this.isConsidering_text.text = this.characterName + " is considering...";
			this.isConsidering_text.styleName = "MainUI";
			
			//create the buttons and position them
			for (var i:int = 0; (i < intent.sortedGames.length && i < 4); i++)
			{	
				var button:SocialGameButton = new SocialGameButton(intent.sortedGames[i]);
				
				button.addEventListener(MouseEvent.CLICK,socialGameButtonHandler);
				
				button.x = 40;
				button.y = 25 + i * 25;
				button.label = intent.sortedGames[i].game.specificTypeOfGame + " with " + intent.sortedGames[i].target;
				isConsideringGroup.addElement(button);
			}
			
			
			//this.isConsidering_text.regenerateStyleCache(true);
			//GlowFilter(color:uint = 0xFF0000, alpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1, quality:int = 1, inner:Boolean = false, knockout:Boolean = false)
			//this.isConsidering_text.filters = [new DropShadowFilter(0x000000, 0.8,5,5,100,1,0,0)];
			isConsideringGroup.x = 342;
			isConsideringGroup.y = 15;
			isConsideringGroup.addElement(this.isConsidering_text);
			this.addElement(this.isConsideringGroup);
			
			socialNetworksGroup = new Group();
			socialNetworksGroup.x = 680;
			socialNetworksGroup.y = 15;
			var socialNetworks_text:Label = new Label();
			socialNetworks_text.text = characterName + "'s Social World";
			socialNetworks_text.styleName = "MainUI";
			socialNetworksGroup.addElement(socialNetworks_text);
			var relNet:SocialNetworkButton = new SocialNetworkButton("F");
			relNet.styleName = "SocialNetworkButton";
			relNet.toolTip = "Friend network";
			relNet.x = 0;
			relNet.y = 27;
			relNet.addEventListener(MouseEvent.CLICK, networkButtonHandler);
			socialNetworksGroup.addElement(relNet);
			var romNet:SocialNetworkButton = new SocialNetworkButton("R");
			romNet.styleName = "SocialNetworkButton";
			romNet.toolTip = "Romance network";
			romNet.x = 65;
			romNet.y = 27;
			romNet.addEventListener(MouseEvent.CLICK, networkButtonHandler);
			socialNetworksGroup.addElement(romNet);
			var coolNet:SocialNetworkButton = new SocialNetworkButton("C");
			coolNet.styleName = "SocialNetworkButton";
			coolNet.toolTip = "Cool network";
			coolNet.x = 130;
			coolNet.y = 27;
			coolNet.addEventListener(MouseEvent.CLICK, networkButtonHandler);
			socialNetworksGroup.addElement(coolNet);
			
			//var statusButton:SocialGameButton = on("Social Status");
			var statusButton:SocialNetworkButton = new SocialNetworkButton("Social Status");
			statusButton.styleName = "SocialNetworkButton";
			statusButton.label = "Social Status";
			//statusButton.toolTip = "Social Status";
			statusButton.x = 0;
			statusButton.y = 72;
			statusButton.width = 170;
			statusButton.height = 25;
			statusButton.addEventListener(MouseEvent.CLICK, networkButtonHandler);
			socialNetworksGroup.addElement(statusButton);
			
			var personalityButton:SocialNetworkButton = new SocialNetworkButton("Personality");
			personalityButton.styleName = "SocialNetworkButton";
			personalityButton.label = "Personality";
			//personalityButton.toolTip = "Personality";
			personalityButton.x = 0;
			personalityButton.y = 102;
			personalityButton.width = 170;
			personalityButton.height = 25;
			socialNetworksGroup.addElement(personalityButton);
			
			this.addElement(socialNetworksGroup);
		}
		public function removeIsConsidering():void {
			this.removeElement(this.isConsideringGroup);
		}
		
		private function socialGameButtonHandler(e:MouseEvent):void {
			this.socialGameButtonHandle(e);
		}
		
		private function networkButtonHandler(e:MouseEvent):void {
			
			var button:SocialNetworkButton = e.target as SocialNetworkButton;
			
			switch (button.label) {
				case "F":
					if (button.toggleStatus == false)
					{
						button.toggleStatus = true
						currentNetwork = "F";
					}
					else
					{
						button.toggleStatus = false;
						currentNetwork = "clear";
					}
					break;
				case "R":
					if (button.toggleStatus == false)
					{
						button.toggleStatus = true
						currentNetwork = "R";
					}
					else
					{
						button.toggleStatus = false;
						currentNetwork = "clear";
					}
					break;
				case "C":
					if (button.toggleStatus == false)
					{
						button.toggleStatus = true
						currentNetwork = "C";
					}
					else
					{
						button.toggleStatus = false;
						currentNetwork = "clear";
					}
					break;
					
				case "Social Status":
					if (button.toggleStatus == false)
					{
						button.toggleStatus = true
						currentNetwork = "status";
					}
					else
					{
						button.toggleStatus = false;
						currentNetwork = "clear";
					}
					break;
				default:
					currentNetwork = "null";
			}
		}
	}	
}
