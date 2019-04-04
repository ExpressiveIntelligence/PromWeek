package PromWeek {
	import CiF.CiFSingleton;
	import CiF.Instantiation;
	import CiF.LineOfDialogue;
	import com.adobe.net.DynamicURLLoader;
	import com.furusystems.dconsole2.core.style.TextFormats;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.GradientType;
	import flash.display.SpreadMethod;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.ByteArray;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Timer;
	import mx.controls.Alert;
	import flash.net.FileReference;
	import mx.controls.Image;
	import mx.controls.Text;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import PromWeek.assets.ResourceLibrary;
	import PromWeek.assets.ResourceLibrary_mavePortraitData;
	import spark.components.Group;
	import spark.components.VGroup;
	import spark.primitives.Rect;
	
	import com.facebook.graph.Facebook;
	import com.facebook.graph.data.FacebookSession;
	import com.facebook.graph.net.FacebookRequest;
	
	
	import CiF.Debug;
	import CiF.SocialFactsDB;
	
	/**
	 * Provides an interface to the server-side backend.
	 */
	public class Backend {
		/**
		 * URL under which the different API functions can be found.
		 * Example: http://promweek.com/api
		 */
		
		private var baseURL:String
		
		private var facebookId:String = "";
		private var resourceLibrary:ResourceLibrary;
		
		private var doneCreatingHTMLFile:Boolean = false;
		private var doneCreatingJPGFile:Boolean = false;
		
		private var nameWithoutJpg:String;
		private var currentInstantiationDescription:String;
		private var marginForSGTranscripts:Number = 5;
		private var textPaddingTop:Number = 3;
		private var extraHeightOfBubbleNeeded:Number = .25; // gets added to total 'num Lines' 
		
		public function Backend(baseURL:String = "") {
			this.baseURL = baseURL;
			PromWeek.assets.ResourceLibrary.getInstance();
			// initialize facebook graph api connection
		}
		
		public function setFacebookId(facebookId:String):void {
			trace(facebookId);
			this.facebookId = facebookId;
		}
		
		public function getFacebookId():String {
			return this.facebookId;
		}
		
		/**
		 * Set API base url
		 * @param baseURL Base URL of the API, e.g. http://promweek.com/api
		 */
		public function setBaseURL(baseURL:String):void {
			this.baseURL = baseURL;
		}
		
		/**
		 * Wraps a function and calls it with 'null' as parameter.
		 *
		 * Can be used to create generic callbacks for the error
		 * event listeners of URLLoader.
		 *
		 * @param callback Function to wrap
		 */
		private function getErrorCallback(callback:Function):Function {
			return function(event:Event):void {
				callback(null);
			};
		}
		
		/**
		 * Fetch generic data about an user
		 *
		 * @param facebookId Facebook ID of user
		 * @param callback Function called on success and error. XML object with user info is passed on success, null otherwise. Expected signature: function(xml:XML):void
		 */
		public function getUserinfo(facebookId:Number, callback:Function):void {
			var errorCb:Function = this.getErrorCallback(callback);
			
			var successCb:Function = function(event:Event):void {
				var xml:XML = new XML(event.target.data);
				//This is a point where we now have the xml file and we can do anything we want with it.
				callback(xml);
			};
			
			var params:URLVariables = new URLVariables;
			params.UUID = facebookId;
			Utility.log(this, "getUserInfo: posting to userinfo.php. Params: " + params);
			this.request(this.baseURL + "/userinfo.php", URLRequestMethod.GET, params, successCb, errorCb);
		}
		
		/**
		 * Fetch which endings the user has seen.
		 *
		 * @param facebookId Facebook ID of user
		 * @param callback Function called on success and error. XML object with user info is passed on success, null otherwise. Expected signature: function(xml:XML):void
		 */
		public function getEndingsSeen(facebookId:String):void {
			//var errorCb:Function; // this.getErrorCallback(callback);
			var params:URLVariables = new URLVariables;
			params.UUID = facebookId;
			Utility.log(this, "getEndingsSeen: posting to userinfo.php. Params: " + params);
			Debug.debug(this, "****************************************getEndingsSeen()");
			Debug.debug(this, "****************************************Hello?!?");
			
			var statMan:StatisticsManager = StatisticsManager.getInstance();
			statMan.endingDataString = "Hasn't been set to anything yet!";
			
			Debug.debug(this, "base URL: " +this.baseURL);
			
			this.request(this.baseURL + "/getEndingsSeen.php", URLRequestMethod.GET, params, endingSeenSuccessCB, endingSeenErrorCB);
		}
		
		/**
		 * Fetch which goals the user has seen.
		 *
		 * @param facebookId Facebook ID of user
		 * @param callback Function called on success and error. XML object with user info is passed on success, null otherwise. Expected signature: function(xml:XML):void
		 */
		public function getGoalsSeen(facebookId:String):void {
			//var errorCb:Function; // this.getErrorCallback(callback);
			var params:URLVariables = new URLVariables;
			params.UUID = facebookId;
			params.UUID = facebookId;
			Utility.log(this, "getGoalsSeen: posting to userinfo.php. Params: " + params);
			Debug.debug(this, "****************************************getGoalsSeen()");
			Debug.debug(this, "****************************************Hello?!?");
			
			GameEngine.getInstance().loadLocalGameState();
			
			var statMan:StatisticsManager = StatisticsManager.getInstance();
			statMan.endingDataString = "Hasn't been set to anything yet!";
			
			this.request(this.baseURL + "/getGoalsSeen.php", URLRequestMethod.GET, params, goalSeenSuccessCB, goalSeenErrorCB);
		}
		
		
		
		public function getNewLoginID():void
		{
			//var errorCb:Function; // this.getErrorCallback(callback);
			var params:URLVariables = new URLVariables;
			Utility.log(this, "getNewLoginID:");
			
			this.request(this.baseURL + "/getNewLoginID.php", URLRequestMethod.GET, params, getNewLoginIDSuccessCB, getNewLoginIDErrorCB);
		}
		
		public function getNewLoginIDSuccessCB(e:Event):void
		{
			var xml:XML = new XML((e.target.data as String));
			
			this.setFacebookId(xml.loginID.toString());
			
			var so:SharedObject = SharedObject.getLocal("promWeek");
			so.data.promWeekLoginID = this.getFacebookId();
			so.flush();
			
			//var loader:URLLoader = URLLoader(event.target);
			//Debug.debug(this, "getNewLoginIDSuccessCB() I am getting here!  Here is what I think teh xml is? " + xml);
			Utility.log(this, "getNewLoginIDSuccessCB() I am getting here!  Here is what I think teh xml is? " + xml);
			//Utility.log(this, "getgoalsSeen() I am getting here!  Here is what I think teh data is? " + event.target.data);
			//var statisticsManager:StatisticsManager = StatisticsManager.getInstance();
			
			//This is a point where we now have the xml file and we can do anything we want with it.
			var gameEngine:GameEngine = GameEngine.getInstance();
			
			gameEngine.facebookLogin();
		}
		
		public function getNewLoginIDErrorCB(e:Event):void
		{
			Utility.log(this, "getNewLoginIDErrorCB(): An error has occurred here");
		}
		
		/**
		 * Gets a continuable level from the backend representing the player's most recent story/freeplay level played. Alternatively, if
		 * there was no 
		 * @param	e
		 */
		public function getContinueLevelTrace():void {
			var params:URLVariables = new URLVariables;
			params.CONTINUE = "continue";
			params.UUID = this.getFacebookId();
			this.request(this.baseURL + "/getContinueLevelTrace.php", URLRequestMethod.GET, params, continueLevelTraceSuccessCB, continueLevelTraceErrorCB);
		}
		
		public function getFreeplayState():void {
			var params:URLVariables = new URLVariables;
			params.FREEPLAY = "freeplay";
			params.UUID = this.getFacebookId();
			this.request(this.baseURL + "/getFreeplayState.php", URLRequestMethod.GET, params, freeplayStateSuccessCB, freeplayStateErrorCB);
		}
		
		/**
		 * Sends an update to the database that the user has seen a new ending!  This will help us out
		 * when trying to make it so that you can play the game across multiple sessions, and it will
		 * remember all the hard work you did!
		 * @param	endingName the name of the ending to add to the database.
		 */
		public function sendEndingSeen(storyLeadCharacter:String, endingName:String, callback:Function = null):void {
			var errorCb:Function;
			
			// send data to server
			if (callback != null)
				errorCb = this.getErrorCallback(callback);
			
			//Fill in the data inside of this nifty "params" thingy!
			var params:URLVariables = new URLVariables();
			params.UUID = this.getFacebookId();
			params.ENDING = storyLeadCharacter + "-" + endingName;
			
			Utility.log(this, "sendEndingSeen(): posting to receiveEndingSeen.php. Params: " + params);
			
			this.request(this.baseURL + "/receiveEndingSeen.php", URLRequestMethod.POST, params, null, errorCb);
		}

		/**
		 * Sends an update to the database that the user has seen a new goal in an ending!  This will help us out
		 * when trying to make it so that you can play the game across multiple sessions, and it will
		 * remember all the hard work you did!
		 * 
		 * Calling this function with the first argument as NULL will result in the goalName argument being sent to the
		 * server as is as a complete goal seen string: storyLeadCharacter-goalName
		 * 
		 * @param	goalName the name of the ending to add to the database.
		 */
		public function sendGoalSeen(storyLeadCharacter:String, goalName:String, callback:Function = null):void {
			var errorCb:Function;
			
			// send data to server
			if (callback != null)
				errorCb = this.getErrorCallback(callback);
			
			//Fill in the data inside of this nifty "params" thingy!
			var params:URLVariables = new URLVariables();
			params.UUID = this.getFacebookId();
			if(storyLeadCharacter) {
				params.GOAL = storyLeadCharacter + "-" + goalName;
			}else {
				params.GOAL = goalName;
			}
			GameEngine.getInstance().storeLocalGameState();
			
			Utility.log(this, "sendGoalSeen(): posting to receiveGoalSeen.php. Params: " + params);
			Debug.debug(this, "sendGoalSeen(): posting to receiveGoalSeen.php. Params: " + params);
			
			this.request(this.baseURL + "/receiveGoalSeen.php", URLRequestMethod.POST, params, null, errorCb);
		}
		
		/**
		 * Sends a bugtrace to be logged in the backend. This is to be called by the global uncaught error
		 * event handler.
		 */
		public function sendBugTrace(mouseEventsXML:XML = null, e:UncaughtErrorEvent = null):void {
			var cif:CiFSingleton = CiFSingleton.getInstance();
			var gameEngine:GameEngine = GameEngine.getInstance();
			var params:URLVariables = new URLVariables();
			var gameType:String = (gameEngine.currentLevel.isSandbox)?"freeplay":"story";
			var bugTraceXML:XML = new XML(<BugTrace cifTime={CiFSingleton.getInstance().time} UUID={this.getFacebookId()} />);
			//e.toString() e.text e.target e.currentTarget e.error  e.errorID (e.error as Error).errorID (e.error as Error)..message (e.error as Error).name (e.error as Error).getStackTrace()
			var err:Error = (e.error as Error);
			bugTraceXML.appendChild(<UncaughtErrorEvent text={e.text} target={e.target} currentTarget={e.currentTarget} error={e.error} errorID={e.errorID} type={e.type} />);
			bugTraceXML.appendChild(<Error errorID={err.errorID} message={err.message} name={err.name} />);
			bugTraceXML.appendChild(mouseEventsXML);
			bugTraceXML.appendChild(this.generateLevelTraceXML(cif.sfdb, gameEngine.levelStartedTime, cif.time, gameEngine.currentLevel.title, gameEngine.currentStory.storyLeadCharacter, gameType));
			
			if (PromWeek.GameEngine.getInstance().hudGroup.debugInfo) {
				params.debugInfo = PromWeek.GameEngine.getInstance().hudGroup.debugInfo;
			}
			params.UUID = this.getFacebookId();
			params.data = bugTraceXML;
			this.request(this.baseURL + "/receiveBugTrace.php", URLRequestMethod.POST, params, null, null);
		}
		
		/**
		 * Takes the newly-fulfilled goals (as determined by the EndingsManager) and sends them off to the 
		 * backend for storage.
		 * @param	goalsSeen	The ToDoItems newly fulfilled by the player.
		 */
		public function sendNewGoalsSeen(story:Story, goalsSeen:Vector.<ToDoItem>):void {
			if (goalsSeen.length == 0)
				return;
			Debug.debug(this, "sendNewGoalsSeen() sending " + goalsSeen.length + " goals to the backend.");
			Utility.log(this, "sendNewGoalsSeen() sending " + goalsSeen.length + " goals to the backend.");
			for each(var item:ToDoItem in goalsSeen) {
				this.sendGoalSeen(story.storyLeadCharacter, item.name, null);
			}
		}
		/**
		 * Given an SFDB and some game state, this function generates a level trace in XML.
		 * @param sfdb SocialFactsDB with the SFDBContexts that happened in this level
		 * @param startTime game time this level started
		 * @param endTime game time this level ended
		 * @param levelName name of the active level
		 * @param storyName name of the current story. If the game is in freeplay mode, the value should be "freeplay"
		 * @param type "endOfStory", "endOfLevel", "freeplay", or "exit" depending on what the user did to generated the trace.
		 * @return
		 */
		public function generateLevelTraceXML(sfdb:CiF.SocialFactsDB, startTime:Number, endTime:Number, levelName:String, storyName:String, type:String):XML {
			var levelTrace:XML = <LevelTraces/>;
			
			levelTrace.@startTime = startTime;
			levelTrace.@endTime = endTime;
			levelTrace.@name = levelName;
			levelTrace.@storyName = (storyName == "")?"freeplay":storyName;
			levelTrace.@juice = JuicePointManager.getInstance().currentJuicePoints;
			levelTrace.@type = type;
			
			var sfdbXml:XML = <SFDB/>;
			
			for (var i:Number = 0; i < sfdb.contexts.length; i++) {
				//if (sfdb.contexts[i].getTime() >= startTime) {  //for this level only
 				if (sfdb.contexts[i].getTime() >= 0) { //for the entire story
					sfdbXml.appendChild(sfdb.contexts[i].toXML());
				}
			}
			
			levelTrace.appendChild(sfdbXml);
			return levelTrace;
		}
		
		/**
		 * Submit tracing information about a finished level
		 *
		 * @param sfdb SocialFactsDB with the SFDBContexts that happened in this level
		 * @param startTime game time this level started
		 * @param endTime game time this level ended
		 * @param levelName name of the active level
		 * @param callback Function called in case of errors. 'null' will be passed as only parameter.
		 */
		public function sendLevelTrace(sfdb:CiF.SocialFactsDB, startTime:Number, endTime:Number, levelName:String, storyName:String, continuable:Boolean, type:String, callback:Function = null):void {
			var errorCb:Function;
			var levelTrace:XML = this.generateLevelTraceXML(sfdb, startTime, endTime, levelName, storyName, type);
			
			trace(levelTrace.toXMLString());
			
			// send data to server
			if (callback != null)
				errorCb = this.getErrorCallback(callback);
			
			var params:URLVariables = new URLVariables();
			params.UUID = this.getFacebookId();
			params.leveltracedata = levelTrace.toXMLString();
			params.TURNS = endTime;
			params.STORY = (storyName == "")?"freeplay":storyName;
			params.LEVEL = levelName;
			params.CONTINUABLE = continuable;
			
			
			trace(params.toString());
			
			trace(this.baseURL + "/receiveLevelTrace.php");
			Utility.log(this, "sendLevelTrace(): posting to receiveLevelTrace.php. Params: " + params);
			this.request(this.baseURL + "/receiveLevelTrace.php", URLRequestMethod.POST, params, null, errorCb);
		}
		
		/**
		 * Unlock an achievement
		 *
		 * @param facebookId Facebook ID of user
		 * @param achievementId ID of the achievement to unlock
		 * @param callback Function called in case of errors. 'null' will be passed as only parameter.
		 */
		public function unlockAchievement(facebookId:String, achievementId:Number, callback:Function = null):void {
			var errorCb:Function;
			if (callback != null)
				errorCb = this.getErrorCallback(callback);
			
			var params:URLVariables = new URLVariables();
			params.AID = achievementId;
			params.UUID = facebookId;
			
			this.request(this.baseURL + "/unlockAchievement.php", URLRequestMethod.POST, params, null, errorCb);
		}
		
		/**
		 * Get list of all achievements including status for a user
		 *
		 * @param facebookId Facebook ID of user
		 * @param callback Function called on success and error. XML object with achievements is passed on success, null otherwise. Expected signature: function(xml:XML):void
		 */
		public function getAchievements(facebookId:Number, callback:Function):void {
			var errorCb:Function = this.getErrorCallback(callback);
			var successCb:Function = function(event:Event):void {
				var xml:XML = new XML(event.target.data);
				callback(xml);
			}
			
			var params:URLVariables = new URLVariables();
			params.UUID = facebookId;
			Utility.log(this, "getAchievements: posting to getAcheivements.php. Params: " + params);
			this.request(this.baseURL + "/getAchievements.php", URLRequestMethod.GET, params, successCb, errorCb);
		}
		
		public function newLevel():void {
			this.incrementCounters(true, false);
		}
		
		public function gameLoaded():void {
			this.incrementCounters(false, true);
		}
		
		/**
		 * Encodes the most recent social game transcript that the user just saw
		 * into an image using bitmaps and JPGEncoder.  It will then call a php
		 * script to attempt to save the programmatically created image to the 
		 * server.
		 */
		public function encodeSgTranscriptToImage(instantatiaon:Instantiation, performanceRealizationString:String, initName:String, respondName:String, otherName:String):String {
			var w:int = 315;
			var h:int = 600;
			var dialogueBubbleWidth:int = 220; // this will help us make intelligent predictions!
			var fontType:String = "Arial";
			var fontSize:Number = 16;
			
			currentInstantiationDescription = performanceRealizationString;
			Debug.debug(this, "width and height set!");
			
			var tf:TextField = new TextField();
			tf.width = 300;
			tf.height = 400;
			tf.wordWrap = true;
			
			if (resourceLibrary == null) {
					Debug.debug(this, "the resource library was null for some reason?")
					resourceLibrary = PromWeek.assets.ResourceLibrary.getInstance();
			}
			
			var currentLineToAdd:String = "";
			var normalPortraitScalingFactor:Number = 0.5;
			var phoebePortraitScalingFactor:Number = (200 * normalPortraitScalingFactor) / 687; // phoebe's portrait is al messed up...
			var portraitScalingFactor:Number = 1;
			//hudGroup.initiatorDiablogueBubble.text = LineOfDialogue.preprocessLine(line.initiatorLine);
			
		
			Debug.debug(this, "text field created");
			
			//OK, I need to actually compute what I want the height to be.
			//SIGH.
			//OK, the height is: PRS + portraits + nameplates + dialogue.
			
			//PERFORMANCE REALIZATION STRING
			var textFormat:TextFormat = new TextFormat();
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = 16;
			
			var prsText:TextField = new TextField();
			prsText.width = w;
			prsText.wordWrap = true;
			prsText.text = performanceRealizationString;
			prsText.setTextFormat(textFormat);
			Debug.debug(this, "performance realization string number of lines is: " + prsText.numLines);
			
			//calculate how much space to provide based on prsText.numLines
			var paddingRequired:int = 15 * prsText.numLines + 15;
			var currentVerticalPositioning:int = paddingRequired;
			
			//quickly load in a portrait just for testing purposes...
			var imageFromRL:Class = resourceLibrary.backgrounds["blankpaperbig"];
			var imageBitmap:Bitmap = new imageFromRL;
			
			//ok, er, gonna do a quick replacement...
			imageFromRL = resourceLibrary.portraits[initName.toLowerCase()];
			imageBitmap = new imageFromRL;
			
			var necessaryHeight:Number = currentVerticalPositioning;
			if (initName.toLowerCase() == "phoebe")
				portraitScalingFactor = phoebePortraitScalingFactor;
			else
				portraitScalingFactor = normalPortraitScalingFactor;
			var tempNameplateY:Number = currentVerticalPositioning + imageBitmap.height * portraitScalingFactor + 5;
			necessaryHeight += tempNameplateY + 10;
			Debug.debug(this, "necessary height was deemed to be BEFORE computation: " + necessaryHeight);
			
			necessaryHeight += getHeightNeededBasedOnDialogue(instantatiaon, dialogueBubbleWidth,fontSize,fontType);
			
			Debug.debug(this, "necessary height was deemed to be AFTER computation: " + necessaryHeight);
			
			//ok, now load in the resource library thing again.
			imageFromRL = resourceLibrary.backgrounds["sgTranscriptBackground"];
			imageBitmap = new imageFromRL;
			
			var bitmapData:BitmapData = new BitmapData( w, necessaryHeight, true, 0xA0FB74  );
			
			//BACKGROUND -- the nice papery background.
			//In real life we might want to figure out just how big of a thing this needs to be.
			//And real life starts today!
			var sprite:Sprite = new Sprite();
			sprite.graphics.clear();
			
			var backgroundYScale:Number = necessaryHeight / 2000; // 2000 is the height of the background strip -- this should get us the scale factor.

			//This will help us size the background to the appropriate height!
			//BACKGROUND STRIP SCALING
			var transformationMatrix:Matrix = new Matrix();
			transformationMatrix.a = 158 // x scale // the normal width is about 2 -- scale it so that it is about 315 
			transformationMatrix.b = 0  // y skew
			transformationMatrix.c = 0  // x skew
			transformationMatrix.d = backgroundYScale // y scale
			transformationMatrix.tx = 0 // x translate
			transformationMatrix.ty = 0; // y translate
			
			
			sprite.addChild(imageBitmap);
			bitmapData.draw(sprite, transformationMatrix, null, null, null, true);
			sprite.removeChild(imageBitmap);
			
			//add the prs to the thing.
			bitmapData.draw(prsText, null, null, null, null, true);

			if (initName.toLowerCase() == "phoebe")
				portraitScalingFactor = phoebePortraitScalingFactor;
			else
				portraitScalingFactor = normalPortraitScalingFactor;
			
			//This will help us to position things nicely!
			//INITIATOR PORTRAIT MATRIX
			transformationMatrix = new Matrix();
			transformationMatrix.a = portraitScalingFactor // x scale
			transformationMatrix.b = 0  // y skew
			transformationMatrix.c = 0  // x skew
			transformationMatrix.d = portraitScalingFactor // y scale
			transformationMatrix.tx = 0 // x translate
			transformationMatrix.ty = currentVerticalPositioning; // y translate
			
			//DRAW THE INITIATOR PORTRAIT
			sprite.graphics.clear();
			
			Debug.debug(this, "going to load in the gradient test...");
			imageFromRL = resourceLibrary.portraits[initName.toLowerCase()];
			//imageFromRL = resourceLibrary.backgrounds["bluebubble"];
			Debug.debug(this, "just loaded in the gradient test...");
			
			Debug.debug(this, "about to set image bitmap equal to this new thing");
			imageBitmap = new imageFromRL;
			
			Debug.debug(this, "height of image initiator portrait is: " + imageBitmap.height);
			
			Debug.debug(this, "about to add child to the sprite");
			sprite.addChild(imageBitmap);
			
			Debug.debug(this, "about to draw");
			bitmapData.draw(sprite, transformationMatrix, null, null, null, true);
			
			Debug.debug(this, "about to remove the sprite");
			sprite.removeChild(imageBitmap);
			
			
			if (initName.toLowerCase() == "phoebe")
				portraitScalingFactor = phoebePortraitScalingFactor;
			else
				portraitScalingFactor = normalPortraitScalingFactor;
			
			//DRAW a rectangle that has the initiator's name!
			//Maybe position things differently if there is an other?
			var initiatorNameX:int = 5;
			var initiatorNameY:int = currentVerticalPositioning + imageBitmap.height * portraitScalingFactor + 5
			Debug.debug(this, "INIIATOR NAME Y (which should be same as responder name y and everything): " + initiatorNameY);
			var initiatorNameWidth:int = 90;
			var initiatorNameHeight:int = 30;
			
			//INITIATOR NAMEPLATE MATRIX
			transformationMatrix = new Matrix();
			transformationMatrix.a = 1 // x scale
			transformationMatrix.b = 0  // y skew
			transformationMatrix.c = 0  // x skew
			transformationMatrix.d = 1 // y scale
			transformationMatrix.tx = initiatorNameX; // x translate
			transformationMatrix.ty = initiatorNameY; // y translate
			
			//First draw a cool rectangle thing maybe?
			sprite.graphics.clear();
			var fillType:String = GradientType.LINEAR;
			
			var colors:Array = new Array();
			//colors = [0x000000, 0x000000, 0x77e84c, 0xd3fadb];
			colors = [0x000000, 0x77e84c, 0xd3fadb, 0xFFFFFF];
			//[0x000000, 0x00FF00, 0x488214, 0xFFFFFF];
			//var colors:Array = [0xFF0000, 0x0000FF];
			var alphas:Array = [1, 1, 1, 1];
			var ratios:Array = [0, 80, 160, 255];
			var matr:Matrix = new Matrix();
			//matr.createGradientBox(20, 20, 0, 0, 0);
			matr.createGradientBox(initiatorNameWidth + 100, initiatorNameHeight + 100, Math.PI / 2, 0, 70);
			var spreadMethod:String = SpreadMethod.PAD;
			sprite.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			sprite.graphics.drawRect(initiatorNameX,initiatorNameY,initiatorNameWidth,initiatorNameHeight);
			bitmapData.draw(sprite, null, null, null, null, true);
			
			//and NOW draw the text!
			sprite.graphics.clear();
			var initNameTF:TextField = new TextField();
			var initNameFormat:TextFormat = new TextFormat();
			initNameFormat.size = 20;
			initNameFormat.align = TextFormatAlign.CENTER;
			
			
			initNameTF.width = initiatorNameWidth;
			initNameTF.text = upperCase(initName);
			initNameTF.setTextFormat(initNameFormat);
			
			bitmapData.draw(initNameTF, transformationMatrix, null, null, null, true);
			
			
			
			//DRAW THE RESPONDER PORTRAIT AND NAME
			sprite.graphics.clear();
			
			imageFromRL = resourceLibrary.portraits[respondName.toLowerCase()];
			//imageFromRL = resourceLibrary.backgrounds["greenbubble"];
			Debug.debug(this, "this is the responder's name in lower case: " + respondName.toLowerCase());
			imageBitmap = new imageFromRL;
			
			var responderPortraitX:int = 210;
			
			if (respondName.toLowerCase() == "phoebe")
				portraitScalingFactor = phoebePortraitScalingFactor;
			else
				portraitScalingFactor = normalPortraitScalingFactor;
			
			//RESPONDER PORTRAIT MATRIX
			transformationMatrix.a = portraitScalingFactor // x scale
			transformationMatrix.b = 0  // y skew
			transformationMatrix.c = 0  // x skew
			transformationMatrix.d = portraitScalingFactor // y scale
			transformationMatrix.tx = responderPortraitX // x translate
			transformationMatrix.ty = currentVerticalPositioning; // y translate
			
			sprite.addChild(imageBitmap);
			bitmapData.draw(sprite, transformationMatrix, null, null, null, true);
			sprite.removeChild(imageBitmap);
			
			//DRAW a rectangle that has the RESPONDER's name!
			//Maybe position things differently if there is an other?
			var  responderNameX:int = responderPortraitX + 5;
			var responderNameY:int = currentVerticalPositioning + imageBitmap.height * portraitScalingFactor + 5;
			Debug.debug(this, "*********ok, fine I'll check, this is the responder name y but should be the same as everything else: " + responderNameY);
			
			Debug.debug(this, "responder portrait height is: " + imageBitmap.height);
			
			
			var responderNameWidth:int = 90;
			var responderNameHeight:int = 30;
			
			//RESPONDER NAMEPLATE MATRIX
			transformationMatrix = new Matrix();
			transformationMatrix.a = 1 // x scale
			transformationMatrix.b = 0  // y skew
			transformationMatrix.c = 0  // x skew
			transformationMatrix.d = 1 // y scale
			transformationMatrix.tx = responderNameX; // x translate
			transformationMatrix.ty = responderNameY; // y translate
			
			//First draw a cool rectangle thing maybe?
			sprite.graphics.clear();
			sprite.graphics.endFill();
			 fillType = GradientType.LINEAR;
			// colors = [0x00C957, 0x6EFF70];
			// colors = [0xFF0000, 0x0000FF];
			//OK, this is WEIRD -- BUT use the last two colors as your gradiant colors.
			//The other colors don't show up... this is all based on things being 'perfectly' aligned
			//after playing with a lot of magic numbers.  
			 //colors = [0x000000, 0xFF0000, 0x0000FF, 0xFFFFFF];
			 //colors = [0x000000, 0xFF0000, 0x488214, 0xFFFFFF];
			 colors = [0x000000, 0x0198E1, 0xB0E2FF, 0xFFFFFF];
			 alphas = [1, 1, 1, 1];
			 ratios = [0, 80, 160, 255];
			 matr = new Matrix();
			//matr.createGradientBox(20, 20, 0, 0, 0);
			matr.createGradientBox(responderNameWidth + 100, responderNameHeight + 100, Math.PI / 2, 0, 70);
			//matr.createGradientBox(responderNameWidth, responderNameHeight, 0, responderNameWidth + 15, 0);
			spreadMethod = SpreadMethod.PAD
			
			sprite.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			sprite.graphics.drawRect(responderNameX,responderNameY,responderNameWidth,responderNameHeight);
			bitmapData.draw(sprite, null, null, null, null, true);
			
			//and NOW draw the text!
			sprite.graphics.clear();
			var responderNameTF:TextField = new TextField();
			var responderNameFormat:TextFormat = new TextFormat();
			responderNameFormat.size = 20;
			responderNameFormat.align = TextFormatAlign.CENTER;
			
			responderNameTF.width = responderNameWidth;
			responderNameTF.text = upperCase(respondName);
			responderNameTF.setTextFormat(responderNameFormat);
			
			bitmapData.draw(responderNameTF, transformationMatrix, null, null, null, true);
			
			
			//Let's do the 'OTHER' now!!
			if (otherName != "") {
				//DRAW THE OTHER PORTRAIT AND NAME
				sprite.graphics.clear();
				
				imageFromRL = resourceLibrary.portraits[otherName.toLowerCase()];
				//imageFromRL = resourceLibrary.backgrounds["greenbubble"];
				Debug.debug(this, "this is the other's name in lower case: " + otherName.toLowerCase());
				imageBitmap = new imageFromRL;
				
				var otherPortraitX:int = 105;
				
				if (otherName.toLowerCase() == "phoebe")
					portraitScalingFactor = phoebePortraitScalingFactor;
				else
					portraitScalingFactor = normalPortraitScalingFactor;
				
				//OTHER PORTRAIT MATRIX
				transformationMatrix.a = portraitScalingFactor // x scale
				transformationMatrix.b = 0  // y skew
				transformationMatrix.c = 0  // x skew
				transformationMatrix.d = portraitScalingFactor // y scale
				transformationMatrix.tx = otherPortraitX // x translate
				transformationMatrix.ty = currentVerticalPositioning; // y translate
				
				sprite.addChild(imageBitmap);
				bitmapData.draw(sprite, transformationMatrix, null, null, null, true);
				sprite.removeChild(imageBitmap);
				
				//DRAW a rectangle that has the OTHER's name!
				//Maybe position things differently if there is an other?
				var  otherNameX:int = otherPortraitX + 5;
				var otherNameY:int = currentVerticalPositioning + imageBitmap.height * portraitScalingFactor + 5;
				
				Debug.debug(this, "other portrait height is: " + imageBitmap.height);
				
				
				var otherNameWidth:int = 90;
				var otherNameHeight:int = 30;
				
				//OTHER NAMEPLATE MATRIX
				transformationMatrix = new Matrix();
				transformationMatrix.a = 1 // x scale
				transformationMatrix.b = 0  // y skew
				transformationMatrix.c = 0  // x skew
				transformationMatrix.d = 1 // y scale
				transformationMatrix.tx = otherNameX; // x translate
				transformationMatrix.ty = otherNameY; // y translate
				
				//First draw a cool rectangle thing maybe?
				sprite.graphics.clear();
				sprite.graphics.endFill();
				 fillType = GradientType.LINEAR;
				// colors = [0x00C957, 0x6EFF70];
				// colors = [0xFF0000, 0x0000FF];
				//OK, this is WEIRD -- BUT use the last two colors as your gradiant colors.
				//The other colors don't show up... this is all based on things being 'perfectly' aligned
				//after playing with a lot of magic numbers.  
				 //colors = [0x000000, 0xFF0000, 0x0000FF, 0xFFFFFF];
				 //colors = [0x000000, 0xFF0000, 0x488214, 0xFFFFFF];
				 //colors = [0x000000, 0xFF0000, 0xFF0000, 0xFFFFFF];
				 colors = [0x000000, 0xC0C0C0, 0xFFFFFF, 0xFFFFFF];
				 alphas = [1, 1, 1, 1];
				 ratios = [0, 80, 160, 255];
				 matr = new Matrix();
				//matr.createGradientBox(20, 20, 0, 0, 0);
				matr.createGradientBox(otherNameWidth + 100, otherNameHeight + 100, Math.PI / 2, 0, 70);
				//matr.createGradientBox(responderNameWidth, responderNameHeight, 0, responderNameWidth + 15, 0);
				spreadMethod = SpreadMethod.PAD
				
				sprite.graphics.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
				sprite.graphics.drawRect(otherNameX,otherNameY,otherNameWidth,otherNameHeight);
				bitmapData.draw(sprite, null, null, null, null, true);
				
				//and NOW draw the text!
				sprite.graphics.clear();
				var otherNameTF:TextField = new TextField();
				var otherNameFormat:TextFormat = new TextFormat();
				otherNameFormat.size = 20;
				otherNameFormat.align = TextFormatAlign.CENTER;
				
				otherNameTF.width = otherNameWidth;
				otherNameTF.text = upperCase(otherName);
				otherNameTF.setTextFormat(otherNameFormat);
				
				bitmapData.draw(otherNameTF, transformationMatrix, null, null, null, true);
			}
			
			
			//OK, once we've gotten to this point, we are ready to actually start
			//writing down the dialogue that is part of the instantiation.
			
			// whoo boy!
			Debug.debug(this, "ok... so before we do the plus equals, this is the value of current vertical positioning: " + currentVerticalPositioning);
			currentVerticalPositioning += responderNameY + 10;
			
			Debug.debug(this, "THIS IS VERTICAL POSITIONING DONE THE NORMAL WAY (where text should be starting): " + currentVerticalPositioning); 
			
			
			var initLineTextField:TextField = new TextField();
			var initLineTextFormat:TextFormat = new TextFormat();
			var respondLineTextField:TextField = new TextField();
			var respondLineTextFormat:TextFormat = new TextFormat();
			var otherLineTextField:TextField = new TextField();
			var otherLineTextFormat:TextFormat = new TextFormat();
			
			var initiatorDialogueX:int = 5;
			var responderDialogueX:int = 75;
			var otherDialogueX:int = 40;
			
			
			var amountToYScaleBy:int = 1;
			
			var initiatorVerticalPositioning:int = currentVerticalPositioning;
			var responderVerticalPositioning:int = currentVerticalPositioning;
			
			var conversationBackAndForthSpacingPerLine:int = 8;
			
			for each(var line:LineOfDialogue in instantatiaon.lines) {
				currentLineToAdd = "";
				initLineTextField.text = "";
				respondLineTextField.text = "";
				otherLineTextField.text = "";
				
				if (line.initiatorLine != "") { //Add an Initiator Line!!!!
					currentLineToAdd = LineOfDialogue.preprocessLine(line.initiatorLine);
					Debug.debug(this, "adding the current line: " + currentLineToAdd);
					
					//Add an initiator dialogue bubble!
					sprite.graphics.clear();
					imageFromRL = resourceLibrary.backgrounds["greenbubble"];
					imageBitmap = new imageFromRL;
					initLineTextField.text = "";
					initLineTextField.width = dialogueBubbleWidth;
					initLineTextField.height = 500; // Let's just make it super HUGE!!!!!!!!! fun!!!!!!
					initLineTextField.wordWrap = true;
					initLineTextField.multiline = true;
					initLineTextField.text = currentLineToAdd;
					Debug.debug(this, "****just actually added the text to the text field, this is the height: " + initLineTextField.height);
					initLineTextFormat.size = fontSize;
					initLineTextFormat.font = fontType;
					
					initLineTextFormat.rightMargin = marginForSGTranscripts;
					initLineTextFormat.leftMargin = marginForSGTranscripts;
					
					initLineTextField.setTextFormat(initLineTextFormat);
					Debug.debug(this, "****changed the text format associated with this text field.  Did height change?: " + initLineTextField.height);
					Debug.debug(this, "number of lines this line takes up in a text field is: " + initLineTextField.numLines);
					var tempNumLines:Number = initLineTextField.numLines;
					amountToYScaleBy = Math.ceil (tempNumLines / 2.0); // 1/2 = 1, 2/2 = 1, 3/2 = 2, 4/2 = 2, 5/2 = 3, etc.
					Debug.debug(this, "the 'amount to YScaleBy is: " + amountToYScaleBy);
					
					//matrix for the initiator dialogue bubble.
					//The size of this will depend in (large) part of the amount of
					//text (that we know lives inside of 'initLineTextField')
					transformationMatrix = new Matrix();
					transformationMatrix.a = 1.5 // x scale
					transformationMatrix.b = 0  // y skew
					transformationMatrix.c = 0  // x skew
					//transformationMatrix.d = .5 * amountToYScaleBy; // y scale -- needs to adjust based on number of lines (more lines == bigger)
					transformationMatrix.d = .3 * (tempNumLines+extraHeightOfBubbleNeeded); // y scale -- needs to adjust based on number of lines (more lines == bigger)
					transformationMatrix.tx = initiatorDialogueX; // x translate
					transformationMatrix.ty = currentVerticalPositioning; // y translate
					
					//Add the dialogue bubble.
					sprite.addChild(imageBitmap);
					bitmapData.draw(sprite, transformationMatrix, null, null, null, true);
					sprite.removeChild(imageBitmap);
					
					//Now deal with Initiator Text
					//initLineTextField.width = dialogueBubbleWidth;
					//initLineTextField.wordWrap = true;
					
					
					//Initiator text matrix
					transformationMatrix = new Matrix();
					transformationMatrix.a = 1 // x scale
					transformationMatrix.b = 0  // y skew
					transformationMatrix.c = 0  // x skew
					transformationMatrix.d = 1 // y scale
					transformationMatrix.tx = initiatorDialogueX; // x translate
					transformationMatrix.ty = currentVerticalPositioning + textPaddingTop; // y translate
					
					//Draw the actual initiator text itself.
					bitmapData.draw(initLineTextField, transformationMatrix, null, null, null, true);
					
					//Increase current vertical positioning, by a function of the number of lines in the text box.
					//PROBABLY WANT SEPARATE POSITIONINGS FOR INIT AND RESPOND AND OTHER HERE
					//so that there can be some nice looking overlap, maybe.
					//initiatorVerticalPositioning += (tempNumLines) * 20 + 5; // 20 pixels per line, maybe?
					
					currentVerticalPositioning += verticalPositioningForDialogue(tempNumLines+extraHeightOfBubbleNeeded);
					
					//responder vertical positioning needs to increase too, but by not as much
					//responderVerticalPositioning += conversationBackAndForthSpacingPerLine * tempNumLines
					
				}
				if (line.responderLine != "") {
					currentLineToAdd = LineOfDialogue.preprocessLine(line.responderLine);
					Debug.debug(this, "adding the current line: " + currentLineToAdd);
					
					//Add a responder dialogue bubble!
					sprite.graphics.clear();
					imageFromRL = resourceLibrary.backgrounds["bluebubble"];
					imageBitmap = new imageFromRL;
					respondLineTextField.text = "";
					respondLineTextField.width = dialogueBubbleWidth;
					respondLineTextField.height = 500;
					respondLineTextField.wordWrap = true;
					//respondLineTextField.multiline = true;
					respondLineTextField.text = currentLineToAdd;
					respondLineTextFormat.size = fontSize;
					respondLineTextFormat.font = fontType;
					respondLineTextFormat.leftMargin = marginForSGTranscripts;
					respondLineTextFormat.rightMargin = marginForSGTranscripts;
					respondLineTextField.setTextFormat(respondLineTextFormat);
					
					Debug.debug(this, "number of lines this line takes up in a text field is: " + respondLineTextField.numLines);
					tempNumLines = respondLineTextField.numLines;
					amountToYScaleBy = Math.ceil (tempNumLines / 2.0); // 1/2 = 1, 2/2 = 1, 3/2 = 2, 4/2 = 2, 5/2 = 3, etc.
					Debug.debug(this, "the 'amount to YScaleBy is: " + amountToYScaleBy);
					
					//matrix for the RESPONDER dialogue bubble.
					//The size of this will depend in (large) part of the amount of
					//text (that we know lives inside of 'initLineTextField')
					transformationMatrix = new Matrix();
					transformationMatrix.a = 1.5 // x scale
					transformationMatrix.b = 0  // y skew
					transformationMatrix.c = 0  // x skew
					//transformationMatrix.d = .5 * amountToYScaleBy; // y scale -- needs to adjust based on number of lines (more lines == bigger)
					transformationMatrix.d = .3 * (tempNumLines+extraHeightOfBubbleNeeded); // y scale -- needs to adjust based on number of lines (more lines == bigger)
					transformationMatrix.tx = responderDialogueX; // x translate
					transformationMatrix.ty = currentVerticalPositioning; // y translate
					
					//Add the dialogue bubble.
					sprite.addChild(imageBitmap);
					bitmapData.draw(sprite, transformationMatrix, null, null, null, true);
					sprite.removeChild(imageBitmap);
					
					//Now deal with Responder Text
					//respondLineTextField.width = dialogueBubbleWidth;
					//respondLineTextField.wordWrap = true;
					
					
					//Responder text matrix
					transformationMatrix = new Matrix();
					transformationMatrix.a = 1 // x scale
					transformationMatrix.b = 0  // y skew
					transformationMatrix.c = 0  // x skew
					transformationMatrix.d = 1 // y scale
					transformationMatrix.tx = responderDialogueX; // x translate
					transformationMatrix.ty = currentVerticalPositioning + textPaddingTop; // y translate
					
					//Draw the actual responder text itself.
					bitmapData.draw(respondLineTextField, transformationMatrix, null, null, null, true);
					
					//Increase current vertical positioning, by a function of the number of lines in the text box.
					//PROBABLY WANT SEPARATE POSITIONINGS FOR INIT AND RESPOND AND OTHER HERE
					//so that there can be some nice looking overlap, maybe.
					//responderVerticalPositioning += (tempNumLines) * 20 + 5; // 20 pixels per line, maybe?
					
					currentVerticalPositioning += verticalPositioningForDialogue(tempNumLines+extraHeightOfBubbleNeeded);
					
					//Need to adjust the initiator positioning as well
					//initiatorVerticalPositioning += conversationBackAndForthSpacingPerLine * tempNumLines;
					
				}
				if (line.otherLine != "") {
					currentLineToAdd += LineOfDialogue.preprocessLine(line.otherLine);
					
					//Add an other dialogue bubble!
					sprite.graphics.clear();
					imageFromRL = resourceLibrary.backgrounds["silverbubble"];
					imageBitmap = new imageFromRL;
					otherLineTextField.text = "";
					otherLineTextField.width = dialogueBubbleWidth;
					otherLineTextField.height = 500;
					otherLineTextField.wordWrap = true;
					//respondLineTextField.multiline = true;
					otherLineTextField.text = currentLineToAdd;
					otherLineTextFormat.size = fontSize;
					otherLineTextFormat.font = fontType;
					otherLineTextFormat.leftMargin = marginForSGTranscripts;
					otherLineTextFormat.rightMargin = marginForSGTranscripts;
					otherLineTextField.setTextFormat(otherLineTextFormat);
					
					Debug.debug(this, "number of lines this line takes up in a text field is: " + otherLineTextField.numLines);
					tempNumLines = otherLineTextField.numLines;
					amountToYScaleBy = Math.ceil (tempNumLines / 2.0); // 1/2 = 1, 2/2 = 1, 3/2 = 2, 4/2 = 2, 5/2 = 3, etc.
					Debug.debug(this, "the 'amount to YScaleBy is: " + amountToYScaleBy);
					
					//matrix for the RESPONDER dialogue bubble.
					//The size of this will depend in (large) part of the amount of
					//text (that we know lives inside of 'initLineTextField')
					transformationMatrix = new Matrix();
					transformationMatrix.a = 1.5 // x scale
					transformationMatrix.b = 0  // y skew
					transformationMatrix.c = 0  // x skew
					//transformationMatrix.d = .5 * amountToYScaleBy; // y scale -- needs to adjust based on number of lines (more lines == bigger)
					transformationMatrix.d = .3 * (tempNumLines + extraHeightOfBubbleNeeded); // y scale -- needs to adjust based on number of lines (more lines == bigger)
					transformationMatrix.tx = otherDialogueX; // x translate
					transformationMatrix.ty = currentVerticalPositioning; // y translate
					
					//Add the dialogue bubble.
					sprite.addChild(imageBitmap);
					bitmapData.draw(sprite, transformationMatrix, null, null, null, true);
					sprite.removeChild(imageBitmap);
					
					//Now deal with Responder Text
					//respondLineTextField.width = dialogueBubbleWidth;
					//respondLineTextField.wordWrap = true;
					
					
					//Responder text matrix
					transformationMatrix = new Matrix();
					transformationMatrix.a = 1 // x scale
					transformationMatrix.b = 0  // y skew
					transformationMatrix.c = 0  // x skew
					transformationMatrix.d = 1 // y scale
					transformationMatrix.tx = otherDialogueX; // x translate
					transformationMatrix.ty = currentVerticalPositioning + textPaddingTop; // y translate
					
					//Draw the actual responder text itself.
					bitmapData.draw(otherLineTextField, transformationMatrix, null, null, null, true);
					
					//Increase current vertical positioning, by a function of the number of lines in the text box.
					//PROBABLY WANT SEPARATE POSITIONINGS FOR INIT AND RESPOND AND OTHER HERE
					//so that there can be some nice looking overlap, maybe.
					//responderVerticalPositioning += (tempNumLines) * 20 + 5; // 20 pixels per line, maybe?
					
					currentVerticalPositioning += verticalPositioningForDialogue(tempNumLines+extraHeightOfBubbleNeeded);
					
					//Need to adjust the initiator positioning as well
					//initiatorVerticalPositioning += conversationBackAndForthSpacingPerLine * tempNumLines;
				}
				tf.appendText(currentLineToAdd);
			}	
			
			
			
			
			doneCreatingHTMLFile = false;
			doneCreatingJPGFile = false;
			
			//Actually create the image!
			// create a new JPEG byte array with the adobe JPEGEncoder Class;
			var byteArray:ByteArray = new JPGEncoder (90).encode(bitmapData);
			
			Debug.debug(this, "byte array created");
			var date:Date = new Date();
			var path:String = "";
			var timeInMilliseconds:Number = date.getTime();
			var name:String = "";
			name = timeInMilliseconds + "_" + facebookId;
			nameWithoutJpg = name
			name += ".jpg";
			Debug.debug(this, "This is my brand new file name!!!!" + name);
			var urlRequest:URLRequest = new URLRequest();
			urlRequest.url = baseURL + "/sgTranscriptImages/image.php?path=" + path;
			urlRequest.contentType = 'multipart/form-data; boundary=' + UploadPostHelper.getBoundary();
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data = UploadPostHelper.getPostData(name, byteArray);
			urlRequest.requestHeaders.push ( new URLRequestHeader('Cache-Control', 'no-cache' ));
			
			//Create the image loader and send the image to the server;
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(Event.COMPLETE, imageCompleteCallback);
			urlLoader.load(urlRequest);
			
			//WAIT until all of the stuff that we care about is done being created...
			
			
			Debug.debug(this, "just finished doing it the new way!!!!!");
			
			Debug.debug(this, "maybe I'm waiting for asynchronous things to happen!");
			Debug.debug(this, "maybe I'm waiting for asynchronous things to happen!");
			Debug.debug(this, "Lah lah lade lada la!!");
			
			
			
			//OK, what if I try to make a new webpage file from here?
			/*
			var htmlURLRequest:URLRequest = new URLRequest();
			htmlURLRequest.url = baseURL + " /sgTranscriptImages/generateHTMLPage.php?name=" + nameWithoutJpg;
			htmlURLRequest.method = URLRequestMethod.GET;
			
			var htmlURLLoader:URLLoader = new URLLoader();
			htmlURLLoader.load(htmlURLRequest);
			*/
			Debug.debug(this, "doing crazy new html request...");
			this.request(this.baseURL + "/sgTranscriptImages/generateHTMLPage.php", "GET", nameWithoutJpg, newHTMLpageCallback);
			
			
			
			var fileNameWithHTML:String = nameWithoutJpg + ".html";
			
			/*
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, thousandSeconds);
			timer.start();
			*/
			
			/*
			while (true) { // probably a better way to do this... but this might get the job done for now!
				Debug.debug(this, "still waiting on the function callbacks!");
				if (doneCreatingHTMLFile && doneCreatingJPGFile) {
					Debug.debug(this, "GOT WHAT WE NEEDED!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
					break;
				}
			}
			*/
			
			//returning the file name
			//return nameWithoutJpg;
			
			/*
			sprite.graphics.beginFill(0xA0FB74, 1);
			sprite.graphics.drawRect(0, 0, 400, 400);
			
			Debug.debug(this, "about to start 'drawing' to bitmap data (0th time)...");
			bitmapData.draw(sprite, null, null, null, null, true);
			*/
			
			return nameWithoutJpg;
			
		}	
		
		private function verticalPositioningForDialogue(numLines:Number):Number {
			var spacePerLine:Number = 25;
			var extraPadding:Number = 5;
			return (numLines * spacePerLine + extraPadding)
		}
		
		private function imageCompleteCallback(e:Event):void {
			Debug.debug(this, "image creation callback has been entered into and is all done and stuff!!!!!!");
			doneCreatingJPGFile = true;
		}

		//just a dumb little function used for the character nameplates.
		private function upperCase(str:String) : String {
			 var firstChar:String = str.substr(0, 1); 
			 var restOfString:String = str.substr(1, str.length); 
				
			 return firstChar.toUpperCase()+restOfString.toLowerCase(); 
		}

		
		private function getHeightNeededBasedOnDialogue(instantiation:Instantiation, dialogueBubbleWidth:Number, fontSize:Number, fontType:String):Number {
			var spaceNeeded:Number = 0;
			var initLineTextField:TextField = new TextField();
			var respondLineTextField:TextField = new TextField();
			var otherLineTextField:TextField = new TextField();
			var initLineTextFormat:TextFormat = new TextFormat();
			var respondLineTextFormat:TextFormat = new TextFormat();
			var otherLineTextFormat:TextFormat = new TextFormat();
			var currentLineToAdd:String;
			var amountToYScaleBy:Number = 1;
			var marginAmount:Number = 5;
			
			for each(var line:LineOfDialogue in instantiation.lines) {
				currentLineToAdd = "";
				initLineTextField.text = "";
				respondLineTextField.text = "";
				otherLineTextField.text = "";
				
				if (line.initiatorLine != "") {
					currentLineToAdd = LineOfDialogue.preprocessLine(line.initiatorLine);
					
					//Add an initiator dialogue bubble!
					initLineTextField.text = "";
					initLineTextField.width = dialogueBubbleWidth;
					initLineTextField.height = 500;
					initLineTextField.wordWrap = true;
					
					//initLineTextField.multiline = true;
					initLineTextField.text = currentLineToAdd;
					initLineTextFormat.size = fontSize;
					initLineTextFormat.font = fontType;
					initLineTextFormat.leftMargin = marginAmount;
					initLineTextFormat.rightMargin = marginAmount;
					initLineTextField.setTextFormat(initLineTextFormat);
				
					var tempNumLines:Number = initLineTextField.numLines;
					amountToYScaleBy = Math.ceil (tempNumLines / 2.0); // 1/2 = 1, 2/2 = 1, 3/2 = 2, 4/2 = 2, 5/2 = 3, etc.
					
					spaceNeeded += verticalPositioningForDialogue(tempNumLines+extraHeightOfBubbleNeeded);			
				}
				if (line.responderLine != "") {
					currentLineToAdd = LineOfDialogue.preprocessLine(line.responderLine);

					

					respondLineTextField.text = "";
					respondLineTextField.width = dialogueBubbleWidth;
					respondLineTextField.wordWrap = true;
					//respondLineTextField.multiline = true;
					respondLineTextField.text = currentLineToAdd;
					respondLineTextFormat.size = fontSize;
					respondLineTextFormat.font = fontType;
					respondLineTextFormat.leftMargin = marginAmount;
					respondLineTextFormat.rightMargin = marginAmount;
					respondLineTextField.setTextFormat(respondLineTextFormat);
					

					tempNumLines = respondLineTextField.numLines;
					amountToYScaleBy = Math.ceil (tempNumLines / 2.0); // 1/2 = 1, 2/2 = 1, 3/2 = 2, 4/2 = 2, 5/2 = 3, etc.
					
					spaceNeeded += verticalPositioningForDialogue(tempNumLines+extraHeightOfBubbleNeeded);
					
				}
				if (line.otherLine != "") {
					currentLineToAdd += LineOfDialogue.preprocessLine(line.otherLine);
					
					otherLineTextField.text = "";
					otherLineTextField.width = dialogueBubbleWidth;
					otherLineTextField.wordWrap = true;
					//respondLineTextField.multiline = true;
					otherLineTextField.text = currentLineToAdd;
					otherLineTextFormat.size = fontSize;
					otherLineTextFormat.font = fontType;
					otherLineTextFormat.leftMargin = marginAmount;
					otherLineTextFormat.rightMargin = marginAmount;
					otherLineTextField.setTextFormat(otherLineTextFormat);
					

					tempNumLines = otherLineTextField.numLines;
					amountToYScaleBy = Math.ceil (tempNumLines / 2.0); // 1/2 = 1, 2/2 = 1, 3/2 = 2, 4/2 = 2, 5/2 = 3, etc.
					
					spaceNeeded += verticalPositioningForDialogue(tempNumLines+extraHeightOfBubbleNeeded);
				}
			}	
			return spaceNeeded;
		}
		
		private function newHTMLpageCallback(e:Event):void {
			Debug.debug(this, "new html page has been created I guess!?!?!?!");
			doneCreatingHTMLFile = true;

			
		}
		
		private function thousandSeconds(evt:TimerEvent):void {
				Debug.debug(this, "inside of thousands seconds callback thing!");
				if (doneCreatingHTMLFile && doneCreatingJPGFile)
					return
				else {
					var timer:Timer = new Timer(1000);
					timer.addEventListener(TimerEvent.TIMER, thousandSeconds);
					timer.start();
				}
		}
		
		private function incrementCounters(newLevel:Boolean, gameLoaded:Boolean):void {
			var params:URLVariables = new URLVariables();
			params.UUID = this.getFacebookId();
			params.newLevel = newLevel ? 1 : 0;
			params.gameLoaded = gameLoaded ? 1 : 0;
			Utility.log(this, "incrementCounters() request for incrementing counters: " + params, "Josh");
			this.request(this.baseURL + "/counters.php", URLRequestMethod.POST, params);
		}
		
		/**
		 * Make API request to backend
		 *
		 * @param url partial URL of the API function, e.g. /unlockAchievement.php. baseURL will be prepended to this.
		 * @param method HTTP Method to use (POST, GET)
		 * @param data Data passed along with the request. Usually a URLVariables object, but can be a String or null too.
		 * @param successCb Function called on success, complete event is passed. Signature: function(event:Event):void
		 * @param errorCb Function called for any errors, the error event is passed. Signature: function(event:Event):void
		 */
		private function request(url:String, method:String, data:Object, successCb:Function = null, errorCb:Function = null):void {
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest();
			
			request.url = url;
			request.method = method;
			request.data = data;
			
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			
			if (successCb != null) {
				loader.addEventListener(Event.COMPLETE, successCb);
			}
			
			if (errorCb != null) {
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorCb);
				loader.addEventListener(IOErrorEvent.IO_ERROR, errorCb);
			} else {
				// if there's no fallback Flash might show an error to the user
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.securityErrorHandler);
				loader.addEventListener(IOErrorEvent.IO_ERROR, this.ioErrorHandler);
			}
			
			try {
				loader.load(request);
			} catch(error:Error) {
				if (errorCb != null)
					errorCb(null);
				else {
					Utility.log(this, "Backend: Failed request to " + url + ": " + error.toString(), "Josh");
					trace("Backend: Failed request to " + url + ": " + error.toString());
					Debug.debug(this, "Backend: Failed request to " + url + ": " + error.toString());
					Alert.show("Backend: Failed request to " + url + ": " + error.toString());
					
	
				}
				
			}
		}
		
		
		
		// For now just log any errors, the user probably doesn't
		// want to be bothered with this. Maybe queue commands and retry
		// later?
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
			Utility.log(this, "securityErrorHandler: " + event);
		}
		
		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);
			Utility.log(this, "ioErrorHandler: " + event);
		}
		
		private function endingSeenSuccessCB(event:Event):void {
			var xml:XML = new XML((event.target.data as String));
			
			
			var statisticsManager:StatisticsManager = StatisticsManager.getInstance();
			statisticsManager.endingXML = xml;
			
			//var loader:URLLoader = URLLoader(event.target);
			Debug.debug(this, "getEndingsSeen() I am getting here!  Here is what I think teh xml is? " + xml);
			Utility.log(this, "getEndingsSeen() I am getting here!  Here is what I think teh xml is? " + xml);
			//Utility.log(this, "getEndingsSeen() I am getting here!  Here is what I think teh data is? " + event.target.data);
			//var statisticsManager:StatisticsManager = StatisticsManager.getInstance();
			
			//statisticsManager.endingXML = xml;
			//statisticsManager.endingXML = new XML("<happyhappy/>");
			//statisticsManager.endingDataString = "SUCCESS SUCCESS";
			//statisticsManager.endingDataString = loader.data.doneFile;
				//This is a point where we now have the xml file and we can do anything we want with it.
				//var gameEngine:GameEngine = GameEngine.getInstance();
				//gameEngine.hudGroup.storySelectionScreen.storyDescription += xml.toString();
				//callback(xml);
		}
		
		private function endingSeenErrorCB(event:Event):void {
			var statisticsManager:StatisticsManager = StatisticsManager.getInstance();
			statisticsManager.endingXML = new XML("<ohoh/>");
			statisticsManager.endingDataString = "ERROR ERROR";
		}
		private function goalSeenSuccessCB(event:Event):void {
			var xml:XML;
			try {
				xml = new XML((event.target.data as String));
			}catch (e:Error) {
				xml = new XML("<ohoh/>");
			}
			
			var statisticsManager:StatisticsManager = StatisticsManager.getInstance();
			statisticsManager.goalXML = xml;
			
			//var loader:URLLoader = URLLoader(event.target);
			Debug.debug(this, "getGoalsSeen() I am getting here!  Here is what I think teh xml is? " + xml);
			Utility.log(this, "getGoalsSeen() I am getting here!  Here is what I think teh xml is? " + xml);
			//Utility.log(this, "getgoalsSeen() I am getting here!  Here is what I think teh data is? " + event.target.data);
			//var statisticsManager:StatisticsManager = StatisticsManager.getInstance();
			
			statisticsManager.goalXML = xml;
			statisticsManager.unlockGoalsFromXML(xml);
			
			//This is a point where we now have the xml file and we can do anything we want with it.
			//var gameEngine:GameEngine = GameEngine.getInstance();
			
		}
		
		private function goalSeenErrorCB(event:Event):void {
			var statisticsManager:StatisticsManager = StatisticsManager.getInstance();
			statisticsManager.goalXML = new XML("<ohoh/>");
			statisticsManager.goalDataString = "ERROR ERROR";
		}
		
		private function continueLevelTraceSuccessCB(e:Event):void {
			//get the xml
			try {
				var xml:XML = new XML((e.target.data as String));
			}catch (error:Error) {
				Utility.log(this, "continueLevelTraceSuccessCB() error: " + error + " event.target.data: " + e.target.data );
				this.getContinueLevelTrace();
				return;
			}
			
			Utility.log(this, "continueLevelTraceSuccessCB() the xml from the php script: " + xml);
			GameEngine.getInstance().continueLevelTraceXML = xml;
			GameEngine.getInstance().setContinueButtonState();
		}
		
		private function continueLevelTraceErrorCB(e:Event):void {
			trace("ioErrorHandler: " + e);
			Utility.log(this, "ioErrorHandler: " + e);
		}
		
		private function freeplayStateSuccessCB(e:Event):void {
			//get the xml
			try {
				var xml:XML = new XML((e.target.data as String));
			}catch (error:Error) {
				Utility.log(this, "freeplayLevelTraceSuccessCB() error: " + error + " event.target.data: " + e.target.data );
				this.getFreeplayState();
				return;
			}
			Utility.log(this, "freeplayLevelTraceSuccessCB() the xml from the php script: " + xml);
			GameEngine.getInstance().freeplayLevelTraceXML = xml;
			GameEngine.getInstance().setFreeplayButtonState();
		}
		
		private function freeplayStateErrorCB(e:Event):void {
			trace("ioErrorHandler: " + e);
			Utility.log(this, "ioErrorHandler: " + e);
		}
		
	}
}