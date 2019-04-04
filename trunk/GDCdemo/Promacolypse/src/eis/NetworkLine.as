package eis 
{
	import flash.display.LineScaleMode;
	import mx.flash.UIMovieClip;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import spark.primitives.*;
	import spark.components.Group;
	import mx.controls.Image;  import com.util.SmoothImage;

	
	/**
	 * Draws the selection circle for selected character representation to the user.
	 * 
	 */
	public class NetworkLine extends Group
	{
		public var fillColor:SolidColor;
		public var strokeColor:SolidColorStroke;

		public var fromChar:String;
		public var toChar:String;
		
		public var network:String;
		
		public var networkLine:Rect;
		
		public var weightHeightMax:Number;
		
		public var dir1a:Line;
		public var dir1b:Line;
		public var dir2a:Line;
		public var dir2b:Line;
		public var dirSlope:Number;

		[Embed(source="../../assets/friendship_icon.png")] 
		[Bindable] 
		public var friendshipIconCls:Class;
		
		[Embed(source="../../assets/dating_icon.png")] 
		[Bindable] 
		public var datingIconCls:Class;
		
		[Embed(source="../../assets/friendship_icon_upsidedown.png")] 
		[Bindable] 
		public var friendshipIconUpsidedownCls:Class;
		
		[Embed(source="../../assets/dating_icon_upsidedown.png")] 
		[Bindable] 
		public var datingIconUpsidedownCls:Class;
		
		public var datingIcon:SmoothImage;
		public var friendshipIcon:SmoothImage;
		
		public var alphaForHeight:Number;
		
		public function NetworkLine(fromC:String,toC:String) 
		{
			super();
			
			weightHeightMax = 60;
			alphaForHeight = 1.0;
			this.fromChar = fromC;
			this.toChar = toC;
			
			this.fillColor = new SolidColor(0xffff00, .9);
			this.strokeColor = new SolidColorStroke(0x000000, 1.0);
			this.strokeColor.weight = 4;
			this.networkLine = new Rect();
			this.networkLine.fill = this.fillColor;
			this.networkLine.stroke = this.strokeColor;
			this.addElement(this.networkLine);
			
			this.dir1a = new Line();
			this.dir1a.stroke = this.strokeColor;
			this.addElement(this.dir1a);
			this.dir1b = new Line();
			this.dir1b.stroke = this.strokeColor;
			this.addElement(this.dir1b);

			this.dir2a = new Line();
			this.dir2a.stroke = this.strokeColor;
			this.addElement(this.dir2a);
			this.dir2b = new Line();
			this.dir2b.stroke = this.strokeColor;
			this.addElement(this.dir2b);
			
			this.dirSlope = 20;

			this.friendshipIcon = new SmoothImage();
			this.friendshipIcon.toolTip = fromChar+" and "+toChar+" are FRIENDS!";
			this.friendshipIcon.source = friendshipIconCls;
			this.friendshipIcon.visible = false;
			this.addElement(friendshipIcon);
			
			this.datingIcon = new SmoothImage();
			this.datingIcon.toolTip = fromChar+" and "+toChar+" are DATING!";
			this.datingIcon.source = datingIconCls;
			this.datingIcon.visible = false;
			this.addElement(datingIcon);
			
		}
	}

}