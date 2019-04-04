
package edu.ucsc.eis
{
	import __AS3__.vec.Vector;
	
	//import edu.ucsc.eis.socialgame.*;
	//import edu.ucsc.eis.socialservices.*;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flash.display.*;
	import flash.events.*;
	import mx.collections.*;
	import mx.core.*;
	import spark.components.*;
	
	import mx.containers.Canvas;
	
/******************************************************************************
 * edu.ucsc.eis.GameEngine
 * 
 * GameEngine class
 * 
 * This class is the heart of the game game -- it intiates and has as member
 * variables the AI, graphics, sound, resource, and input systems. It is a 
 * singleton that is created in the mxml script tag the starts the game view.
 * 
 * At a high level, the program is running under the game engine the vast
 * majority of the time. However, high level control is relented to the top
 * level application (instantiated by the mxml file) after each frame is
 * processed by the game engine. After a frame has finished, the top level 
 * application passes control back to the game engine via the enterFrame()
 * callback of the top level graphics container to which the game is rendered
 * (this is likely to be a graphics canvas).
 * 
 * TODO: make a game object class or make an analogous entity management class.
 * TODO: add the functionality of commented functions
 *****************************************************************************/

	
	public class GameEngine extends EventDispatcher
	{
		private var flip:Number;
		
		//major components
		//XXX should be a flex4 vectors.
		//private var socials:Vector.<SocialEntity>;

		/* Social game library */
		//private var sglib:SocialGameLibrary;

		/* social state database */
		//private var socialState:SocialState;

		private var environmentObjects:Entity;
		private var player:Entity;
		
		
		private var graphicsContainer:Panel;
		
		
		//timing variables
		private var previousFrameStartTime:Number;
		private var frameCount:int;
		
		//configuration variables
		
		

		// double buffer
		public var backBuffer:BitmapData;
		// colour to use to clear backbuffer with 
		public var clearColor:uint = 0xFF0043AB;
		// static instance 
		protected static var instance:GameEngine= null;
		// the last frame time 
		protected var lastFrame:Date;
		// a collection of the GameObjects 
		protected var gameObjects:ArrayCollection = new ArrayCollection();
		// a collection where new GameObjects are placed, to avoid adding items 
		// to gameObjects while in the gameObjects collection while it is in a loop
		protected var newGameObjects:ArrayCollection = new ArrayCollection();
		// a collection where removed GameObjects are placed, to avoid removing items 
		// to gameObjects while in the gameObjects collection while it is in a loop
		protected var removedGameObjects:ArrayCollection = new ArrayCollection();
		
		
		/* This function creates the singleton. Call it in the mxml file to start 
		 * up the game engine. 
		 */
		static public function get Instance():GameEngine
		{
			if ( instance == null )
				instance = new GameEngine();
			return instance;
		}
		
		/* The GameEngine constructor.
		 * 
		 * Note that this function does not instantiate the GameEngine singleton.
		 * A GameEngine reference variable must be declared in the mxml file and
		 * should properly instantiate the singleton with:
		 * gameEngineReference = GameEngine.Instance;
		 * 
		 * The commented code has not been removed as it serves for a reminder as how to
		 * use the various social AI classes.
		 * 
		 */
		public function GameEngine()
		{ 
			
			if ( instance != null )
				throw new Error( "Only one Singleton instance should be instantiated" ); 
				
			backBuffer = new BitmapData(FlexGlobals.topLevelApplication.width, FlexGlobals.topLevelApplication.height, false);
			
			this.lastFrame = new Date();
			this.frameCount = new int();
			
		}
	
		/*private function gameUpdate(): void 
		 *
		 *This function is the heart of the game engine. Analagous to the
		 *contents of a standard "main loop", this function has the following
		 *responsibilities:
		 * -get input from previous frame and perform the appropriate world updates
		 * -AI decision making over physical and social space
		 * -update world model
		 * -send updates to Flex SDK objects for rendering
		 */
		private function gameUpdate(evt:Event): void {
			
			// Calculate the time since the last frame
			var thisFrame:Date = new Date();
			var seconds:Number = (thisFrame.getTime() - lastFrame.getTime())/1000.0;
	    	lastFrame = thisFrame;
			
	    	//trace("frame: " + ++this.frameCount + " spf: " + seconds);
	    	//removeDeletedGameObjects();
	    	//insertNewGameObjects();
	    	//drawObjects();
		}

		/**********************************************************************
		 * Callback functions.
		 *********************************************************************/
		 
		/* public function onEnterFrame(): void
		 * 
		 * Registered as the callback for the enterFrame() event of the Application object.
		 * Gets called for every render cycle from the flash player.
		 * 
		 * Calls the game engine frame update function (gameUpdate(.)).  
		 */
		public function onEnterFrame(event:Event): void {
			this.gameUpdate(event);
			//trace(getTimer());
		}
		
		
		/**********************************************************************
		 * setter functions
		 *********************************************************************/
		public function setGraphicsContainer(container:Panel):void {
			this.graphicsContainer = container;
		}
		
		public function startup():void
		{
			lastFrame = new Date();			
		}
		
		
		public function shutdown():void
		{
			shutdownAll();
		}
		
		public function enterFrame():void
		{

		}
	
		
		/***
		 * The top level graphics rendering method.
		 * 
		 * Clears the back buffer, calls objects to draw themselves on that
		 * buffer, then flips the buffers.
		 */
	/*	protected function drawObjects():void
		{
			backBuffer.fillRect(backBuffer.rect, clearColor);
			
			// draw the objects
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) 
					gameObject.copyToBackBuffer(backBuffer);
			}
		}*/
		
		
	/*	public function addGameObject(gameObject:GameObject):void
		{
			newGameObjects.addItem(gameObject);
		}
		
		public function removeGameObject(gameObject:GameObject):void
		{
			removedGameObjects.addItem(gameObject);
		}*/
		
		
		/*** Shuts down the game engine.
		 * 
		 *TODO: cleanly shutdown the game AI system.
		 * 	Good place to gather stats and ship them off for collection.
		 * 
		 ***/
		protected function shutdownAll():void
		{
		/*	// don't dispose objects twice
			for each (var gameObject:GameObject in gameObjects)
			{
				var found:Boolean = false;
				for each (var removedObject:GameObject in removedGameObjects)
				{
					if (removedObject == gameObject)
					{
						found = true;
						break;
					}
				}
				
				if (!found)
					gameObject.shutdown();
			}*/
		}
		
		/***
		 * Inserts the game objects to be added to the active game objects
		 * vector.
		 *
		 * Should only be called privately by the game engine during the frame
		 * update.
		 */
		/*protected function insertNewGameObjects():void
		{
			for each (var gameObject:GameObject in newGameObjects)
			{
				for (var i:int = 0; i < gameObjects.length; ++i)
				{
					if (gameObjects.getItemAt(i).zOrder > gameObject.zOrder ||
						gameObjects.getItemAt(i).zOrder == -1)
						break;
				}

				gameObjects.addItemAt(gameObject, i);
			}
			
			newGameObjects.removeAll();
		}*/
		
		
		/***
		 * Removes the game objects to be deleted from the active game objects
		 * vector.
		 *
		 * Should only be called privately by the game engine during the frame
		 * update.
		 */
		/*protected function removeDeletedGameObjects():void
		{
			// insert the object acording to it's z position
			for each (var removedObject:GameObject in removedGameObjects)
			{
				var i:int = 0;
				for (i = 0; i < gameObjects.length; ++i)
				{
					if (gameObjects.getItemAt(i) == removedObject)
					{
						gameObjects.removeItemAt(i);
						break;
					}
				}
				
			}
			
			removedGameObjects.removeAll();
		}*/
	}
}