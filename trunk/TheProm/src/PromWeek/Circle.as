package PromWeek 
{
	import mx.core.UIComponent
	/**
	 * An MX coore component that's a circle. I can't believe it didn't already
	 * exist O_o. Add tihs to your Flex App by doing:
	 * <prom:Circle x="" y="" radius="" color="#1F497D" />
	 * (#1F497D is Prom Week Blue)
	 * @author Ryan
	 * with help from a dude on Stack Overflow
	 * http://stackoverflow.com/questions/1973409/how-to-draw-a-circle-in-flex-mxml-file
	 */
	public class Circle extends UIComponent
	{
		public var radius:Number
		public var color:uint
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void 
		{
			//this.setLayoutBoundsSize(radius*2,width*2)
			graphics.beginFill(color,alpha)
			graphics.drawCircle(0+radius, 0+radius, radius)
			graphics.endFill()
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		public function Circle() 
		{
			this.width = radius * 2
			this.height = radius * 2
			super()
		}
		
	}

}