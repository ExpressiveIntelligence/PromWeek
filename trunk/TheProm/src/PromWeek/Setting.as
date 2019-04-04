package PromWeek
{
	import com.facebook.graph.controls.Distractor;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import mx.controls.Image;  import com.util.SmoothImage;
	import mx.core.ResourceModuleRSLItem;
	import mx.flash.UIMovieClip;
	import spark.components.Group;
	import spark.core.SpriteVisualElement;
	import flash.utils.Dictionary;
	
	import CiF.Debug;
	import PromWeek.assets.ResourceLibrary;
	import com.util.SmoothImage;
	
	//import PromWeek.assets.settings.*;
	
	/**
	 * The Setting class contains all the information about scenario locations (e.g. cafeteria, the quad, etc.).
	 * The information stored here is also used for collision detection/character walking behavior.
	 * 
	 * @author Mike Treanor
	 */
	public class Setting
	{
		private var gameEngine:GameEngine;
		
		public var showZoneGrid:Boolean = false;
		
		//public var background:SmoothImage;
		public var background:Group;
		public var foreground:SmoothImage;//UIMovieClip;

		public var name:String;

		public var imgWidth:Number;
		public var imgHeight:Number;
		
		public var offsetX:Number;
		public var offsetY:Number;
		
		public var rightBuffer:Number;
		public var leftBuffer:Number;
		//public var topBuffer:Number;
		public var bottomBuffer:Number;
		
		public var horizonHeight:Number;
		
		public static const ZONE_RIGHT_BUFFER:int = 300; // to help keep people from going off the edge of the screen, there is a little bit of a buffer.
		public static const ZONE_LEFT_BUFFER:int = 300; // to help keep people from going off the edge of the screen, there is a little bit of a buffer.
		public static const ZONE_BOTTOM_BUFFER:int = 50; // to help keep people from going off the edge of the screen, there is a little bit of a buffer.
		public static const ZONE_TOP_BUFFER:int = 0; // to help keep people from going off the edge of the screen, there is a little bit of a buffer.
		
		public var cellWidth:Number;
		public var cellHeight:Number;
	
		public var collisionGrid:Array;
		
		
		
		public var zoneGrid:Array; // This is perhaps the exact same thing as the collision grid... this is used for character placement and bounds how far characters can idly walk.
		//The size that the zone grid should be.
		public var NUM_ZONE_ROWS:int;
		public var NUM_ZONE_COLS:int;
		
		// our maximum characters are determined by the size of the zone grid.
		// Namely, they are equal to: NUM_ZONE_COLS * Math.ceiling(NUM_ZONE_ROWS/3)
		public var maxCharacters:int; 
		
		
		
		/**
		 * The dimensions of the visible/usable portion of the background
		 * image. This are dimesions relative to the background offsets.
		 */
		public var viewableWidth:Number;
		public var viewableHeight:Number;
		
		public var backgroundToCharacterScale:Number = 1.0;
		
		// this is used for the refactoring of ResourceLibrary
		public static var settings:Dictionary
		
		// grab a resource library
		public static var resourceLibrary:ResourceLibrary;
		
		public function Setting(name1:String)
		{
			this.leftBuffer = Setting.ZONE_LEFT_BUFFER
			this.rightBuffer = Setting.ZONE_RIGHT_BUFFER
			this.bottomBuffer = Setting.ZONE_BOTTOM_BUFFER;
			name = name1;
			
			//this.topBuffer = 
		}
		
		
		public static function initializeSettingsData():void {
			//larger background to character scale numbers means the background will be larger in relation to the characters.
			
			resourceLibrary = ResourceLibrary.getInstance()
			//SETTINGS
			settings = new Dictionary()
			//lockers
			settings["lockers"] = new Setting("lockers");
			if ("spark.components::Group" == getQualifiedClassName(resourceLibrary.backgrounds["lockers"])) {
				settings["lockers"].background = resourceLibrary.backgrounds["lockers"]
			}else {
				
				settings["lockers"].background = new Group();
				(settings["lockers"].background as Group).addElement(resourceLibrary.backgrounds["lockers"] as SmoothImage);
			}
			settings["lockers"].setBackgroundToCharacterScale(0.9);
			//the distance from the top of the part of the image that we care about to the top of the aCTUAL image in ugly town
			//Also from the left to the far left.  (might have to be negative).
			settings["lockers"].offsetX = 0;
			settings["lockers"].offsetY = 0;
			//The ACTUAL width and height of the image, with all of the ugly stuff.
			settings["lockers"].imgWidth = settings["lockers"].backgroundToCharacterScale * 2432.000;
			settings["lockers"].imgHeight = settings["lockers"].backgroundToCharacterScale * 1376.000;
			settings["lockers"].horizonHeight = settings["lockers"].backgroundToCharacterScale * (800 + 75); // This is at the ground to wall boundary (closer to what we want, I think).
			//settings["lockers"].horizonHeight = settings["lockers"].backgroundToCharacterScale * (925); // Gives us plenty of space so we don't walk on the walls.).
			//the width and height of the part of the image that we CARE about (no ugly stuff on borders)
			settings["lockers"].viewableWidth = settings["lockers"].backgroundToCharacterScale * 2432.000;//1525;
			settings["lockers"].viewableHeight = settings["lockers"].backgroundToCharacterScale * 1376.000;//1525;
			settings["lockers"].cellWidth = 100;
			settings["lockers"].cellHeight = 25;
			settings["lockers"].NUM_ZONE_ROWS = 3;
			settings["lockers"].NUM_ZONE_COLS = 5;
			settings["lockers"].maxCharacters = settings["lockers"].NUM_ZONE_COLS * Math.ceil(settings["lockers"].NUM_ZONE_ROWS/3)
			settings["lockers"].initCollisionGrid();
			settings["lockers"].initZoneGrid();
			
			// init the classroom
			settings["classroom"] = new Setting("classroom");
			if ("spark.components::Group" == getQualifiedClassName(resourceLibrary.backgrounds["classroom"])) {
				settings["classroom"].background = resourceLibrary.backgrounds["classroom"]
			}else {
				
				settings["classroom"].background = new Group();
				(settings["classroom"].background as Group).addElement(resourceLibrary.backgrounds["classroom"] as SmoothImage);
			}
			//settings["classroom"].background = resourceLibrary.backgrounds["classroom"]
			settings["classroom"].setBackgroundToCharacterScale(0.75);
			settings["classroom"].offsetX = 0;
			settings["classroom"].offsetY = 0;
			settings["classroom"].leftBuffer= 500 * settings["classroom"].backgroundToCharacterScale;;
			settings["classroom"].rightBuffer = 500* settings["classroom"].backgroundToCharacterScale;;
			settings["classroom"].bottomBuffer = 50; // 150;
			//72dpi
			settings["classroom"].horizonHeight = 1000 * settings["classroom"].backgroundToCharacterScale;
			settings["classroom"].imgWidth = 2670 * settings["classroom"].backgroundToCharacterScale;
			settings["classroom"].imgHeight = 1500 * settings["classroom"].backgroundToCharacterScale;
			settings["classroom"].viewableWidth = 2670* settings["classroom"].backgroundToCharacterScale;
			settings["classroom"].viewableHeight = 1350* settings["classroom"].backgroundToCharacterScale;
			//svg or 90dpi
			//settings["classroom"].horizonHeight = 1090 * settings["classroom"].backgroundToCharacterScale;
			//settings["classroom"].imgWidth = 3340 * settings["classroom"].backgroundToCharacterScale;
			//settings["classroom"].imgHeight = 1690 * settings["classroom"].backgroundToCharacterScale;
			//settings["classroom"].viewableWidth = 3340* settings["classroom"].backgroundToCharacterScale;
			//settings["classroom"].viewableHeight = 1690 * settings["classroom"].backgroundToCharacterScale;
			settings["classroom"].cellWidth = 100;
			settings["classroom"].cellHeight = 25;
			settings["classroom"].NUM_ZONE_ROWS = 4;
			settings["classroom"].NUM_ZONE_COLS = 4;
			settings["classroom"].maxCharacters = settings["classroom"].NUM_ZONE_COLS * Math.ceil(settings["classroom"].NUM_ZONE_ROWS/3)
			settings["classroom"].initCollisionGrid();
			settings["classroom"].initZoneGrid();
			
			// init the cornerstore
			settings["cornerstore"] = new Setting("cornerstore");
			if ("spark.components::Group" == getQualifiedClassName(resourceLibrary.backgrounds["cornerstore"])) {
				settings["cornerstore"].background = resourceLibrary.backgrounds["cornerstore"]
			}else {
				
				settings["cornerstore"].background = new Group();
				(settings["cornerstore"].background as Group).addElement(resourceLibrary.backgrounds["cornerstore"] as SmoothImage);
			}
			//settings["cornerstore"].background = resourceLibrary.backgrounds["cornerstore"]
			settings["cornerstore"].setBackgroundToCharacterScale(0.7);
			settings["cornerstore"].offsetX = 0;
			settings["cornerstore"].offsetY = -500 * settings["cornerstore"].backgroundToCharacterScale;
			settings["cornerstore"].horizonHeight = 1250 * settings["cornerstore"].backgroundToCharacterScale;
			settings["cornerstore"].imgWidth = 2210 * settings["cornerstore"].backgroundToCharacterScale;
			settings["cornerstore"].imgHeight = 2390 * settings["cornerstore"].backgroundToCharacterScale;
			settings["cornerstore"].viewableWidth = 2210* settings["cornerstore"].backgroundToCharacterScale;
			settings["cornerstore"].viewableHeight = 1890 * settings["cornerstore"].backgroundToCharacterScale;
			settings["cornerstore"].leftBuffer= 275;
			settings["cornerstore"].rightBuffer = 275;
			settings["cornerstore"].cellWidth = 100;
			settings["cornerstore"].cellHeight = 25;
			settings["cornerstore"].NUM_ZONE_ROWS = 4;
			settings["cornerstore"].NUM_ZONE_COLS = 4;
			settings["cornerstore"].maxCharacters = settings["cornerstore"].NUM_ZONE_COLS * Math.ceil(settings["cornerstore"].NUM_ZONE_ROWS/3)
			settings["cornerstore"].initCollisionGrid();
			settings["cornerstore"].initZoneGrid();

			// init prom
			settings["prom"] = new Setting("prom")
			if ("spark.components::Group" == getQualifiedClassName(resourceLibrary.backgrounds["prom"])) {
				settings["prom"].background = resourceLibrary.backgrounds["prom"]
			}else {
				
				settings["prom"].background = new Group();
				(settings["prom"].background as Group).addElement(resourceLibrary.backgrounds["prom"] as SmoothImage);
			}
			//settings["prom"].background = resourceLibrary.backgrounds["prom"]
			settings["prom"].setBackgroundToCharacterScale(1.1);
			//settings["prom"].foreground = img;
			settings["prom"].offsetX = 0;
			settings["prom"].offsetY = -600 * settings["prom"].backgroundToCharacterScale;
			settings["prom"].horizonHeight = settings["prom"].backgroundToCharacterScale * 670;
			settings["prom"].imgWidth = settings["prom"].backgroundToCharacterScale * 3525;
			settings["prom"].imgHeight = settings["prom"].backgroundToCharacterScale * 1850//1525;
			settings["prom"].viewableWidth = settings["prom"].backgroundToCharacterScale * 3525;
			settings["prom"].viewableHeight = settings["prom"].backgroundToCharacterScale * 1250;//1525;
			settings["prom"].leftBuffer= settings["prom"].backgroundToCharacterScale * 860;
			settings["prom"].rightBuffer = settings["prom"].backgroundToCharacterScale * 960;
			//settings["classroom"].topBuffer= 500;
			settings["prom"].bottomBuffer = settings["prom"].backgroundToCharacterScale * 250;
			settings["prom"].cellWidth = 100;
			settings["prom"].cellHeight = 25;
			settings["prom"].NUM_ZONE_ROWS = 5;
			settings["prom"].NUM_ZONE_COLS = 5;
			settings["prom"].maxCharacters = settings["prom"].NUM_ZONE_COLS * Math.ceil(settings["prom"].NUM_ZONE_ROWS/3)
			settings["prom"].initCollisionGrid();
			settings["prom"].initZoneGrid();
			
			// init neighborhood
			settings["neighborhood"] = new Setting("neighborhood")
			if ("spark.components::Group" == getQualifiedClassName(resourceLibrary.backgrounds["neighborhood"])) {
				settings["neighborhood"].background = resourceLibrary.backgrounds["neighborhood"]
			}else {
				
				settings["neighborhood"].background = new Group();
				(settings["neighborhood"].background as Group).addElement(resourceLibrary.backgrounds["neighborhood"] as SmoothImage);
			}
			//settings["neighborhood"].background = resourceLibrary.backgrounds["neighborhood"]
			settings["neighborhood"].setBackgroundToCharacterScale(1.2);
			//settings["neighborhood"].foreground = img;
			settings["neighborhood"].offsetX = -100* settings["neighborhood"].backgroundToCharacterScale;
			settings["neighborhood"].offsetY = -250 * settings["neighborhood"].backgroundToCharacterScale;
			settings["neighborhood"].horizonHeight = 525 * settings["neighborhood"].backgroundToCharacterScale;
			settings["neighborhood"].viewableWidth = 990 * settings["neighborhood"].backgroundToCharacterScale;
			settings["neighborhood"].viewableHeight = 864 * settings["neighborhood"].backgroundToCharacterScale;
			settings["neighborhood"].imgWidth = 1113 * settings["neighborhood"].backgroundToCharacterScale;
			settings["neighborhood"].imgHeight = 864 * settings["neighborhood"].backgroundToCharacterScale;
			//settings["neighborhood"].leftBuffer= settings["neighborhood"].backgroundToCharacterScale * 100;
			//settings["neighborhood"].rightBuffer = settings["neighborhood"].backgroundToCharacterScale * 100;
			settings["neighborhood"].leftBuffer= 250 * settings["neighborhood"].backgroundToCharacterScale;
			settings["neighborhood"].rightBuffer = 250 * settings["neighborhood"].backgroundToCharacterScale;
			settings["neighborhood"].bottomBuffer = 50; // 150;
			settings["neighborhood"].cellWidth = 100;
			settings["neighborhood"].cellHeight = 25;
			settings["neighborhood"].NUM_ZONE_ROWS = 3;
			settings["neighborhood"].NUM_ZONE_COLS = 5;
			settings["neighborhood"].maxCharacters = settings["neighborhood"].NUM_ZONE_COLS * Math.ceil(settings["neighborhood"].NUM_ZONE_ROWS/3)
			settings["neighborhood"].initCollisionGrid();
			settings["neighborhood"].initZoneGrid();
			
			// init the park
			settings["park"] = new Setting("park")
			
			if ("spark.components::Group" == getQualifiedClassName(resourceLibrary.backgrounds["park"])) {
				settings["park"].background = resourceLibrary.backgrounds["park"]
				Debug.debug(Setting, "initializeSettingData() " + getQualifiedClassName(resourceLibrary.backgrounds["park"]));
			}else {
				
				settings["park"].background = new Group();
				(settings["park"].background as Group).addElement(resourceLibrary.backgrounds["park"] as SmoothImage);
			}
			//settings["park"].background = resourceLibrary.backgrounds["park"]
			settings["park"].setBackgroundToCharacterScale(0.70);
			settings["park"].offsetX = -50 * settings["park"].backgroundToCharacterScale; //0
			settings["park"].offsetY = -800 * settings["park"].backgroundToCharacterScale; //-200
			settings["park"].horizonHeight = 1050 * settings["park"].backgroundToCharacterScale;
			settings["park"].viewableWidth = settings["park"].backgroundToCharacterScale * 2200;
			settings["park"].viewableHeight = settings["park"].backgroundToCharacterScale * 1650;
			settings["park"].imgWidth = settings["park"].backgroundToCharacterScale * 2382;
			settings["park"].imgHeight = settings["park"].backgroundToCharacterScale * 2492;
			settings["park"].leftBuffer = 300;//200 / settings["park"].backgroundToCharacterScale;
			settings["park"].rightBuffer = 300;//200 / settings["park"].backgroundToCharacterScale;
			settings["park"].bottomBuffer = 50; //150 / settings["park"].backgroundToCharacterScale;
			settings["park"].cellWidth = 100;
			settings["park"].cellHeight = 25;
			settings["park"].NUM_ZONE_ROWS = 3;
			settings["park"].NUM_ZONE_COLS = 5;
			settings["park"].maxCharacters = settings["park"].NUM_ZONE_COLS * Math.ceil(settings["park"].NUM_ZONE_ROWS/3)
			settings["park"].initCollisionGrid();
			settings["park"].initZoneGrid();
			
			
			
			// init the facade level
			settings["facade"] = new Setting("facade")
			
			if ("spark.components::Group" == getQualifiedClassName(resourceLibrary.backgrounds["facade"])) {
				settings["facade"].background = resourceLibrary.backgrounds["facade"]
				Debug.debug(Setting, "initializeSettingData() " + getQualifiedClassName(resourceLibrary.backgrounds["facade"]));
			}else {
				
				settings["facade"].background = new Group();
				(settings["facade"].background as Group).addElement(resourceLibrary.backgrounds["facade"] as SmoothImage);
			}
			//settings["facade"].background = resourceLibrary.backgrounds["facade"]
			settings["facade"].setBackgroundToCharacterScale(0.55);
			settings["facade"].offsetX = settings["facade"].backgroundToCharacterScale; //0
			settings["facade"].offsetY = settings["facade"].backgroundToCharacterScale; //-200
			settings["facade"].horizonHeight = 1450 * settings["facade"].backgroundToCharacterScale;
			settings["facade"].viewableWidth = settings["facade"].backgroundToCharacterScale * 2099;
			settings["facade"].viewableHeight = settings["facade"].backgroundToCharacterScale * 2046;
			settings["facade"].imgWidth = settings["facade"].backgroundToCharacterScale * 2099;
			settings["facade"].imgHeight = settings["facade"].backgroundToCharacterScale * 2046;
			settings["facade"].leftBuffer= settings["facade"].backgroundToCharacterScale * 550;
			settings["facade"].rightBuffer = settings["facade"].backgroundToCharacterScale * 550;
			settings["facade"].bottomBuffer = settings["facade"].backgroundToCharacterScale * 300;
			settings["facade"].cellWidth = 100;
			settings["facade"].cellHeight = 25;
			settings["facade"].NUM_ZONE_ROWS = 3;
			settings["facade"].NUM_ZONE_COLS = 4;
			settings["facade"].maxCharacters = settings["facade"].NUM_ZONE_COLS * Math.ceil(settings["facade"].NUM_ZONE_ROWS/3)
			settings["facade"].initCollisionGrid();
			settings["facade"].initZoneGrid();
			
			
			
			
			//Debug.debug(Setting, "initializeSettingsData() park size: " + (resourceLibrary.backgrounds["park"] as SmoothImage).width + ", " + (resourceLibrary.backgrounds["park"] as SmoothImage).height);
			
			// init the park
			settings["parkinglot"] = new Setting("parkinglot")
			if ("spark.components::Group" == getQualifiedClassName(resourceLibrary.backgrounds["parkinglot"])) {
				settings["parkinglot"].background = resourceLibrary.backgrounds["parkinglot"]
			}else {
				
				settings["parkinglot"].background = new Group();
				(settings["parkinglot"].background as Group).addElement(resourceLibrary.backgrounds["parkinglot"] as SmoothImage);
			}
			//settings["parkinglot"].background = resourceLibrary.backgrounds["parkinglot"]
			settings["parkinglot"].setBackgroundToCharacterScale(0.85);
			settings["parkinglot"].offsetX = -150 * settings["parkinglot"].backgroundToCharacterScale;
			settings["parkinglot"].offsetY = -450 * settings["parkinglot"].backgroundToCharacterScale;
			settings["parkinglot"].horizonHeight = 750* settings["parkinglot"].backgroundToCharacterScale;
			settings["parkinglot"].viewableWidth = 1675 * settings["parkinglot"].backgroundToCharacterScale;
			settings["parkinglot"].viewableHeight = 1365 * settings["parkinglot"].backgroundToCharacterScale;
			settings["parkinglot"].imgWidth = 1902 * settings["parkinglot"].backgroundToCharacterScale;
			settings["parkinglot"].imgHeight = 1826 * settings["parkinglot"].backgroundToCharacterScale;
			settings["parkinglot"].leftBuffer= 275;
			settings["parkinglot"].rightBuffer = 275;
			settings["parkinglot"].bottomBuffer = 50; // 150;
			//settings["classroom"].topBuffer= 500;
			settings["parkinglot"].cellWidth = 100;
			settings["parkinglot"].cellHeight = 25;
			settings["parkinglot"].NUM_ZONE_ROWS = 3;
			settings["parkinglot"].NUM_ZONE_COLS = 4;
			settings["parkinglot"].maxCharacters = settings["parkinglot"].NUM_ZONE_COLS * Math.ceil(settings["parkinglot"].NUM_ZONE_ROWS/3)
			settings["parkinglot"].initCollisionGrid();
			settings["parkinglot"].initZoneGrid();
			
			// init the quad
			settings["quad"] = new Setting("quad")
			if ("spark.components::Group" == getQualifiedClassName(resourceLibrary.backgrounds["quad"])) {
				settings["quad"].background = resourceLibrary.backgrounds["quad"]
			}else {
				
				settings["quad"].background = new Group();
				(settings["quad"].background as Group).addElement(resourceLibrary.backgrounds["quad"] as SmoothImage);
			}
			//settings["quad"].background = resourceLibrary.backgrounds["quad"]
			settings["quad"].setBackgroundToCharacterScale(1.0);
			settings["quad"].offsetX = 0;
			settings["quad"].offsetY = -300 * settings["quad"].backgroundToCharacterScale;
			//settings["quad"].horizonHeight = 860 * settings["quad"].backgroundToCharacterScale;
			//settings["quad"].viewableWidth = 2880 * settings["quad"].backgroundToCharacterScale;
			//settings["quad"].viewableHeight = 1360 * settings["quad"].backgroundToCharacterScale;
			//settings["quad"].imgWidth = 2880 * settings["quad"].backgroundToCharacterScale;
			//settings["quad"].imgHeight = 1360 * settings["quad"].backgroundToCharacterScale;settings["quad"].horizonHeight = 860 * settings["quad"].backgroundToCharacterScale;
			settings["quad"].horizonHeight = 550 * settings["quad"].backgroundToCharacterScale;
			settings["quad"].viewableWidth =  1386 * settings["quad"].backgroundToCharacterScale;
			//settings["quad"].viewableHeight = 892 * settings["quad"].backgroundToCharacterScale;
			settings["quad"].viewableHeight = 1092 * settings["quad"].backgroundToCharacterScale;
			settings["quad"].imgWidth = 1386 * settings["quad"].backgroundToCharacterScale;
			settings["quad"].imgHeight = 1392 * settings["quad"].backgroundToCharacterScale;
			settings["quad"].leftBuffer = 275 ;
			settings["quad"].rightBuffer = 275;
			settings["quad"].bottomBuffer = 50; // 150;
			settings["quad"].cellWidth = 100;
			settings["quad"].cellHeight = 25;
			settings["quad"].NUM_ZONE_ROWS = 4;
			settings["quad"].NUM_ZONE_COLS = 4;
			settings["quad"].maxCharacters = settings["quad"].NUM_ZONE_COLS * Math.ceil(settings["quad"].NUM_ZONE_ROWS/3)
			settings["quad"].initCollisionGrid();
			settings["quad"].initZoneGrid();
		}
		
		public function onCreationComplete():void
		{
		}
		
		public function setBackgroundToCharacterScale(num:Number):void
		{
			backgroundToCharacterScale = num;
			
			background.scaleX = num;
			background.scaleY = num;
			if (foreground)
			{
				foreground.scaleX = num;
				foreground.scaleY = num;
			}
		}
		
		/**
		 * This creates and initializes the collision grid for this setting. 0 means nothing is in the way, 1 means something is there
		 */
		public function initCollisionGrid():void
		{
			var sizeX:int = imgWidth / cellWidth;
			var sizeY:int = (imgHeight - horizonHeight)/ cellHeight;
			collisionGrid = new Array(sizeX);
			for (var i:int = 0; i < sizeX ; i++ )
			{
				collisionGrid[i] = new Array(sizeY);
				for (var j:int = 0; j < sizeY; j++) 
				{
					collisionGrid[i][j] = "";
				}					
			}
		}
		
		/**
		 * This splits the current setting into a collection of zones (NUM_ZONE_ROWS x NUM_ZONE_COLS).
		 * any given zone is where characters like to stand when they are not playing games, and also
		 * defines where they can meander whil they are in idle behavior.
		 */
		public function initZoneGrid():void {
			zoneGrid = new Array(NUM_ZONE_ROWS);
			var realImageWidth:int = this.viewableWidth - (this.leftBuffer + this.rightBuffer); // takes the buffers into account.
			var realImageHeight:int = this.viewableHeight - (horizonHeight + this.bottomBuffer); // takes the horizon line and the bottom buffer into account.
			for (var i:int = 0; i < NUM_ZONE_ROWS; i++) {
				zoneGrid[i] = new Array(NUM_ZONE_COLS);
				
				for (var j:int = 0; j < NUM_ZONE_COLS; j++) {
					var tempZone:Zone = new Zone();
					tempZone.row = i;
					tempZone.col = j;
					tempZone.width = realImageWidth / NUM_ZONE_COLS;
					tempZone.height = realImageHeight / NUM_ZONE_ROWS;
					
					Debug.debug(this, "Zone Width: " + tempZone.width + " Zone Height: " + tempZone.height);
	
					tempZone.isOccupied = false;
					tempZone.center = new Point();
					tempZone.center.x = (realImageWidth / NUM_ZONE_COLS / 2 ) + (tempZone.width * tempZone.col) + this.leftBuffer; // START HERE!
					//tempZone.center.y = (imgHeight / NUM_ZONE_ROWS / 2) + (tempZone.height * tempZone.row);
					tempZone.center.y = (horizonHeight + tempZone.height / 2) + (tempZone.height * tempZone.row);
					tempZone.leftBoundary = tempZone.center.x - tempZone.width / 2;
					tempZone.topBoundary = tempZone.center.y - tempZone.height / 2;
					if (i == 0 && j == 0) {
						//Debug.debug(this, "initZoneGrid() zone[0][0] top is: " + tempZone.topBoundary + " left is: " + tempZone.leftBoundary + " centerX: " + tempZone.center.x + "centerY: " + tempZone.center.y);
					}
					
					zoneGrid[i][j] = tempZone;
				}
			}
			
			/*
			Debug.debug(this, "initZoneGrid() setting horizon line is: " + horizonHeight);
			for (i = 0; i < NUM_ZONE_ROWS; i++) {
				for (j = 0; j < NUM_ZONE_COLS; j++) {
					//Debug.debug(this, zoneGrid[i][j].toString());
				}
			}
			*/
		}
		
		/**
		 * This function is meant to be called at the end of a level.  It goes through the zone
		 * grid and makes every square unoccupied, so that characters can get placed there again
		 * for future levels!
		 */
		public function clearZoneGrid():void {
			for (var i:int = 0; i < this.NUM_ZONE_ROWS; i++) {
				for (var j:int = 0; j < this.NUM_ZONE_COLS; j++) {
					zoneGrid[i][j].isOccupied = false;
					zoneGrid[i][j].occupyingCharacter = "";
				}
			}
		}
		
		
		/**
		 * This function simply looks at where the avatar is
		 * and marks the zone that they are in as 'unoccupied'
		 * as well as the zone above and below the avatar.
		 * It however, does not CHANGE what the current zone of the avatar is,
		 * because that gets used in other places and so I want the avatar
		 * to be able to remember that!
		 * @param	char the avatar that is going to be moved from the zone grid.
		 */
		public function openUpAvatarZoneAndNeighbors(char:Avatar):void {
			if (char.currentZone) {
				zoneGrid[char.currentZone.row][char.currentZone.col].isOccupied = false;
				if (char.currentZone.row > 0) {
					zoneGrid[char.currentZone.row - 1][char.currentZone.col].isOccupied = false; // the spot above this character is up for grabs now, too!
				}
				if (char.currentZone.row < this.NUM_ZONE_ROWS - 1){
					zoneGrid[char.currentZone.row + 1][char.currentZone.col].isOccupied = false; // the spot below this character is up for grabs now, too!
				}
			}
		}
		
		/**
		 * This function takes a single avatar and 'places' them into a zone
		 * It checks to make sure that the zone is not occupied -- if the zone
		 * is occupied, it will return false for unsuccessful.  It will also update
		 * the avatar's current zone.
		 * 
		 * @param	char the avatar to place in a zone.
		 * @param   row the row in the zoneGrid to place the character
		 * @param   col the col in the zoneGrid to place the character.
		 */
		public function placeAvatarInZone(char:Avatar, row:int, col:int):Boolean {
			openUpAvatarZoneAndNeighbors(char);
			char.currentZone = null; //And don't forget to remove them from their current zone, if they are already in one!
			if (!this.zoneGrid[row][col].isOccupied) {
				char.currentZone = this.zoneGrid[row][col];
				if (char.currentZone.row > 0) {
					zoneGrid[char.currentZone.row - 1][char.currentZone.col].isOccupied = true; // don't let people stand immidietely above the character
				}
				if (char.currentZone.row < this.NUM_ZONE_ROWS - 1) {
					zoneGrid[char.currentZone.row + 1][char.currentZone.col].isOccupied = true; // don't let people stand immidietely below the character, either.
				}
				this.zoneGrid[row][col].occupyingCharacter = char.characterName
				this.zoneGrid[row][col].isOccupied = true;
				//Debug.debug(this, "placeAvatarInZone() placed avatar: " + char.characterName + " into zone row: " + row + " and col: " + col);
				
				return true;
			}
			else { // oops!  The zone was already occupied! Put them in the first unoccupied zone we find.
				for (var i:int = 0; i < NUM_ZONE_ROWS; i++) {
					for (var j:int = 0; j < NUM_ZONE_COLS; j++) {
						if (!zoneGrid[i][j].isOccupied) {
							char.currentZone = this.zoneGrid[i][j];
							this.zoneGrid[i][j].occupyingCharacter = char.characterName;
							this.zoneGrid[i][j].isOccupied = true;
							return false;
						}
					}
				}
				
			}
			return false; // we should never get here!  If we do we are in really big trouble!
		}
		
		/** Sets the collisionGrid's values properly based on moving characters. 0 means open, 1 means a character is there, 2 means a static shape is there
		 * 
		 * 
		 */
		public function updateCollisionGrid():void
		{
			if (gameEngine == null)
			{
				gameEngine = GameEngine.getInstance();
			}
			
			var avatar:Avatar;
			for (var i:int = 0; i < collisionGrid.length ; i++ )
			{
				for (var j:int = 0; j < collisionGrid[i].length; j++) 
				{
					var hasBeenSet:Boolean = false;
					if (collisionGrid[i][j] != 2)
					{
						for each (avatar in gameEngine.worldGroup.avatars)
						{
							var currGridLoc:Point = avatar.getCurrGridLocation();
							//if ((Math.floor(avatar.locX / cellWidth) == i) && (Math.floor((avatar.locY - horizonHeight + avatar.clip.height/2) / cellHeight) == j))
							if (currGridLoc.x == i && currGridLoc.y == j)
							{
								hasBeenSet = true;
								//this means a character is there
								collisionGrid[i][j] = 1;
								if (j - 1 >= 0)
									collisionGrid[i][j - 1] = 1;
								if (j - 2 >= 0)
									collisionGrid[i][j - 2] = 1;
								if (j - 3 >= 0)
									collisionGrid[i][j - 3] = 1;
							}
						}
						if (!hasBeenSet)
						{
							//this means nothing is there
							collisionGrid[i][j] = 0;
						}
					}
				}					
			}
		}
	}
}