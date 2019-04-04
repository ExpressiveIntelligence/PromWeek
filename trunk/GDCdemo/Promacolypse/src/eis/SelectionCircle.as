package eis 
{
	import mx.flash.UIMovieClip;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import spark.primitives.*;
	import spark.components.Group;

	
	/**
	 * Draws the selection circle for selected character representation to the user.
	 * 
	 */
	public class SelectionCircle extends Group
	{
		public var fillColor:SolidColor;
		public var strokeColor:SolidColorStroke;
		public var locX:Number;
		public var locY:Number;
		//private var depth:Number;
		
		
		public var circle:Ellipse;
		
		public function SelectionCircle() 
		{
			super();
			
			this.fillColor= new SolidColor(0xffff00, .9);
			this.strokeColor = new SolidColorStroke(0x000000, 1.0);
			this.strokeColor.weight = 5;
			this.circle = new Ellipse();
			this.addElement(this.circle);
			//default values
			this.circle.height = 50;
			this.circle.width = 150;
			//this.circle.depth = 2.0;
		}
		
		public function draw():void {
			//draw the circle
			//changing these causes big trouble! It adds the dimensions instead of setting it.
			//this.circle.height = this.height;
			//this.circle.width = this.width;
			this.circle.fill = this.fillColor;
			this.circle.stroke = this.strokeColor;
			this.circle.x = locX;
			this.circle.y = locY;
			//this.circle.depth = depth;
		}
		
		public function setLocation(x:Number, y:Number, depth:Number=1.0):void {
			this.locX = x;
			this.locY = y;
		}
	}

}