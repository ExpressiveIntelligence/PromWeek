package eis 
{
	import 	spark.components.Label;
	import spark.components.Group;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import spark.primitives.*;
	import mx.controls.Image;  import com.util.SmoothImage;
	import com.util.SmoothImage;

	/**
	 * @author Mike Treanor
	 */
	public class DialogBox extends Group
	{
		public const FRONT:int = 0;
		public const LEFT:int = 1;
		public const RIGHT:int = 2;
		
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
		
		
		public var fillColor:SolidColor;
		public var strokeColor:SolidColorStroke;
		public var boxGraphic:Rect;
		
		public var charName_text:Label;
		public var dialog_text:Label;
		
		public function DialogBox(role:String,facing:int,charName:String)
		{
			fillColor = new SolidColor(0x1F497D, 0.8);
			if (role == "primary")
			{
				strokeColor = new SolidColorStroke(0xFFCC00);
			}
			else if (role == "secondary")
			{
				strokeColor = new SolidColorStroke(0x02E302);
			}
			strokeColor.weight = 8.0;
			boxGraphic = new Rect();

			boxGraphic.stroke = strokeColor;
			boxGraphic.fill = fillColor;
			
			this.boxGraphic.width = 450;
			this.boxGraphic.height = 160;
			if (facing == RIGHT || FRONT)
			{
				this.x = 50;
				this.y = 20;
			}
			else if (facing == LEFT)
			{
				this.x = 1285 - 50 - this.boxGraphic.width;
				this.y = 20;
			}
			this.addElement(this.boxGraphic);
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
			this.portraitRect.stroke = this.strokeColor;
			portraitGroup.addElement(this.portraitRect);
			this.portraitGroup.x = 15;
			this.portraitGroup.y = 15;
			this.addElement(portraitGroup);
			
			charName_text = new Label();
			charName_text.x = 160;
			charName_text.y = 15;
			charName_text.text = charName+":";
			charName_text.styleName = "GoalLabel";
			this.addElement(charName_text);
			
			dialog_text = new Label();
			dialog_text.x = 160;
			dialog_text.y = 45;
			dialog_text.width = this.boxGraphic.width - dialog_text.x - 15;
			//dialog_text.lineBreak = true;
			dialog_text.text = "";
			dialog_text.styleName = "GoalLabel";
			this.addElement(dialog_text);
		}
	}
}