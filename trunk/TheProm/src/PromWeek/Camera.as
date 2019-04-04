package PromWeek {
	import CiF.Debug;
	import flash.events.Event;
	import flash.geom.Point;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import flash.utils.Dictionary;
	import mx.collections.ArrayCollection;
	
	/**
	 * The camera class. Takes care of camera translation, world 
	 * coordinate/viewport coordinate translation, zooming, and background
	 * boundary detection.
	 * 
	 * Uses greensock for tweening between camera parameters.
	 * 
	 */
	public class Camera {
		
		public var gameEngine:GameEngine;
		
		//camera states
		public static const VIEW_SCENE:int = 0;
		public static const FRAME_MULTIPLE:int = 1;
		public static const FREE_LOOK:int = 2;
		public static const MANUAL_MODE:int = 3;
		
		
		public static const DEFAULT_VIEWPORT_WIDTH:Number = 760;
		public static const DEFAULT_VIEWPORT_HEIGHT:Number = 600;
		public static const DEFAULT_VIEWPORT_ASPECT_RATIO:Number = DEFAULT_VIEWPORT_WIDTH / DEFAULT_VIEWPORT_HEIGHT;
		
		public static const DEFAULT_ZOOM:Number = 1.0;
		public var previousZoom:Number = 1.0; // So we revert back to what the zoom was after a performance.
		
		//world coordinates per second.
		public static const DEFAULT_TWEEN_SPEED:Number = 300//100.0;
		
		/**
		 * The speed of tweening the camera viewport to its destination in 
		 * world coordinates per second.
		 */
		private var tweenSpeed:Number;
		
		/**
		 * Use this to turn on and off tweening in camera.update
		 */
		public var shouldTween:Boolean = true;
		
		/**
		 * The mode the camera is in:
		 * FRAME_MULTIPLE: looks at this.framedCharacters and attempts to keep the viewport
		 * aroudn those characters.
		 * VIEW_SCENE: gets as much of the viewable world in the veiwport as possible
		 * FREE_LOOK: allows the player to scroll through the scene
		 */
		public var mode:int;
		/**
		 * The current coordinates in the world group of the top left of the camera's
		 * view port.
		 */
		public var topLeftInWorldCoordinates:Point;
		[Bindable]
		public var leftInWorldCoordinates:Number;
		[Bindable]
		public var topInWorldCoordinates:Number;
		[Bindable]
		public var worldScale:Number;
		//public var worldScale:Point;
		/**
		 * The destination of the top left of the viewport in world coordinates.
		 */
		[Bindable]
		public var destinationInWorldCoordinates:Point;
		/**
		 * The zoom level of the background in the viewport.
		 */
		[Bindable]
		public var currentZoom:Number;
		private var destinationZoom:Number;
		/**
		 * The aspect ratio of the viewport.
		 */
		private var aspectRatio:Number;
		/**
		 * The dimensions of the viewport in application coordinates.
		 */
		public var windowWidth:Number;
		/**
		 * The dimensions of the viewport in application coordinates.
		 */
		public var windowHeight:Number;
		/**
		 * The dimensions of the area of the world group visible in the viewport.
		 */
		public var worldWidth:Number;
		public var worldHeight:Number;
		
		private var framedAvatars:ArrayCollection;
		
		//private var gameEngine:GameEngine;
		
		public function Camera() {
			this.tweenSpeed = DEFAULT_TWEEN_SPEED;
			this.mode = MANUAL_MODE;
			this.topLeftInWorldCoordinates = new Point(0, 0);
			this.leftInWorldCoordinates = 0.0;;
			this.topInWorldCoordinates=0.0;
			this.destinationInWorldCoordinates = new Point(0,0);
			this.currentZoom = DEFAULT_ZOOM;
			this.destinationZoom = DEFAULT_ZOOM;
			this.aspectRatio = DEFAULT_VIEWPORT_ASPECT_RATIO
			this.windowHeight = DEFAULT_VIEWPORT_HEIGHT;
			this.windowWidth = DEFAULT_VIEWPORT_WIDTH;
			this.worldHeight = DEFAULT_VIEWPORT_HEIGHT;
			this.worldWidth = DEFAULT_VIEWPORT_WIDTH;
			this.framedAvatars= new ArrayCollection;
			this.gameEngine = GameEngine.getInstance();
			
			
		}
		
		public function framingAvatarsUpdate():void {
			if (FRAME_MULTIPLE == this.mode) {
				this.update();
			}
		}
		
		/**
		 * Here we adjust the destination x and y coordinates of the viewport in world coordinates
		 * to make zoom appear to be from the middle of the viewport.
		 */
		public function set zoom(z:Number):void {
			
			
			//check for boundary violation here
			//adjustForViewableSettingBoundary();
			
			//var adjX:Number = ((this.worldWidth * this.destinationZoom) - (this.worldWidth * this.currentZoom)) / 2.0;
			//var adjY:Number = ((this.worldHeight * this.destinationZoom) - (this.worldHeight * this.currentZoom)) / 2.0;
			
			//var adjX:Number = ((this.getWidthOfViewableWorld() / this.destinationZoom) - (this.getWidthOfViewableWorld() / z)) / 2.0;
			//var adjY:Number = ((this.getHeightOfViewableWorld() / this.destinationZoom) - (this.getHeightOfViewableWorld() / z)) / 2.0;

			//get the middle of the previous camera settings
			//var middle:Point = new Point();
			//middle.x = this.destinationInWorldCoordinates.x + getWidthOfViewableWorld() / 2.0;
			//middle.y = this.destinationInWorldCoordinates.y + getHeightOfViewableWorld() / 2.0;

			//var adjX:Number = 0;
			//var adjY:Number = 0;

			//this.destinationZoom = z;
			
			var oldDimensions:Point = new Point(getWidthOfViewableWorld(), getHeightOfViewableWorld());

			// Pn = (Po*Zo)/Zd
			//this.destinationInWorldCoordinates.x +=  this.windowWidth *   (z-this.destinationZoom)
			//this.destinationInWorldCoordinates.y +=  this.windowHeight *  (z-this.destinationZoom)
			//this.destinationInWorldCoordinates.x +=  this.worldWidth*    (z-this.destinationZoom)/2
			//this.destinationInWorldCoordinates.y +=  this.worldHeight *  (z - this.destinationZoom) / 2
			//this.destinationInWorldCoordinates.x *=  1.0+(z-this.destinationZoom)
			//this.destinationInWorldCoordinates.y *=  1.0+(z-this.destinationZoom)
			
			//only adjust if we are not at a maximum zoom state
			if(this.windowHeight <= this.worldHeight*z && this.windowWidth <= this.worldWidth*z) {
				this.destinationInWorldCoordinates.x = (z * (this.destinationInWorldCoordinates.x + this.windowWidth/2.0)) / this.destinationZoom - this.windowWidth/2.0
				this.destinationInWorldCoordinates.y = (z * (this.destinationInWorldCoordinates.y + this.windowHeight / 2.0)) / this.destinationZoom - this.windowHeight / 2.0
				this.destinationZoom = z;
			}
			else
			{
				var newZoom:Number = this.windowHeight / this.worldHeight;
				this.destinationInWorldCoordinates.x = (newZoom * (this.destinationInWorldCoordinates.x + this.windowWidth/2.0)) / this.destinationZoom - this.windowWidth/2.0
				this.destinationInWorldCoordinates.y = (newZoom * (this.destinationInWorldCoordinates.y + this.windowHeight / 2.0)) / this.destinationZoom - this.windowHeight / 2.0
				//set the zoom to the max if we were asked to zoom too far out
				this.destinationZoom = newZoom;
			}

			
			
			//var ax:Number = (getWidthOfViewableWorld() - oldDimensions.x)// / 2.0 
			//var ay:Number = (getHeightOfViewableWorld() - oldDimensions.y)// / 2.0 
			
			//this.destinationInWorldCoordinates.x +=  ax
			//this.destinationInWorldCoordinates.y +=  ay
			//this.destinationInWorldCoordinates.x += ax;
			//this.destinationInWorldCoordinates.y += ay;
			//this.destinationInWorldCoordinates.x += adjX;
			//this.destinationInWorldCoordinates.y += adjY;
			//shouldTween = false;
			this.update();
			//shouldTween = true;
		}
		
		public function get zoom():Number {
			return this.destinationZoom;
		}
		
		public function getWidthOfViewableWorld():Number {
			return this.windowWidth / this.destinationZoom;
		}
		
		public function getHeightOfViewableWorld():Number {
			return this.windowHeight / this.destinationZoom;
		}
		
		public function setWindowDimensions(height:Number, width:Number):void {
			this.windowHeight = height;
			this.windowWidth = width;
			this.update();
		}
		
		public function setWorldDimensions(height:Number, width:Number):void {
			this.worldHeight = height;
			this.worldWidth = width;
			this.update();
		}
		
		public function setMode(m:int):void {
			this.mode = m;
			this.update();
		}
		
		public function showWholeScene():void {
			this.mode = VIEW_SCENE;
			this.update();
		}
		
		public function freeLook():void {
			this.mode = FREE_LOOK;
			this.update();
		}
		
		public function manualMode():void {
			this.mode = MANUAL_MODE;
			this.update();
		}
		
		public function frameAvatars(avatars:ArrayCollection):void {
			this.framedAvatars = new ArrayCollection;
			this.framedAvatars = avatars;
			this.mode = FRAME_MULTIPLE;
			this.update();
		}
		
		/**
		 * Moves the camera relative to it's position.
		 * @param	deltaX	The translation alone the x axis.
		 * @param	deltaY	The translation alone the y axis.
		 */
		public function translate(deltaX:Number, deltaY:Number = 0.0):void {
			this.destinationInWorldCoordinates.x += deltaX;
			this.destinationInWorldCoordinates.y += deltaY;
			this.update();
			//adjustForViewableSettingBoundary();
		}
		
		public function absolutePosition(x:Number, y:Number, zoom:Number = 1):void {
			//shouldTween = false;
			this.zoom = 1;
			
			this.destinationInWorldCoordinates.x = x;
			this.destinationInWorldCoordinates.y = y;
			
			this.zoom = zoom;
			
			//this.topLeftInWorldCoordinates.x = x;
			//this.topLeftInWorldCoordinates.y = y;
			
			manualMode();
			//this.update();
			//adjustForViewableSettingBoundary();
			//shouldTween = true;
		}
		
		//Centers the camera on the dead center of the level.
		public function centerTheCamera(zoom:Number = -1):void {
			
			this.zoom = zoom;
			
			this.destinationInWorldCoordinates.x = worldWidth / 2;
			this.destinationInWorldCoordinates.y = worldHeight / 2;
			
			//OK, so now the upper left of the window is looking at the center.
			//So, we need to adjust!  Move the camera left by half the width of the viewport, and up by half it's height.
			
			this.destinationInWorldCoordinates.x -= this.windowWidth / 2; 
			this.destinationInWorldCoordinates.y -= this.windowHeight / 2;
			
			
			
			//this.update();
			manualMode();
		}
		
		//I'm not sure, but just by analyzing this function, I believe its goal is:
		//Given an x and y location, offset this by half the width and height of the world.
		//This gets used for when social games get performed.
		public function absolutePositionCenter(x:Number, y:Number, zoom1:Number = -1):void {
			
			this.zoom = 1;
			
			this.destinationInWorldCoordinates.x = x - this.windowWidth / 2;
			this.destinationInWorldCoordinates.y = y - this.windowHeight / 2;
			
			if(zoom1 != -1)
				this.zoom = zoom1;
			
			this.update();
			//adjustForViewableSettingBoundary();
		}
		
		/**
		 * Centers the camera view at x,y.
		 * @param	x
		 * @param	y
		 */
		public function centerToPoint(x:Number, y:Number, customZoom:Number = 1.0):void 
		{
			
			absolutePositionCenter(x, y, customZoom);
			
			/*
			this.destinationInWorldCoordinates.x = x - this.windowWidth / customZoom / 2.0
			//this.destinationInWorldCoordinates.x = x - this.windowWidth / 2.0
			this.destinationInWorldCoordinates.y = y - this.windowHeight / customZoom / 2.0
			//this.destinationInWorldCoordinates.y = y - this.windowHeight / 2.0
		
			this.zoom = customZoom;
			
			this.update()
			*/
		}
		
		/**
		 * Called when the camera parameters change.
		 * 
		 * Updates the viewport's properties and sets tweening based
		 * on the mode the camera is in.
		 */
		public function update():void {
			var translatedCoordinates:Point;
			
			//update current camera coordinates form world group translation.
			//this.topLeftInWorldCoordinates.x = this.gameEngine.worldGroup.x;// + this.gameEngine.worldGroup.currentSetting.offsetX;
			//this.topLeftInWorldCoordinates.y = this.gameEngine.worldGroup.y;// + this.gameEngine.worldGroup.currentSetting.offsetY;
			
			//var tweenTime:Number = ()/(this.tweenSpeed)
			
			if (FRAME_MULTIPLE == this.mode) {
				//parameterizeOnAvatars();
			}
			if (VIEW_SCENE == this.mode) {
				this.destinationZoom = .001;
				adjustForViewableSettingBoundary();
			}
			if (FREE_LOOK == this.mode) {
				//x axis values are set externally
				//y axis value should be the middle of the viewing area
				//this.destinationInWorldCoordinates.y = this.gameEngine.worldGroup.currentSetting.viewableHeight / 2.0;
				//this.destinationInWorldCoordinates.y = this.gameEngine.worldGroup.currentSetting.horizonHeight;
				this.destinationZoom = DEFAULT_ZOOM;
				adjustForViewableSettingBoundary();
			}
			if (MANUAL_MODE == this.mode)
			{
				adjustForViewableSettingBoundary();
			}
			//Debug.debug(this, "update() mode=" + this.mode + " <" + this.destinationInWorldCoordinates.x + ", " + this.destinationInWorldCoordinates.y + "> currentZoom=" + this.currentZoom + " destinationZoom=" + this.destinationZoom);
			//translatedCoordinates = translateToTweenCoordinates(this.destinationInWorldCoordinates.x, this.destinationInWorldCoordinates.y);
			//tween
			
			//TweenLite.to(this.gameEngine.worldGroup, .5, { scaleX:this.destinationZoom,
											//scaleY:this.destinationZoom,
											//ease:Strong.easeOut 	} );
			//this.currentZoom = this.destinationZoom;
			//leftInWorldCoordinates = PromWeek.GameEngine.getInstance().worldGroup.x;
			//topInWorldCoordinates = PromWeek.GameEngine.getInstance().worldGroup.y;
			//Utility.log(this, ("--------------\n" + 
			//"leftInWorldCoordinates: " + leftInWorldCoordinates + "\n"+
			//" -this.destinationInWorldCoordinates.x: " + -this.destinationInWorldCoordinates.x + "\n"+
			//" topInWorldCoordinates: " + topInWorldCoordinates + "\n"+
			//" -this.destinationInWorldCoordinates.y: " + -this.destinationInWorldCoordinates.y + "\n"+
			//" currentZoom: " + currentZoom + "\n"+
			//" this.destinationZoom: " + this.destinationZoom + "\n"));
			
			
			//this.currentZoom = this.destinationZoom;
			TweenLite.to(this, (shouldTween)?1.5:0.0 /*tweenTime()*/, { leftInWorldCoordinates: -this.destinationInWorldCoordinates.x, 	//x: -translatedCoordinates.x, 
												topInWorldCoordinates: -this.destinationInWorldCoordinates.y,//-translatedCoordinates.y,
											currentZoom:this.destinationZoom,
											ease:Strong.easeOut 	} );
											//ease:Linear.easeIn});
											
		}
		/**
		 * Determines the time the tweening should talk place.
		 * @return
		 */
		public function tweenTime():Number {
			//return .1;
			var seconds:Number = 1.0;
			return seconds;
			
			var zoomWidth:Number = Math.abs(this.destinationZoom  - this.currentZoom) * this.windowWidth;
			var dist:Number = Math.sqrt((this.destinationInWorldCoordinates.x - leftInWorldCoordinates) * (this.destinationInWorldCoordinates.x - this.leftInWorldCoordinates)
											+ (this.destinationInWorldCoordinates.y - this.topInWorldCoordinates)*(this.destinationInWorldCoordinates.y - this.topInWorldCoordinates));
			seconds = (zoomWidth > dist)?zoomWidth:dist;
			seconds /= this.tweenSpeed;
			return 4;//seconds;
		}
		
		/**
		 * Translates the non-setting offset camera coordinates to the offset
		 * background coordinates used by the setting/worldgroup.
		 * 
		 * @param	x The non-offset world x coordinate the camera uses.
		 * @param	y The non-offset world y coordinate the camera uses.
		 * @return The translated location.
		 */
		/*public function translateToTweenCoordinates(x:Number, y:Number):Point {
			var transX:Number;
			var transY:Number;
			
			transX = x - this.gameEngine.worldGroup.currentSetting.offsetX;
			transY = y - this.gameEngine.worldGroup.currentSetting.offsetY;
			
			return new Point(transX, transY);
		}*/
		
		/**
		 * Sets the zoom and translation of the camera to view as many of the
		 * characters in this.framedCharacters as possible.
		 * 
		 * If this.framedCharacters is empty, set mode to VIEW_SCENE.
		 */
		/*public function parameterizeOnAvatars():void {
			var a:Avatar;
			var leftmost:Number = this.gameEngine.worldGroup.currentSetting.viewableWidth;
			var rightmost:Number = 0.0;
			var top:Number = this.gameEngine.worldGroup.currentSetting.viewableHeight;
			var bottom:Number = 0.0;
			var horizontalZoom:Number;
			var verticalZoom:Number;
			
			if (this.framedAvatars.length < 1) {
				this.mode = VIEW_SCENE;
			}else {
				//find extreme character locations with character height/width padding.
				for each(a in this.framedAvatars) {
					//if (a.locY - a.height / 2.0 < top) top = a.locY - a.height / 2.0;
					//if (a.locY + a.height / 2.0 > bottom) bottom = a.locY + a.height / 2.0;
					//if (a.locX - a.width  / 2.0 < leftmost) leftmost = a.locX - a.width / 2.0;
					//if (a.locX + a.width  / 2.0 > rightmost) rightmost = a.locX + a.width / 2.0;
					if (a.locY < top) top = a.locY;
					if (a.locY > bottom) bottom = a.locY;
					if (a.locX < leftmost) leftmost = a.locX;
					if (a.locX > rightmost) rightmost = a.locX;
				}
				
				//Debug.debug(this, "parameterizeOnAvatars() count="+this.framedAvatars.length + " top=" + top + " bottom=" + bottom + " leftmost=" + leftmost + " rightmost=" + rightmost);
				
				//center on extreme locations average
				this.destinationInWorldCoordinates.y = top - 100; //+ this.gameEngine.worldGroup.currentSetting.offsetY;// (top + bottom) / 2.0;
				this.destinationInWorldCoordinates.x = leftmost - 100 ; //+ this.gameEngine.worldGroup.currentSetting.offsetX;// (leftmost + rightmost) / 2.0;
				//zoom as much as possible
				verticalZoom = (bottom - top) / this.windowHeight;
				horizontalZoom = (rightmost - leftmost) / this.windowWidth;
				//horizontalZoom = (horizontalZoom == 0)?1:horizontalZoom;
				//verticalZoom = (verticalZoom == 0)?1:verticalZoom;
				this.destinationZoom = (verticalZoom > horizontalZoom)?horizontalZoom:verticalZoom;
				
				//we have our desired zoom so adjust the topleft to encompass the most of the desired view
				//if ((bottom - top) > this.destinationZoom * this.windowHeight) {
					//the difference of the part we want to see and the zoom
					//this.destinationInWorldCoordinates.y += ((bottom - top) - (this.destinationZoom * this.windowHeight)) / 2.0;
				//}
				//
				//if ((rightmost - leftmost) > this.destinationZoom * this.windowWidth) {
					//the difference of the part we want to see and the zoom
					//this.destinationInWorldCoordinates.x += ((rightmost - leftmost) - (this.destinationZoom * this.windowWidth)) / 2.0;
				//}
				
				//kludge: set zoom very low and let adjustForViewableSettingBoundary() sort it out.
				//this.destinationZoom = .001;
				
				adjustForViewableSettingBoundary();
			}
		}
		*/
		/**
		 * Adjusts the camera's destination world coordinates to not breach
		 * the viewable area boundary. When zooming, the zoom will be capped
		 * to not allow the showing of the background past the boundary. Also,
		 * we will allow zooming to the destination zoom if there is room to
		 * zoom in other directions (e.g. if it is near the top left we can 
		 * zoom using the room to the bottom right).
		 * 
		 * If the viewport is being translated in world coordinates, the
		 * destination will be capped to no go over the boundary.
		 */
		private function adjustForViewableSettingBoundary():void {
			//var boundaryWidth:Number = this.worldWidth;
			//var this.worldHeight:Number = this.worldHeight;
			
			//var isZoomingOut:Boolean = (this.currentZoom > this.destinationZoom)?true:false;
			var isZoomingOut:Boolean = true
			var isTranslating:Boolean = (this.topLeftInWorldCoordinates != this.destinationInWorldCoordinates)?true:false;
			
			//zooming constraints
			var topConstrained:Boolean = false;
			var bottomConstrained:Boolean = false;
			var leftConstrained:Boolean = false;
			var rightConstrained:Boolean = false;
			
			var numZoomConstraints:int = 0;
			
			//zoom dimension increases
			var widthGrowth:Number;
			var heightGrowth:Number;
			
			//the maximum zooms in each direction before hitting this.world
			var maxTopZoom:Number;
			var maxLeftZoom:Number;
			var maxBottomZoom:Number;
			var maxRightZoom:Number;
			
			//post translation dimensions
			//var postTranslationWidth:Number;
			//var postTranslationHeight:Number;
			var oldy:Number = this.destinationInWorldCoordinates.y;
			
			//if (isTranslating) {
				//check top
				//if (this.destinationInWorldCoordinates.y < 0.0) {
					//Debug.debug(this, "adjustForViewableSettingBoundary(): top border violation - was " + this.destinationInWorldCoordinates.y.toPrecision(4) + " and is being reset to 0.0.");
					//this.destinationInWorldCoordinates.y = 0.0;
				//}
				//check left
				//if (this.destinationInWorldCoordinates.x < 0.0) {
					//Debug.debug(this, "adjustForViewableSettingBoundary(): left border violation - was " + this.destinationInWorldCoordinates.x.toPrecision(4) + " and is being reset to 0.0.");
					//this.destinationInWorldCoordinates.x = 0.0;
				//}
				//check bottom
				//if (this.destinationInWorldCoordinates.y + this.windowHeight > this.worldHeight * zoom) {
					//Debug.debug(this, "adjustForViewableSettingBoundary(): bottom border violation - " + (this.destinationInWorldCoordinates.y + this.windowHeight).toPrecision(4) + " was greater than " + (this.worldHeight * this.destinationZoom).toPrecision(4) + ". Reseting to " + (this.worldHeight * this.destinationZoom - this.windowHeight).toPrecision(4));
					//if (!isZoomingOut){
						//this.destinationInWorldCoordinates.y = this.worldHeight*zoom - this.windowHeight
					//}
				//}
				//check right
				//if (this.destinationInWorldCoordinates.x + this.windowWidth > this.worldWidth* zoom ) {
					//Debug.debug(this, "adjustForViewableSettingBoundary(): right border violation - " + (this.destinationInWorldCoordinates.x + this.worldWidth).toPrecision(4) + " was greater than " + (this.worldWidth * this.destinationZoom).toPrecision(4) + ". Reseting to " + (this.worldWidth* this.destinationZoom - this.windowWidth).toPrecision(4));
					//this.destinationInWorldCoordinates.x = this.worldWidth*zoom - this.windowWidth;
				//}
			//}
			
			//can continue growing if two adjacent edges are constrained.
			//If 3 edges or two opposing edges are constrained, we can only 
			//zoom to those constraints.
			//if (isZoomingOut) {
				//determine zoom dimension increases
				widthGrowth = this.windowWidth * ( (1.0 / this.destinationZoom) - (1.0 / this.currentZoom) );
				heightGrowth = this.windowHeight * ( (1.0 / this.destinationZoom) - (1.0 / this.currentZoom) );
				//Debug.debug(this, "adjustForViewableSettingBoundary(): widthGrowth: " + widthGrowth.toPrecision(4) + " heightGrowth: " + heightGrowth.toPrecision(4));
				//widthGrowth = (this.destinationZoom - this.currentZoom) * this.windowWidth;
				//heightGrowth = (this.destinationZoom - this.currentZoom) * this.windowHeight;
				
				//see where our constraints are
				if ( (this.destinationInWorldCoordinates.y ) < 0.0) {
					topConstrained = true;
					++numZoomConstraints;
				}
				if ( this.destinationInWorldCoordinates.y + this.windowHeight > this.worldHeight * zoom) {
					bottomConstrained = true;
					++numZoomConstraints;
				}
				if ( (this.destinationInWorldCoordinates.x ) < 0.0 ) {
					leftConstrained = true;
					++numZoomConstraints;
				}
				if ( this.destinationInWorldCoordinates.x + this.windowWidth > this.worldWidth* zoom) {
					rightConstrained = true;
					++numZoomConstraints;
				}
				//Debug.debug(this, "adjustForViewableSettingBoundary() isZooming, constraints=" + numZoomConstraints);
				
				/*
				 * 
				 */
				
				//get maximum zoom factors
				//maxTopZoom = (2 * (this.destinationInWorldCoordinates.y - 0.0) + getHeightOfViewableWorld()) / getHeightOfViewableWorld();
				//maxBottomZoom = ((2 * (this.worldHeight - this.destinationInWorldCoordinates.y + getHeightOfViewableWorld())) + windowHeight) / windowHeight;
				//maxLeftZoom = (2 * (this.destinationInWorldCoordinates.x - 0.0) + this.windowWidth) / this.windowWidth;				
				//maxRightZoom = ((2 * (this.worldWidth - this.destinationInWorldCoordinates.x + getWidthOfViewableWorld())) +windowWidth) / windowWidth;
				//
				//Debug.debug(this, "adjustForViewableSettingBoundary() max zoom <t,b,l,r>: <" + maxTopZoom.toPrecision(4) + ", " + maxBottomZoom.toPrecision(4) + ", " + maxLeftZoom.toPrecision(4) + ", " + maxRightZoom.toPrecision(4) + ">" );
				
				
				
				//do nothing if there are no constraints (numZoomConstraints == 0)
				if (1 == numZoomConstraints) {
					if (topConstrained) 
						this.destinationInWorldCoordinates.y = 0.0;
					else if (bottomConstrained)
						this.destinationInWorldCoordinates.y = this.worldHeight*zoom - this.windowHeight
					else if (leftConstrained)
						this.destinationInWorldCoordinates.x = 0.0;
					else if (rightConstrained)
						this.destinationInWorldCoordinates.x = this.worldWidth*zoom - this.windowWidth
					//zoom does not need to be changed.
					
					
				} else if (2 == numZoomConstraints) {
					//constrained on opposite edges; center viewport in this.world and find the highest zoom
					if (topConstrained && bottomConstrained) {
						this.destinationInWorldCoordinates.y = 0;
						//new top max zoom
						this.destinationZoom = this.windowHeight / this.worldHeight;
					}
					else if (leftConstrained && rightConstrained) {
						//horizontally center
						this.destinationInWorldCoordinates.x = 0.0
						//new left max zoom
						this.destinationZoom = this.windowWidth / this.worldWidth
					}
					else {
						if (topConstrained) {
							this.destinationInWorldCoordinates.y = 0.0 //heightGrowth / 2.0;
						}
						else {
							this.destinationInWorldCoordinates.y = this.worldHeight*zoom - this.windowHeight
						}
						if (leftConstrained) {
							this.destinationInWorldCoordinates.x = 0.0 //widthGrowth / 2.0;
						}
						else {
							this.destinationInWorldCoordinates.x = this.worldWidth*zoom - this.windowWidth
						}
					}
					
					
				} else if (3 == numZoomConstraints) {
					if (topConstrained && bottomConstrained) {
						this.destinationInWorldCoordinates.y = 0
						//new top max zoom
						this.destinationZoom = this.windowHeight / this.worldHeight
						if (leftConstrained)
							this.destinationInWorldCoordinates.x = 0.0
						else 
							this.destinationInWorldCoordinates.x = this.worldWidth*zoom - this.windowWidth
					}
					else {
						this.destinationInWorldCoordinates.x = 0.0
						//new left max zoom
						this.destinationZoom = this.windowWidth / this.worldWidth
						if (topConstrained)
							this.destinationInWorldCoordinates.y = 0
						if (bottomConstrained)
							this.destinationInWorldCoordinates.y = this.worldHeight*zoom - this.windowHeight
					}
				
				
				
				//else if (2 == numZoomConstraints || 3 == numZoomConstraints) {
					//find opposite constraint case
					//if ( (topConstrained && bottomConstrained) || (leftConstrained && rightConstrained) ) {
						//constrained on opposite edges; center viewport in this.world and find the highest zoom
						//if (topConstrained) {
							//vertically center
							//this.destinationInWorldCoordinates.y = (this.worldHeight / 2.0) - (windowHeight / 2.0);
							//new top max zoom
							//this.destinationZoom = (2 * (this.destinationInWorldCoordinates.y - 0.0) + this.windowHeight) / this.windowHeight;
						//}
						//else {
							//horizontally center
							//this.destinationInWorldCoordinates.x = (this.worldWidth / 2.0) - (windowWidth / 2.0);
							//new left max zoom
							//this.destinationZoom = (2 * (this.destinationInWorldCoordinates.x - 0.0) + this.windowWidth) / this.windowWidth;
						//}
					//}
					//if ( 3 == numZoomConstraints || !(topConstrained && bottomConstrained) || (leftConstrained && rightConstrained) ) {
						///*
						 //* Either 3 constraints or 2 constraints and those 2 are not opposite.
						 //* 
						 //* If there are 3 constraints, there has to be an opposite and adjacent constraint.
						 //* We only zoom to the opposite constraint and center (already done above).
						 //* We move the destination.{x,y} to avoid the adjacent constraint.
						 //*/
						//adjacent case: move two constraining edges growth/2 away from this.world and zoom
						//if (topConstrained)
							//this.destinationInWorldCoordinates.y = heightGrowth / 2.0;
						//else //has to be bottomConstrained
							//this.destinationInWorldCoordinates.y = this.worldHeight - getHeightOfViewableWorld() - heightGrowth / 2.0;
						//
						//if (!(leftConstrained && rightConstrained)){	
							//if (leftConstrained) 
								//this.destinationInWorldCoordinates.x = widthGrowth / 2.0;
							//else  // has to be right constrained
								//this.destinationInWorldCoordinates.x = this.worldWidth - getWidthOfViewableWorld() - widthGrowth / 2.0;
						//}
					//}
					//
				} else if (4 == numZoomConstraints) {
					
					/*
					 * Find the opposite pair that has the smallest max zoom when centered.
					 * Center that pair and set the destiation zoom to their max zoom.
					 * Find the most constrained of the other opposite pair and determine the
					 * distance of the new destination zoom on their axis.
					 * Adjust according to that new distance.
					 */
					var maxVerticalZoom:Number = (maxTopZoom + maxBottomZoom) / 2.0;
					var maxHorizontalZoom:Number = (maxLeftZoom + maxRightZoom) / 2.0;
					
					if (maxVerticalZoom < maxHorizontalZoom) {
						//vertically center
						this.destinationInWorldCoordinates.y = (this.worldHeight / 2.0) - (windowHeight / 2.0);
						//new top max zoom
						this.destinationZoom = (2 * (this.destinationInWorldCoordinates.y - 0.0) + this.windowHeight) / this.windowHeight;
						widthGrowth = (this.destinationZoom - this.currentZoom) * this.windowWidth;
						//if (maxLeftZoom < maxRightZoom) 
							//this.destinationInWorldCoordinates.x -= widthGrowth / 2.0;
						//else
							//this.destinationInWorldCoordinates.x += this.worldWidth - getWidthOfViewableWorld() - widthGrowth / 2.0;
						//Debug.debug(this, "adjustForViewableSettingBoundary() 4 constraints. V dest.y=" + this.destinationInWorldCoordinates.y + " dest.x=" + this.destinationInWorldCoordinates.x);
					}else {//limited by left and right
						//horizontally center
						this.destinationInWorldCoordinates.x = (this.worldWidth / 2.0) - (windowWidth / 2.0);
						//new left max zoom
						this.destinationZoom = (2 * (this.destinationInWorldCoordinates.x - 0.0) + this.windowWidth) / this.windowWidth;
						heightGrowth = (this.destinationZoom - this.currentZoom) * this.windowHeight;
						//if (maxTopZoom < maxBottomZoom) 
							//this.destinationInWorldCoordinates.y -= heightGrowth / 2.0;
						//else
							//this.destinationInWorldCoordinates.y += this.worldHeight - getHeightOfViewableWorld() - heightGrowth / 2.0;
						//Debug.debug(this, "adjustForViewableSettingBoundary() 4 constraints. H dest.y=" + this.destinationInWorldCoordinates.y + " dest.x=" + this.destinationInWorldCoordinates.x);
					}
				}
			//}
		}
		
		/*
		 * Returns true if a character is 'on screen', false if
		 * otherwise.  This is a stepping stone that will be useful for
		 * when we care about moving people 'off screen' when social games play.
		 * If they will already be off screen anyway, then maybe it doesn't matter!
		 * */
		public function isAvatarOnCamera(a:Avatar):Boolean {
			
			
			Debug.debug(this, a.characterName + " locX: " + a.locX + " locY: " + a.locY);
			Debug.debug(this, "cam x: " + this.leftInWorldCoordinates + " cam y: " + this.topInWorldCoordinates);
			Debug.debug(this, "cam width: " + this.getWidthOfViewableWorld() + " cam height: " + this.getHeightOfViewableWorld());
			Debug.debug(this, "cam zoom: " + this.currentZoom);
			
			
			//Figure out if the character is too far to the left or to the right.
			if ( (a.locX + a.clip.width / 2) < Math.abs(this.leftInWorldCoordinates)) { //Character is off to the left!
				Debug.debug(this, a.characterName + " is to the left");
				return false;
			}
			else if ( (a.locX - a.clip.width / 2) > Math.abs(this.leftInWorldCoordinates) + this.getWidthOfViewableWorld()) { // character is off to the right
				Debug.debug(this, a.characterName + " x: " + (a.locX - a.clip.width / 2) + " right edge of camera: " + (Math.abs(this.leftInWorldCoordinates) + this.getWidthOfViewableWorld()));
				Debug.debug(this, a.characterName + " is to the right");
				return false;
			}
			
			//Now try to figure out if the camera is too high or too low.
			if ( (a.locY - a.clip.height / 2) > (Math.abs(this.topInWorldCoordinates) + this.getHeightOfViewableWorld())) {
				Debug.debug(this, a.characterName + " is on the bottom");
				//Char is too low!
				return false
			}
			
			if ( (a.locY + a.clip.height / 2) < (Math.abs(this.topInWorldCoordinates))) {
				Debug.debug(this, a.characterName + " is too high");
				//Char is too high!
				return false
			}
			
			return true;
		}
		
		/**
		 * This function is very similar to isAvatarOnCamera, with two
		 * important exceptions:
		 * 1.) instaed of looking at the avatar's current location, we are looking at the avatar's destination.
		 * 2.) instead of looking at the camera's current location, we are looking at it's destination.
		 * @param	a
		 * @return
		 */
		public function willAvatarBeWhereCameraIsGoingToBe(a:Avatar):Boolean {
			
			//Debug.debug(this, a.characterName + " locX: " + a.locX + " locY: " + a.locY);
			//Debug.debug(this, "cam x: " + this.leftInWorldCoordinates + " cam y: " + this.topInWorldCoordinates);
			//Debug.debug(this, "cam width: " + this.getWidthOfViewableWorld() + " cam height: " + this.getHeightOfViewableWorld());
			//Debug.debug(this, "cam zoom: " + this.currentZoom);
			
			
			//Figure out if the character is too far to the left or to the right.
			if ( (a.destinationX + a.clip.width / 2) < Math.abs(this.destinationInWorldCoordinates.x)) { //Character is off to the left!
				//Debug.debug(this, a.characterName + " is to the left");
				return false;
			}
			else if ( (a.destinationX - a.clip.width / 2) > Math.abs(this.destinationInWorldCoordinates.x) + this.getWidthOfViewableWorld()) { // character is off to the right
				//Debug.debug(this, a.characterName + " is to the right");
				return false;
			}
			
			//Now try to figure out if the camera is too high or too low.
			if ( (a.destinationY - a.clip.height / 2) > (Math.abs(this.destinationInWorldCoordinates.y) + this.getHeightOfViewableWorld())) {
				//Debug.debug(this, a.characterName + " is on the bottom");
				//Char is too low!
				return false
			}
			
			if ( (a.destinationY + a.clip.height / 2) < (Math.abs(this.destinationInWorldCoordinates.y))) {
				//Debug.debug(this, a.characterName + " is too high");
				//Char is too high!
				return false
			}
			
			return true;
		}
		
		/**
		 * This overly named function is meant to look at the character's CURRENT position (not their destination)
		 * And also looks at the camera's DESTINATION (not it's current position), and determines whether or not a character
		 * will be standing in view (assuming that they don't move) when the camera hits this new position.
		 * 
		 * This will be used for determining whether a character needs to be "teleported" to right backstage,
		 * to help reduce the time walking from position to position.
		 */
		public function isAvatarCurrentlyWhereCameraIsGoingToBe(a:Avatar):Boolean {
//Figure out if the character is too far to the left or to the right.
			if ( (a.locX + a.clip.width / 2) < Math.abs(this.destinationInWorldCoordinates.x)) { //Character is off to the left!
				//Debug.debug(this, a.characterName + " is to the left");
				return false;
			}
			else if ( (a.locX - a.clip.width / 2) > Math.abs(this.destinationInWorldCoordinates.x) + this.getWidthOfViewableWorld()) { // character is off to the right
				//Debug.debug(this, a.characterName + " is to the right");
				return false;
			}
			
			//Now try to figure out if the camera is too high or too low.
			if ( (a.locY - a.clip.height / 2) > (Math.abs(this.destinationInWorldCoordinates.y) + this.getHeightOfViewableWorld())) {
				//Debug.debug(this, a.characterName + " is on the bottom");
				//Char is too low!
				return false
			}
			
			if ( (a.locY + a.clip.height / 2) < (Math.abs(this.destinationInWorldCoordinates.y))) {
				//Debug.debug(this, a.characterName + " is too high");
				//Char is too high!
				return false
			}
			
			return true;
		}
		
		/**
		 * This function figures out what direction on screen is the 'easiest' one
		 * for an avatar to get to (i.e. the edge of the screen that is closest to them)
		 * and then returns a point that they will be able to walk to and be safely off
		 * camera.
		 * @param	a the avatar that we hope to move
		 * @return a point those x, y coordinates represent the position that the avatar should walk to.
		 */
		public function nearestExit(a:Avatar):Point {
			var currentDistance:int = 1000; // start off with a high number.
			var tempDistance:Number;
			var walkingPoint:Point = new Point();
			
			//Start looking at the left.
			tempDistance = Math.sqrt(Math.pow(a.locX - this.destinationInWorldCoordinates.x, 2));
			if (tempDistance < currentDistance) {
				currentDistance = tempDistance;
				walkingPoint.x = (this.destinationInWorldCoordinates.x - a.clip.width/2);
				walkingPoint.y = a.locY;
			}
			
			//Now try going to the right.
			tempDistance = Math.sqrt(Math.pow(a.locX - (this.destinationInWorldCoordinates.x + this.getWidthOfViewableWorld()), 2));
			if (tempDistance < currentDistance) {
				currentDistance = tempDistance;
				walkingPoint.x = (this.destinationInWorldCoordinates.x + this.getWidthOfViewableWorld() + a.clip.width / 2);
				walkingPoint.y = a.locY;
			}

			//Lets try going to the bottom
			tempDistance = Math.sqrt(Math.pow(a.locY - (this.destinationInWorldCoordinates.y + this.getHeightOfViewableWorld()), 2));
			if (tempDistance < currentDistance) {
				currentDistance = tempDistance;
				walkingPoint.x = a.locX;
				walkingPoint.y = (this.destinationInWorldCoordinates.y + this.getWidthOfViewableWorld() + a.clip.height/2);
			}
			
			//I think we don't want to deal with top... we don't WANT people being able to walk off the top of the screen!
			
			return walkingPoint;
		}
		
		public function toString():String {
			
			var retstr:String;
			retstr = "<" + this.destinationInWorldCoordinates.x.toPrecision(4) + ", " + this.destinationInWorldCoordinates.y.toPrecision(4) + "> destinationInWorldCoordinates \n";
			retstr += "<" + this.leftInWorldCoordinates.toPrecision(4) + ", " + this.topInWorldCoordinates.toPrecision(4) + ">left and top InWorldCoordinates\n";
			retstr += "<" + this.getWidthOfViewableWorld().toPrecision(4) + ", " + this.getHeightOfViewableWorld().toPrecision(4) + ">width and height OfViewableWorld()\n";
			retstr += "<" + this.worldWidth.toPrecision(4) + ", " + this.worldHeight.toPrecision(4) + ">width and height of world()\n";
			retstr += "<" + (this.worldWidth*this.destinationZoom).toPrecision(4) + ", " + (this.worldHeight*this.destinationZoom).toPrecision(4) + ">zoomed width and height of world()\n";
			retstr += "destZoom: " + this.destinationZoom.toPrecision(4) + " curZoom: " + this.currentZoom.toPrecision(4) + "\n";
			retstr += "isZoomingOut: " + ((this.currentZoom > this.destinationZoom)?"true":"false") + "\n";
			retstr += "isTranslating: " + ((this.topInWorldCoordinates != this.destinationInWorldCoordinates.y || this.leftInWorldCoordinates != this.destinationInWorldCoordinates.x)?"true":"false") + "\n";
			retstr += "widthGrowth: " + (this.windowWidth * ( (1.0 / this.destinationZoom) - (1.0 / this.currentZoom))).toPrecision(4) + "\n";
			retstr += "heightGrowth: " + (this.windowHeight * ( (1.0 / this.destinationZoom) - (1.0 / this.currentZoom) )).toPrecision(4) + "\n";
			
			return retstr;
		}
		
		public function centerOnAllCharacters():void 
		{
			this.centerOnCharacters(PromWeek.GameEngine.getInstance().worldGroup.avatars);
		}
		
		
		public function getCorrectZoomForCharacters(avatars:Dictionary):Number
		{
			var testZoom:Number = 1.3;
			var testZoomInc:Number = 0.1;
			
			var testCamera:Camera = new Camera();
			
			var bestZoom:Number = 0.3;
			
			while (testZoom > 0.2)
			{
				var hasAllCharacters:Boolean = true;

				testZoom -= testZoomInc;
				testCamera.zoom = testZoom;
				testCamera.setWindowDimensions(this.windowHeight, this.windowWidth);
				testCamera.setWorldDimensions(gameEngine.worldGroup.currentSetting.viewableHeight, gameEngine.worldGroup.currentSetting.viewableWidth);
				
				for each (var avatar:Avatar in avatars)
				{	
					if (!testCamera.isAvatarCurrentlyWhereCameraIsGoingToBe(avatar))
					{
						hasAllCharacters = false;
					}
				}
				if (hasAllCharacters)
				{
					bestZoom = testZoom;
					return bestZoom;
				}
			}
			return testZoom;
		}
		
		public function centerOnCharacters(avatars:Dictionary):void 
		{
			var farLeft:Number = 999999;
			var farRight:Number = -999999;
			var lowestY:Number = -999999;
			var highestY:Number = 999999;
			for each (var avatar:Avatar in avatars)
			{
				if (avatar.destinationX < farLeft)
				{
					farLeft = avatar.destinationX;
				}
				if (avatar.destinationX > farRight)
				{
					farRight = avatar.destinationX;
				}
				if (avatar.destinationY > lowestY)
				{
					lowestY = avatar.destinationY;
				}
				if (avatar.destinationY < highestY)
				{
					highestY = avatar.destinationY;
				}
			}

			var avgX:Number = (farLeft + farRight) / 2;
			var avgY:Number = (lowestY + highestY) / 2;
			
			//this.zoom = 0.2;
			var perfectZoom:Number = this.getCorrectZoomForCharacters(avatars);
			this.absolutePositionCenter(avgX, avgY, perfectZoom);
		}
		
	}

}