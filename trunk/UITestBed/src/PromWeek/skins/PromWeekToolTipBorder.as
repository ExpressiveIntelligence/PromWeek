package PromWeek.skins 
{
	
	import flash.display.Graphics;
	import flash.filters.DropShadowFilter;
	import mx.core.EdgeMetrics;
	import mx.graphics.RectangularDropShadow;
	import mx.skins.RectangularBorder;
	//import PromWeek.GameEngine;

	/**
	 * ...
	 * @author 
	 */
	
	 
	public class PromWeekToolTipBorder extends RectangularBorder
	{
		
		public function PromWeekToolTipBorder() 
		{
			super();
		}


		/**
		 *  @private
		 */
		private var dropShadow:RectangularDropShadow;
		
		//--------------------------------------------------------------------------
		//
		//  Overridden properties
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  borderMetrics
		//----------------------------------

		/**
		 *  @private
		 *  Storage for the borderMetrics property.
		 */
		private var _borderMetrics:EdgeMetrics;

		/**
		 *  @private
		 */
		override public function get borderMetrics():EdgeMetrics
		{		
			if (_borderMetrics)
				return _borderMetrics;
				
			var borderStyle:String = getStyle("borderStyle");
			switch (borderStyle)
			{
				case "errorTipRight":
				{
					_borderMetrics = new EdgeMetrics(15, 1, 3, 3);
					break;
				}
				
				case "errorTipAbove":
				{
					_borderMetrics = new EdgeMetrics(3, 1, 3, 15);
					break;
				}
			
				case "errorTipBelow":
				{
					_borderMetrics = new EdgeMetrics(3, 13, 3, 3);
					break;
				}
				
				default: // "toolTip"
				{
					_borderMetrics = new EdgeMetrics(3, 1, 3, 3);
					break;
				}
			}
			
			return _borderMetrics;
		}

		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------

		/**
		 *  @private
		 *  If borderStyle may have changed, clear the cached border metrics.
		 */
		override public function styleChanged(styleProp:String):void
		{
			if (styleProp == "borderStyle" ||
				styleProp == "styleName" ||
				styleProp == null)
			{
				_borderMetrics = null;
			}
			
			invalidateDisplayList();
		}

		/**
		 * Sets the style according to what boolean is true in game engine. This is called in gameEngine with all other components that change
		 * their style at the same time.
		 */
		public function setStyleName():void {
			//this.styleName = GameEngine.getInstance().activeStyleName;
			this.invalidateProperties();
			//this.skin.invalidateProperties();
		}
		
		/**
		 *  @private
		 *  Draw the background and border.
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{	
			super.updateDisplayList(w, h);
			var borderStyle:String = getStyle("borderStyle");
			//var backgroundColor:uint = getStyle("backgroundColor");
			var backgroundColor:uint = 0xE0E0E0;
			var backgroundAlpha:Number= 1.0;
			var borderColor:uint = 0x222222;
			var cornerRadius:Number = 5;
			var shadowColor:uint = getStyle("shadowColor");
			var shadowAlpha:Number = 0.2;
			//trace(this.styleName);
			var g:Graphics = graphics;
			g.clear();
			
			filters = [];

			switch (borderStyle)
			{
				case "none":
				{
					// Don't draw anything
					break;
				}
				case "errorTipRight":
				{
					// border 
					drawRoundRect(
						11, 0, w - 11, h - 2, 3,
						borderColor, backgroundAlpha); 

					// left pointer 
					g.beginFill(borderColor, backgroundAlpha);
					g.moveTo(11, 7);
					g.lineTo(0, 13);
					g.lineTo(11, 19);
					g.moveTo(11, 7);
					g.endFill();
					
					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}
				
				case "errorTipAbove":
				{
					// border 
					drawRoundRect(
						0, 0, w, h - 13, 3,
						borderColor, backgroundAlpha); 

					// bottom pointer 
					g.beginFill(borderColor, backgroundAlpha);
					g.moveTo(9, h - 13);
					g.lineTo(15, h - 2);
					g.lineTo(21, h - 13);
					g.moveTo(9, h - 13);
					g.endFill();

					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}

				case "errorTipBelow":
				{
					// border 
					drawRoundRect(
						0, 11, w, h - 13, 3,
						borderColor, backgroundAlpha); 

					// top pointer 
					g.beginFill(borderColor, backgroundAlpha);
					g.moveTo(9, 11);
					g.lineTo(15, 0);
					g.lineTo(21, 11);
					g.moveTo(10, 11);
					g.endFill();
					
					filters = [ new DropShadowFilter(2, 90, 0, 0.4) ];
					break;
				}

				default: //Tooltip
				{
					// face
					drawRoundRect(
						3, 1, w - 6, h - 4, cornerRadius,
						backgroundColor, backgroundAlpha) 
					
					if (!dropShadow)
						dropShadow = new RectangularDropShadow();

					dropShadow.distance = 3;
					dropShadow.angle = 90;
					dropShadow.color = 0;
					dropShadow.alpha = 0.4;

					dropShadow.tlRadius = cornerRadius + 2;
					dropShadow.trRadius = cornerRadius + 2;
					dropShadow.blRadius = cornerRadius + 2;
					dropShadow.brRadius = cornerRadius + 2;

					dropShadow.drawShadow(graphics, 3, 0, w - 6, h - 4);

					break;
				}
			}
		}
	}
}
