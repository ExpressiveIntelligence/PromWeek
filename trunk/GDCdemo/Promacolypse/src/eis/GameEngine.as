

package eis 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.net.Socket;
	import flash.utils.Timer;
	import flash.system.Security;
	import mx.graphics.SolidColor;
	import mx.graphics.SolidColorStroke;
	import mx.rpc.events.ResultEvent;
	import merapi.Bridge;
	import merapi.messages.*;

	import flash.events.DataEvent;
	import mx.flash.UIMovieClip;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import mx.containers.Canvas;
	import mx.controls.Image;  import com.util.SmoothImage;
	//import spark.components.Button;
	import mx.controls.Button;
	import spark.components.Group;
	import mx.core.BitmapAsset;
	import flash.display.Bitmap
	import spark.primitives.BitmapImage;
	import flash.net.XMLSocket;
	import flash.net.Socket;
	import flash.events.*;
	import flash.display.Graphics;
	import flash.display.Shape;
	

	import eis.skins.SocialGameButtonSkin;
	
	/**
	 * ...
	 * @author Josh
	 */
	public class GameEngine extends Group
	{
		public const IDLE:int = 0;
		public const WALKING:int = 1;
		
		public const ACTING:int = 2;
		public const TRANSIT:int = 3;
		
		public const FRONT:int = 0;
		public const LEFT:int = 1;
		public const RIGHT:int = 2;
		
		private var frameCount:int;
		
		[Embed(source="../../assets/Hallway.jpg")]
		[Bindable]
		private var imgCls:Class;
		private var background:SmoothImage;
		//private var merapiBridge:Bridge;

		
		[Embed(source="../../assets/friendship_icon.png")] 
		[Bindable] 
		private var friendshipIconCls:Class;

		[Embed(source="../../assets/dating_icon.png")] 
		[Bindable] 
		private var datingIconCls:Class;
		
		private var commButton:Button;
		
		private var characters:Object = [];
		
		private var lastTimeStamp:Number;
		
		//XML data socket for communicating with CiF
		private var xmlsock:XMLSocket;
		//port for the xml data socket to communicate to CiF over
		private var port:int = 31201;
		private var socket:Socket;

		//Merapi Bridge reference
		//private var b:Bridge;
		
		//Merapi message for sending message
		private var testMessage:Message;
		
		//Merapi hander for handling incoming message
		
		//vars for character selection - holds current selection state
		private var primarySelection:String;
		private var secondarySelection:String;
		private var primarySelectionCircle:SelectionCircle;
		private var secondarySelectionCircle:SelectionCircle;
		private var selectionCircleOffsetX:Number = -78;
		private var selectionCircleOffsetY:Number = 100;

		private var topCharacterVolitions:Object = [];//Vector.<Vector>;
		
		//the vars for social game buttons that appear wihen the second  is selected
		public var socialGameButtons:Vector.<SocialGameButton>;
		private var socialGameButtonOffsetX:Number = -60;
		private var socialGameButtonOffsetY:Number = -60;
		
		public var networkLines:Vector.<NetworkLine>;
		public var networkLineGroup:Group;
		
		//the vars for the mainUI
		private var mainUI:MainUI;
		private var primaryDialogBox:DialogBox;
		private var secondaryDialogBox:DialogBox;

		

		//Vectors of the social games.
		public var romanceUpSG:Vector.<SocialGame>;
		public var relationshipUpSG:Vector.<SocialGame>;
		public var relationshipDownSG:Vector.<SocialGame>;
		public var datingSG:Vector.<SocialGame>;
		public var notFriendsSG:Vector.<SocialGame>;
		

		private var relationshipSocialNet:SocialNetwork; 
		private var romanceSocialNet:SocialNetwork;
		private var authenticitySocialNet:SocialNetwork;  
		
		private var statusNetwork:StatusNetwork;
		

		//Vector of the Hierachies
		private var hierarchies:Vector.<Hierarchy>;
		
		private var characterIntents:Object = [];
		private var prospectiveMemories:Object = [];


		public var romanceUp3:SocialGame;
		public var currentSocialGame:SocialGame;
		public var currentSocialGameLine:int;
		//public var socialGameLastToSpeak:String;
		
		public function GameEngine() 
		{	
			this.frameCount = new int(0);

			background = new SmoothImage();
			background.source = imgCls;
			
			//todo: give the characters network IDs
			characters["Edward"] = new Character();
			characters["Karen"] = new Character();
			characters["Robert"] = new Character();
			
			//initialize the stand in volitions
			topCharacterVolitions["Edward"] = new Vector.<String>();
			topCharacterVolitions["Edward"].push("assaulting Karen");
			topCharacterVolitions["Edward"].push("giving Robert a high five");
			topCharacterVolitions["Edward"].push("practicing martial arts");
			topCharacterVolitions["Edward"].push("asking Karen out");
			
			topCharacterVolitions["Karen"] = new Vector.<String>();
			topCharacterVolitions["Karen"].push("dissing Robert");
			topCharacterVolitions["Karen"].push("snuggling with Edward");
			topCharacterVolitions["Karen"].push("eating lunch");
			topCharacterVolitions["Karen"].push("playing a trick on Robert");
			topCharacterVolitions["Karen"].push("picking her nose");
			
			topCharacterVolitions["Robert"] = new Vector.<String>();
			topCharacterVolitions["Robert"].push("insulting Karen");
			topCharacterVolitions["Robert"].push("doing push ups");
			topCharacterVolitions["Robert"].push("gossiping with Edward");
			topCharacterVolitions["Robert"].push("practing sports");
			
			
			currentSocialGameLine = -1;
			currentSocialGame = null;

			
			//The social networks
			this.relationshipSocialNet = new SocialNetwork(3); 
			this.romanceSocialNet = new SocialNetwork(3);
			this.authenticitySocialNet = new SocialNetwork(3); 
			
			this.statusNetwork = new StatusNetwork(3);
			
			//Set the network IDs, just using magic numbers for now!
			characters["Edward"].setNetworkID(0);
			characters["Karen"].setNetworkID(1);
			characters["Robert"].setNetworkID(2);
			
			//And allocate memory for the social game vectors.
			this.romanceUpSG = new Vector.<SocialGame>();
			this.relationshipUpSG = new Vector.<SocialGame>();
			this.relationshipDownSG = new Vector.<SocialGame>();
			this.datingSG = new Vector.<SocialGame>();
			this.notFriendsSG = new Vector.<SocialGame>();
			
			//Allocate memory for the hierarchy vector.
			this.hierarchies = new Vector.<Hierarchy>();
			
			initSocialNetworks();
			initStatusNetwork();
			initSocialGames();
			initHierarchies();
			initFlashAssets();
			
			background.addEventListener(MouseEvent.CLICK, backgroundClickHandler);
			background.addEventListener(MouseEvent.RIGHT_CLICK, backgroundRightClickHandler);
			addElement(background);
			
			
			this.commButton = new Button();
			this.commButton.label = "Test XMLSocket";
			//commButton.addEventListener(MouseEvent.CLICK, sendMerapiMessage);
			commButton.addEventListener(MouseEvent.CLICK, sendGameChoice);
			//addElement(commButton);
			

			
			//initialize communication
			//Security.loadPolicyFile("http://localhost:843");
			//initXMLDataSocket();
			//initSocket();
			//initMerapi();
			this.testMessage = new Message("test");
			
			trace("Security.sandboxType: " + Security.sandboxType);
			
			characters["Edward"].addCharacter(this);
			characters["Edward"].characterName = "Edward";
			characters["Edward"].setLocation(200, 300);
			characters["Edward"].moveToLocation(200, 300);
			characters["Edward"].setClickHandler(handleCharacterClicks);
			characters["Edward"].getMovieClip().height *= 0.88;
			characters["Edward"].getMovieClip().width *= 0.88;
			
			characters["Karen"].addCharacter(this);
			characters["Karen"].characterName = "Karen";
			characters["Karen"].setLocation(800, 300);
			characters["Karen"].moveToLocation(800, 300);
			characters["Karen"].setClickHandler(handleCharacterClicks);
			characters["Karen"].getMovieClip().height *= 0.88;
			characters["Karen"].getMovieClip().width *= 0.88;
			
			characters["Robert"].addCharacter(this);
			characters["Robert"].characterName = "Robert";
			characters["Robert"].setLocation(500, 500);
			characters["Robert"].moveToLocation(500, 500);
			characters["Robert"].setClickHandler(handleCharacterClicks);
			characters["Robert"].getMovieClip().height *= 0.88;
			characters["Robert"].getMovieClip().width *= 0.88;
			
			this.lastTimeStamp = new Date().time;
			
			//intiate selection circles
			this.primarySelectionCircle = new SelectionCircle();
			this.addElementAt(this.primarySelectionCircle, 1.0);
			this.secondarySelectionCircle = new SelectionCircle();
			this.secondarySelectionCircle.fillColor = new SolidColor(0x111111,0.8);
			this.secondarySelectionCircle.strokeColor = new SolidColorStroke(0x999000,1.0);
			this.addElementAt(this.secondarySelectionCircle, 1.0);
			
			characters["Robert"].setTrait(Trait.REGULATION_HOTTIE);
			characters["Karen"].setTrait(Trait.REGULATION_HOTTIE);
			characters["Edward"].setTrait(Trait.PROMISCUOUS);
			
			
			updateAI();
			}
		
		
		private function updateAI():void {
			//init the prospective memories
			prospectiveMemories["Edward"] = GoalSetting("Edward", characters, relationshipSocialNet, romanceSocialNet, authenticitySocialNet, statusNetwork);
			prospectiveMemories["Karen"] = GoalSetting("Karen", characters, relationshipSocialNet, romanceSocialNet, authenticitySocialNet, statusNetwork);
			prospectiveMemories["Robert"] = GoalSetting("Robert", characters, relationshipSocialNet, romanceSocialNet, authenticitySocialNet, statusNetwork);
			
			//form intent
			characterIntents["Edward"] = new Intent();
			characterIntents["Karen"] = new Intent();
			characterIntents["Robert"] = new Intent();
			characterIntents["Edward"].formIntent(characters["Edward"], characters, prospectiveMemories["Edward"], hierarchies,romanceUpSG, relationshipUpSG, relationshipDownSG, datingSG, notFriendsSG, relationshipSocialNet, romanceSocialNet, authenticitySocialNet, statusNetwork);
			characterIntents["Karen"].formIntent(characters["Karen"], characters, prospectiveMemories["Karen"], hierarchies, romanceUpSG, relationshipUpSG, relationshipDownSG, datingSG, notFriendsSG, relationshipSocialNet, romanceSocialNet, authenticitySocialNet, statusNetwork);
			characterIntents["Robert"].formIntent(characters["Robert"], characters, prospectiveMemories["Robert"], hierarchies, romanceUpSG, relationshipUpSG, relationshipDownSG, datingSG, notFriendsSG, relationshipSocialNet, romanceSocialNet, authenticitySocialNet, statusNetwork);	
		}
		
		/**
		 * Initializes the AIR/Java communication bridge.
		 */
		private function initMerapi():void {
			
		}
		
		private function sendMerapiMessage(e:MouseEvent):void {
			//var message : Message = new Message("test");
			//message.data = "Hello from Merapi Flex.";
			//message.type = "test";
			//Bridge.instance.sendMessage( message );
			//Bridge.getInstance().sendMessage(message);
			//message.send();
			this.testMessage.data = "test message contents";
			trace(Bridge.CONNECTED);
			this.testMessage.send();
			
		}
		
		private function sendGameChoice(e:MouseEvent):void {
			var request:String = "<PLAY_GAME name='SocialGameName' target='edward' initiator='bruce'/>";
			request = "test\n";
			var xmlRequest:XML = new XML(request);
			trace("elements: " + xmlRequest.length());
			trace("sendGameChoice:" + xmlRequest.toXMLString());
			if (socket != null) {
				trace("sendGameChoice: " + " sent to Socket.");
				try {
					socket.writeObject(xmlRequest.toXMLString() +"\n");
					//socket.writeByte(0);
					socket.flush();
					//socket.flush();
					
				} catch (e:IOErrorEvent) {
					trace(e);
				}
				
				//socket.writeUTFBytes(xmlRequest);
				
			} else {
				trace("sendGameChoice: " + " sent to XMLSocket.");
				try {
					xmlsock.send(xmlRequest.toXMLString()+"\n");
					
				} catch (e:IOErrorEvent) {
					trace(e);
				}
			}
		}
		
		private function initXMLDataSocket():void {
			xmlsock = new XMLSocket();
			configureListeners(xmlsock);
			xmlsock.connect("127.0.0.1", this.port);
			//xmlsock.addEventListener(DataEvent.DATA, onData);
			trace("Started XMLDataSocket: " + xmlsock.connected);

		}

		private function initSocket():void {
			socket = new Socket();
			
			socket.connect("127.0.0.1", this.port);
			trace("started socket");
			
			configureListeners(socket);
		}
		
		private function onData(event:DataEvent):void
		{
			trace("[" + event.type + "] " + event.data);
		}

		private function getCiFXMLResponse():void {
			
		}
		
		/**
		 * Load and initialize all imported swf files.
		 */	
		private function initFlashAssets():void {
			characters["Edward"].setMovieClip(new edward_body() as UIMovieClip);
			characters["Edward"].addCharacter(this);
			
			characters["Karen"].setMovieClip(new karen_body() as UIMovieClip);
			characters["Karen"].addCharacter(this);
			
			characters["Robert"].setMovieClip(new robert_body() as UIMovieClip);
			characters["Robert"].addCharacter(this);
			
			//this.testBody = new blankbody() as UIMovieClip;
			//testBody.x = 400;
			//testBody.y = 400;
		}
		
		public function onCreationCompete():void {
			
		}
		

/*
		public var count:Number = 0;
		public var listOfAnimations:Vector.<String> = new Vector.<String>();
		public function toggleAnimations(e:MouseEvent):void {
			this.characters["Karen"].setAnimation(listOfAnimations[count]);
			count++;
		}
*/	
		
		private function socialGameButtonClickHandler(e:MouseEvent):void {
			//for now let's just get rid of all the UI and move the other one to the other one... :)

			
			var clickedButton:SocialGameButton = e.target as SocialGameButton;
			
			if(mainUI != null)
				this.removeElement(mainUI);
			mainUI = null;
			
			removeSocialGameButtons();
			removeNetworkLines();
			removeClickHandlersForSocialGamePlay();
			
			var socialGameToPlay:FilledGame = clickedButton.socialGame;
			//romanceUp3.fillNameTemplates(primarySelection, secondarySelection);
			this.currentSocialGame = socialGameToPlay.game.copyWithFilledTemplates(socialGameToPlay.initiator, socialGameToPlay.target);
			
			if (secondarySelection == null)
			{
				secondarySelection = socialGameToPlay.target;			
				secondarySelectionCircle.fillColor.color = 0x00FF00;
				secondarySelectionCircle.strokeColor.color = 0x02E302;
				secondarySelectionCircle.strokeColor.weight = 5;
				secondarySelectionCircle.fillColor.alpha = 0.9;
				secondarySelectionCircle.visible = true;
			}
			
			characters[primarySelection].speed = 100; //pixels/second
			characterApproachCharacter(socialGameToPlay.initiator, socialGameToPlay.target);
			
			updateNetworkState(socialGameToPlay);
			updateAI();
		}
		
		private function updateNetworkState(sg:FilledGame):void {
			if (sg.game.isSuccess)
			{
				switch (sg.game.socialStatusChange) {
					case SocialGame.DATING:
						statusNetwork.setStatus(StatusNetwork.DATING, characters[sg.initiator], characters[sg.target]);
						
						break;
					case SocialGame.NOT_FRIENDS:
						statusNetwork.removeStatus(StatusNetwork.FRIEND, characters[sg.initiator],characters[sg.target]);
						break;
					case SocialGame.RELATIONSHIP_UP:
						relationshipSocialNet.addWeight(60.0, characters[sg.initiator].networkID, characters[sg.target].networkID);
						relationshipSocialNet.addWeight(60.0, characters[sg.target].networkID, characters[sg.initiator].networkID);
						break;
					case SocialGame.RELATIONSHIP_DOWN:
						relationshipSocialNet.addWeight( -60.0, characters[sg.initiator].networkID, characters[sg.target].networkID);
						relationshipSocialNet.addWeight(-60.0,  characters[sg.target].networkID,  characters[sg.initiator].networkID);
						break;
					case SocialGame.ROMANCE_UP:
						romanceSocialNet.addWeight(60.0, characters[sg.initiator].networkID, characters[sg.target].networkID);
						romanceSocialNet.addWeight(60.0, characters[sg.target].networkID, characters[sg.initiator].networkID);
						break;
				}
			}
		}
		
		private function removeClickHandlersForSocialGamePlay():void
		{
			//remove the bg listener
			background.removeEventListener(MouseEvent.CLICK, backgroundClickHandler);
			background.removeEventListener(MouseEvent.RIGHT_CLICK,backgroundRightClickHandler);
			
			//remove all of the character listeners
			characters["Edward"].clip.removeEventListener(MouseEvent.CLICK, handleCharacterClicks);
			characters["Robert"].clip.removeEventListener(MouseEvent.CLICK, handleCharacterClicks);
			characters["Karen"].clip.removeEventListener(MouseEvent.CLICK, handleCharacterClicks);
		}

		private function restoreClickHandlersFromSocialGamePlay():void
		{
			background.addEventListener(MouseEvent.CLICK, backgroundClickHandler);
			background.addEventListener(MouseEvent.RIGHT_CLICK,backgroundRightClickHandler);			
			characters["Edward"].setClickHandler(handleCharacterClicks);
			characters["Karen"].setClickHandler(handleCharacterClicks);
			characters["Robert"].setClickHandler(handleCharacterClicks);
		}
		
		private function dialogClickHandler(e:MouseEvent):void 
		{
			currentSocialGameLine++;
			if (currentSocialGameLine >= currentSocialGame.conversation.length)
			{
				characters[primarySelection].currentAction = IDLE;
				characters[secondarySelection].currentAction = IDLE;
				characters[primarySelection].setAnimation("idle");
				characters[secondarySelection].setAnimation("idle");
				//this means we have run out of lines.
				removeDialogBoxes();
				removeSelectionCircles();
				
				restoreClickHandlersFromSocialGamePlay();
				
				return;
			}
			
			var nextLine:LineOfDialogue = currentSocialGame.conversation[currentSocialGameLine];

			if (nextLine.speaker == "B")
			{
				//this means it is secondarySelection's turn
				primaryDialogBox.dialog_text.text = "";
				
				secondaryDialogBox.dialog_text.text = nextLine.line;
				characters[secondarySelection].clip.gotoAndPlay(nextLine.associatedAnimation);
				characters[primarySelection].clip.gotoAndPlay(nextLine.reactionAnimation);
			}
			else if (nextLine.speaker == "A")
			{
				//this means it is primarySelection's turn
				secondaryDialogBox.dialog_text.text = "";
				
				primaryDialogBox.dialog_text.text = nextLine.line;
				characters[primarySelection].clip.gotoAndPlay(nextLine.associatedAnimation);
				characters[secondarySelection].clip.gotoAndPlay(nextLine.reactionAnimation);
			}
		}
		
		private function removeDialogBoxes():void
		{
			this.removeElement(primaryDialogBox);
			this.removeElement(secondaryDialogBox);
			primaryDialogBox = null;
			secondaryDialogBox = null;
			
			currentSocialGame = null;
			currentSocialGameLine = -1;
		}
		
		private function removeSelectionCircles():void
		{
			primarySelection = null;
			primarySelectionCircle.visible = false;			
			secondarySelection = null;
			secondarySelectionCircle.visible = false;
		}
		

		private function backgroundRightClickHandler(e:MouseEvent):void 
		{
			if (primarySelection != null)
			{
				characterApproachPoint(primarySelection,e.stageX,e.stageY);
			}
		}
		
		private function backgroundClickHandler(e:MouseEvent):void 
		{
			if (secondarySelection != null) //&& 
				//characters[primarySelection].currentAction != ACTING &&
				//characters[secondarySelection].currentAction != ACTING)
			{
				secondarySelection = null;
				secondarySelectionCircle.visible = false;
				
				removeSocialGameButtons();				
			}
			else if (primarySelection != null)
			{
				primarySelection = null;
				primarySelectionCircle.visible = false;
				
				//remove the mainUI too
				if (mainUI != null)
				{
					this.removeElement(mainUI);
					mainUI = null;
				}
				removeNetworkLines();
			}
		}
		
		public function createMainUI(charName:String):MainUI {
			
			var ui:MainUI = new MainUI(100,25,charName,characterIntents[charName],socialGameButtonClickHandler);

			return ui;
		}
		
		public function handleCharacterClicks(characterName:String, e:MouseEvent):void 
		{
			if (primarySelection == null)
			{
				primarySelection = characterName;
				primarySelectionCircle.fillColor.color = 0xFFE600;
				primarySelectionCircle.strokeColor.color = 0xFFCC00;
				primarySelectionCircle.strokeColor.weight = 5;
				primarySelectionCircle.fillColor.alpha = 0.9;
				primarySelectionCircle.visible = true;
				
				mainUI = createMainUI(characterName);
				this.addElementAt(mainUI, 1);
				this.addElementAt(mainUI, 1);
			}
			else if (secondarySelection == null && primarySelection != characterName)
			{
				secondarySelection = characterName;
				secondarySelectionCircle.fillColor.color = 0x00FF00;
				secondarySelectionCircle.strokeColor.color = 0x02E302;
				secondarySelectionCircle.strokeColor.weight = 5;
				secondarySelectionCircle.fillColor.alpha = 0.9;
				secondarySelectionCircle.visible = true;
				
				//here is where we'd want to build a list of buttons and display them.
				displaySocialGames(secondarySelection,topCharacterVolitions[primarySelection]);
			}
		}
		
		public function removeSocialGameButtons():void
		{
			if (socialGameButtons != null)
			{
				for (var i:int = 0; i < socialGameButtons.length; i++)
				{
					this.removeElement(socialGameButtons[i]);
				}
				socialGameButtons = null;
			}
		}
		
		public function removeNetworkLines():void {
			if (networkLineGroup != null)
			{
				this.removeElement(networkLineGroup);
				for (var i:int = 0; i < networkLines.length;i++ )
				{
					networkLines[i].datingIcon.visible = false;
					networkLines[i].friendshipIcon.visible = false;
				}
				networkLineGroup = null;
				networkLines = null;
			}
		}
		
		public function displaySocialGames(characterName:String,listOfSocialGames:Vector.<String>):void
		{
			socialGameButtons = new Vector.<SocialGameButton>();
			
			var socialGamesWithTarget:Vector.<FilledGame> = characterIntents[primarySelection].getFilledGamesFor(secondarySelection);
			//create the buttons and position them
			for (var i:int = 0; i < socialGamesWithTarget.length; i++)
			{	
				
				var button:SocialGameButton = new SocialGameButton(socialGamesWithTarget[i]);
				
				var radius:Number = 120;
				var degree:Number = (180 / (socialGamesWithTarget.length - 1)) * i;
				
				button.offsetX = Math.cos(degree * Math.PI / 180) * radius;
				button.offsetY = Math.sin(degree * Math.PI/180) * radius;
				
				button.x = characters[secondarySelection].locX + button.offsetX + socialGameButtonOffsetX;
				button.y = characters[secondarySelection].locY - button.offsetY + socialGameButtonOffsetY;
				
				button.label = socialGamesWithTarget[i].game.specificTypeOfGame;
				button.addEventListener(MouseEvent.CLICK, socialGameButtonClickHandler);
				this.addElement(button);
				socialGameButtons.push(button);
			}
		}

		public function characterApproachPoint(char1:String, x:Number, y:Number):void {		
			characters[char1].speed = 100;
			characters[char1].moveToLocation(x, y);
			//tell it tto wait at least five seconds before it paces again
			characters[char1].nextPaceTime += 5000;
		}
		
		public function characterApproachCharacter(char1:String, char2:String):void {
			if (characters[char2].locX - characters[char1].locX > 0)
			{
				characters[char1].moveToLocation(characters[char2].locX - characters[char2].stagingSpace, characters[char2].locY);
			}
			else
			{
				characters[char1].moveToLocation(characters[char2].locX + characters[char2].stagingSpace, characters[char2].locY);
			}
			
			characters[char1].currentAction = TRANSIT;
			characters[char2].currentAction = ACTING;
			
			
			//stop the char2 from moving
			characters[char2].destinationX = characters[char2].locX;
			characters[char2].destinationY = characters[char2].locY;
			characters[char2].setAnimation("idle");
		}


		public function onEnterFrame():void {
			var currentTime:Date = new Date();
			var elapsedTime:Number = currentTime.time - this.lastTimeStamp;
			this.frameCount++;

			//manage the character behaviors
			//starting with idle
			characters["Edward"].update(elapsedTime, currentTime.time);
			characters["Karen"].update(elapsedTime, currentTime.time);
			characters["Robert"].update(elapsedTime, currentTime.time);
			
			//trace(elapsedTime);
			this.lastTimeStamp = currentTime.time;
		
			arrangeCharacterZOrder();
			
			//update selection circles
			if (primarySelection != null)
			{
				this.primarySelectionCircle.setLocation(characters[primarySelection].locX + selectionCircleOffsetX, characters[primarySelection].locY + selectionCircleOffsetY, -100);//(125, 310, -100);
				this.primarySelectionCircle.draw();
				//trace(this.primarySelectionCircle.circle.z);

				var fooX:Boolean = characters[primarySelection].locY == characters[primarySelection].destinationY;
				var fooY:Boolean = characters[primarySelection].locY == characters[primarySelection].destinationY;
				//trace("Primary: "+ characters[primarySelection].currentAction + " " + characters[primarySelection].justArrived + " " + fooX,fooY);
				
			}
			if (secondarySelection != null)
			{
				this.secondarySelectionCircle.setLocation(characters[secondarySelection].locX + selectionCircleOffsetX, characters[secondarySelection].locY + selectionCircleOffsetY, -100);//(125, 310, -100);
				this.secondarySelectionCircle.draw();
				var foo1X:Boolean = characters[secondarySelection].locY == characters[secondarySelection].destinationY;
				var foo1Y:Boolean = characters[secondarySelection].locY == characters[secondarySelection].destinationY;
				//trace("Secondary: " + characters[secondarySelection].currentAction + " " + characters[secondarySelection].justArrived+ " " + foo1X + " " + foo1Y);
			}
			
			
			if (mainUI != null)
			{
				setElementIndex(mainUI, this.numChildren - 1);
			}
			
			//update the position of the social game buttons (if there are any)
			if (socialGameButtons != null)
			{
				for (var i:int = 0; i < socialGameButtons.length; i++)
				{	
					setElementIndex(socialGameButtons[i], this.numChildren - 1);
					socialGameButtons[i].x = characters[secondarySelection].locX + socialGameButtons[i].offsetX + socialGameButtonOffsetX;
					socialGameButtons[i].y = characters[secondarySelection].locY - socialGameButtons[i].offsetY + socialGameButtonOffsetY;
				}
			}
			
			//Last but not least draw the network view if there is one
			if (mainUI != null && mainUI.currentNetwork != null)
			{
				updateNetworkUI();
			}
			
			//update the social game			
			if (currentSocialGame != null)
			{
				//tell the social game to start playing
				if (characters[primarySelection].justArrived)
				{
					characters[primarySelection].justArrived = false;
					currentSocialGameLine = 0;
					characters[primarySelection].currentAction = ACTING;
					
					characters[secondarySelection].currentAction = ACTING;
					characters[primarySelection].setAnimation("idle");
					characters[secondarySelection].setAnimation("idle");
					//set the facing to be right
					if (characters[primarySelection].locX < characters[secondarySelection].locX)
					{
						//make sure each char is facing the right way
						characters[primarySelection].facing = RIGHT;
						characters[secondarySelection].facing = LEFT;	
					}
					else
					{
						characters[secondarySelection].facing = RIGHT;
						characters[primarySelection].facing = LEFT;
					}
					
					//now extra make sure there scaleX is right
					if (characters[primarySelection].facing == LEFT)
					{
						if (characters[primarySelection].clip.scaleX > 0)
							characters[primarySelection].clip.scaleX *= -1;
					}
					else
					{
						if (characters[primarySelection].clip.scaleX <= 0)
							characters[primarySelection].clip.scaleX *= -1;
					}
					if (characters[secondarySelection].facing == LEFT)
					{
						if (characters[secondarySelection].clip.scaleX > 0)
							characters[secondarySelection].clip.scaleX *= -1;
					}
					else
					{
						if (characters[secondarySelection].clip.scaleX <= 0)
							characters[secondarySelection].clip.scaleX *= -1;
					}
				}
				if (currentSocialGameLine == 0 && primaryDialogBox == null && secondaryDialogBox == null)
				{
					//this is the code for making the dialog boxes appear
					primaryDialogBox = new DialogBox("primary", characters[primarySelection].facing,primarySelection);
					primaryDialogBox.addEventListener(MouseEvent.CLICK, dialogClickHandler);
					var firstLine:LineOfDialogue = currentSocialGame.conversation[currentSocialGameLine];
					characters[primarySelection].clip.gotoAndPlay(firstLine.associatedAnimation);
					primaryDialogBox.dialog_text.text = firstLine.line;
					this.addElement(primaryDialogBox);
					secondaryDialogBox = new DialogBox("secondary", characters[secondarySelection].facing,secondarySelection);
					secondaryDialogBox.addEventListener(MouseEvent.CLICK, dialogClickHandler);
					this.addElement(secondaryDialogBox);
				}
				if (primaryDialogBox != null && secondaryDialogBox != null)
				{
					setElementIndex(primaryDialogBox, this.numChildren - 1);
					setElementIndex(secondaryDialogBox, this.numChildren - 1);
				}
			}
		}
		
		private function arrangeCharacterZOrder():void
		{
			//look at all three Z depths and rank them
			//this.setElementIndex(characters["Edward"].clip, this.numChildren - 1);
			
			var allChars:Vector.<Character> = new Vector.<Character>();
			for each (var char:Character in characters)
			{
				allChars.push(char);
			}
			function comp(x:Character, y:Character):Number {
				if (x.locY < y.locY)
				{
					return 1.0;
				}
				else if (x.locY > y.locY)
				{
					return -1.0;
				}
				else
				{
					return 0;
				}
			}
			allChars.sort(comp);
			
			var i:int;
			for (i = allChars.length - 1; i >= 0; i--)
			{
				setElementIndex(characters[allChars[i].characterName].clip, this.numChildren - 1)
			}
			
		}
		
		
		private function updateNetworkUI():void
		{
			//remove the network lines if we are told to...
			if (mainUI.currentNetwork == "clear")
			{
				removeNetworkLines();
				mainUI.currentNetwork = null;
			}
			else
			{
				if (networkLines == null)
				{
					//perhaps add a transparent box or something over the whole thing tinted with the particulr network
					
					networkLines = new Vector.<NetworkLine>();
					networkLineGroup = new Group();
					//initialize the lines
					var line1:NetworkLine;
					var line2:NetworkLine;
					switch (primarySelection) {
						case "Edward":
							line1 = new NetworkLine("Edward", "Karen");
							networkLines.push(line1);
							networkLineGroup.addElement(line1);
							line2 = new NetworkLine("Edward", "Robert");
							networkLines.push(line2);
							networkLineGroup.addElement(line2);
							break;
						case "Karen":
							line1 = new NetworkLine("Karen", "Edward");
							networkLines.push(line1);
							networkLineGroup.addElement(line1);
							line2 = new NetworkLine("Karen", "Robert");
							networkLines.push(line2);
							networkLineGroup.addElement(line2);
							break;
						case "Robert":
							line1 = new NetworkLine("Robert", "Edward");
							networkLines.push(line1);
							networkLineGroup.addElement(line1);
							line2 = new NetworkLine("Robert", "Karen");
							networkLines.push(line2);
							networkLineGroup.addElement(line2);
							break;
					}
					networkLineGroup.x = 0;
					networkLineGroup.y = 0;
					this.addElement(networkLineGroup);
					this.setElementIndex(characters["Edward"].clip, this.numChildren - 1);
					this.setElementIndex(characters["Karen"].clip, this.numChildren - 1);
					this.setElementIndex(characters["Robert"].clip, this.numChildren - 1);
				}
				else
				{
					//update the lines to movement and value
					for (var k:int = 0; k < networkLines.length ; k++)
					{
						var fromID:int = characters[networkLines[k].fromChar].networkID;
						var toID:int = characters[networkLines[k].toChar].networkID;
						networkLines[k].alphaForHeight = relationshipSocialNet.getWeight(fromID,toID) / 100.0;
						
						if (mainUI.currentNetwork == "F" && networkLines[k].network != "F") {
							networkLines[k].network = "F";
							networkLines[k].networkLine.fill = new SolidColor(0x00FF00, networkLines[k].alphaForHeight);
						}
						else if (mainUI.currentNetwork == "R" && networkLines[k].network != "R") {
							networkLines[k].network = "R";
							networkLines[k].networkLine.fill = new SolidColor(0xFF0000, networkLines[k].alphaForHeight);
						}
						else if (mainUI.currentNetwork == "C" && networkLines[k].network != "C") {
							networkLines[k].network = "C";
							networkLines[k].networkLine.fill = new SolidColor(0x0000FF, networkLines[k].alphaForHeight);
						}
						else if (mainUI.currentNetwork == "status" && networkLines[k].network != "status") {
							networkLines[k].network = "status";
							networkLines[k].networkLine.fill = new SolidColor(0xFFFFFF, 0.8);
							networkLines[k].datingIcon.visible = false;
							networkLines[k].friendshipIcon.visible = false;
						}
					}
					
					//update the positions/scales of the networkLines
					for (var j:int = 0; j < networkLines.length ; j++)
					{
						var diffX:Number = characters[networkLines[j].toChar].locX - characters[networkLines[j].fromChar].locX;
						var diffY:Number = characters[networkLines[j].toChar].locY - characters[networkLines[j].fromChar].locY;
						networkLines[j].networkLine.x = characters[networkLines[j].fromChar].locX;
						networkLines[j].networkLine.y = characters[networkLines[j].fromChar].locY;
						//here's some math to get the distance then to rotate it
						networkLines[j].networkLine.width = Math.sqrt(Math.pow(diffX, 2) + Math.pow(diffY, 2));
						
						if (mainUI.currentNetwork == "status")
						{
							networkLines[j].networkLine.height = 30;//networkLines[j].weightHeightMax;
						}
						else
						{
							networkLines[j].networkLine.height = 10 + networkLines[j].alphaForHeight * networkLines[j].weightHeightMax;
						}
						
						//networkLines[j].networkLine.y -= networkLines[j].networkLine.height/2;
						
						//sin(theta) = opposite/hyp, so I want asin(opp/hyp)
						//compute how much we wannt rotate this puppy
						var theta:Number = Math.asin(diffY / networkLines[j].networkLine.width);
						theta *= 180 / Math.PI;
						//make the theta right...
						if (diffX < 0)
						{
							//fromChar on the right
							if (diffY > 0)
							{
								//above
								theta = 180 - theta;
							}
							else
							{
								//below
								theta = 180 + theta;
								theta *= -1;
							}
						}
						
						if (mainUI.currentNetwork != "status")
						{
							//now set the directions lines
							//don't draw lines if we are making status
							networkLines[j].dir1a.xFrom = networkLines[j].networkLine.x + networkLines[j].networkLine.width / 3;
							networkLines[j].dir1a.yFrom = networkLines[j].networkLine.y;
							networkLines[j].dir1a.xTo = networkLines[j].networkLine.x + networkLines[j].networkLine.width / 3 + networkLines[j].dirSlope;
							networkLines[j].dir1a.yTo = networkLines[j].networkLine.y + networkLines[j].networkLine.height / 2;
							networkLines[j].dir1a.transformX = networkLines[j].networkLine.x;
							networkLines[j].dir1a.transformY = networkLines[j].networkLine.y + networkLines[j].networkLine.height/2;
							
							networkLines[j].dir1b.xFrom = networkLines[j].networkLine.x + networkLines[j].networkLine.width / 3 + networkLines[j].dirSlope;
							networkLines[j].dir1b.yFrom = networkLines[j].networkLine.y + networkLines[j].networkLine.height / 2;
							networkLines[j].dir1b.xTo = networkLines[j].networkLine.x + networkLines[j].networkLine.width / 3;
							networkLines[j].dir1b.yTo = networkLines[j].networkLine.y + networkLines[j].networkLine.height;
							networkLines[j].dir1b.transformX = networkLines[j].networkLine.x;
							networkLines[j].dir1b.transformY = networkLines[j].networkLine.y + networkLines[j].networkLine.height/2;
							
							networkLines[j].dir2a.xFrom = networkLines[j].networkLine.x + 2 * networkLines[j].networkLine.width / 3;
							networkLines[j].dir2a.yFrom = networkLines[j].networkLine.y;
							networkLines[j].dir2a.xTo = networkLines[j].networkLine.x + 2 * networkLines[j].networkLine.width / 3 + networkLines[j].dirSlope;
							networkLines[j].dir2a.yTo = networkLines[j].networkLine.y + networkLines[j].networkLine.height / 2;
							networkLines[j].dir2a.transformX = networkLines[j].networkLine.x;
							networkLines[j].dir2a.transformY = networkLines[j].networkLine.y + networkLines[j].networkLine.height/2;
							
							networkLines[j].dir2b.xFrom = networkLines[j].networkLine.x + 2 * networkLines[j].networkLine.width / 3 + networkLines[j].dirSlope;
							networkLines[j].dir2b.yFrom = networkLines[j].networkLine.y + networkLines[j].networkLine.height / 2;
							networkLines[j].dir2b.xTo = networkLines[j].networkLine.x + 2 * networkLines[j].networkLine.width / 3;
							networkLines[j].dir2b.yTo = networkLines[j].networkLine.y + networkLines[j].networkLine.height;
							networkLines[j].dir2b.transformX = networkLines[j].networkLine.x;
							networkLines[j].dir2b.transformY = networkLines[j].networkLine.y + networkLines[j].networkLine.height/2;
							
							networkLines[j].dir1a.rotation = theta;
							networkLines[j].dir1b.rotation = theta;
							networkLines[j].dir2a.rotation = theta;
							networkLines[j].dir2b.rotation = theta;
						}
						else
						{
							if (this.statusNetwork.getStatus(StatusNetwork.FRIEND, characters[networkLines[j].fromChar], characters[networkLines[j].toChar]) == 1.0)
							{
								//this means that we are drawing the status one
								//reposition it!
								networkLines[j].friendshipIcon.x = networkLines[j].networkLine.x + networkLines[j].networkLine.width / 2;
								networkLines[j].friendshipIcon.y = networkLines[j].networkLine.y;
								networkLines[j].friendshipIcon.transformX = networkLines[j].networkLine.x - networkLines[j].friendshipIcon.x;
								networkLines[j].friendshipIcon.transformY = networkLines[j].networkLine.y - networkLines[j].friendshipIcon.y + networkLines[j].networkLine.height/2;
								if (Math.abs(theta) > 90)
								{
									networkLines[j].friendshipIcon.source = networkLines[j].friendshipIconUpsidedownCls;
								}
								else
								{
									networkLines[j].friendshipIcon.source = networkLines[j].friendshipIconCls;
								}
								networkLines[j].friendshipIcon.rotation = theta;
								networkLines[j].friendshipIcon.visible = true;
							}
							if (this.statusNetwork.getStatus(StatusNetwork.DATING, characters[networkLines[j].fromChar], characters[networkLines[j].toChar]) == 1.0)
							{
								//this means that we are drawing the status one
								//reposition it!
								networkLines[j].datingIcon.x = networkLines[j].networkLine.x + networkLines[j].networkLine.width / 2;
								networkLines[j].datingIcon.y = networkLines[j].networkLine.y;
								networkLines[j].datingIcon.transformX = networkLines[j].networkLine.x - networkLines[j].datingIcon.x;
								networkLines[j].datingIcon.transformY = networkLines[j].networkLine.y - networkLines[j].datingIcon.y + networkLines[j].networkLine.height/2;
								if (Math.abs(theta) > 90)
								{
									networkLines[j].datingIcon.source = networkLines[j].datingIconUpsidedownCls;
								}
								else
								{
									networkLines[j].datingIcon.source = networkLines[j].datingIconCls;
								}
								networkLines[j].datingIcon.rotation = theta;
								networkLines[j].datingIcon.visible = true;
							}
							
						}
						//rotate!
						networkLines[j].networkLine.transformY = networkLines[j].networkLine.height / 2;
						networkLines[j].networkLine.rotation = theta;
					}
				}
			}
		}
		
		/* Socket Handlers.*/
		private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.CLOSE, closeHandler);
            dispatcher.addEventListener(Event.CONNECT, connectHandler);
            dispatcher.addEventListener(DataEvent.DATA, dataHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        }

        private function closeHandler(event:Event):void {
            trace("closeHandler: " + event);
        }

        private function connectHandler(event:Event):void {
            trace("connectHandler: " + event);
        }

        private function dataHandler(event:DataEvent):void {
            trace("dataHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            ("ioErrorHandler: " + event);
        }

        private function progressHandler(event:ProgressEvent):void {
            trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
        }

        private function securityErrorHandler(event:SecurityErrorEvent):void {
            trace("securityErrorHandler: " + event);
        }
		
		private function initStatusNetwork():void {
			this.statusNetwork.setStatus(StatusNetwork.FRIEND, characters["Robert"], characters["Edward"]);
		}
		
		private function initSocialNetworks():void {
			//FOR DEMO
			//Robert and Karen don't get along
			//Robert and Edward are friends
			//Karen and Edward need to date each other.
			
			
			var karenID:int = characters["Karen"].networkID;
			var edwardID:int = characters["Edward"].networkID;
			var robertID:int = characters["Robert"].networkID;
			
			
			//init the RELATIONSHIP social net.
			//How does Karen feel about everyone?
			relationshipSocialNet.network[karenID][karenID] = -999; //people don't have feelings for themselves.
			relationshipSocialNet.network[karenID][edwardID] = 80; // Karen likes Edward a lot.
			relationshipSocialNet.network[karenID][robertID] = 40; // karen and robert don't get along too well.
			
			//How does Edward feel about everyone?
			relationshipSocialNet.network[edwardID][karenID] = 80; // Edward likes Karen!
			relationshipSocialNet.network[edwardID][edwardID] = -999; //people don't have feelings for themselves.
			relationshipSocialNet.network[edwardID][robertID] = 65; // Edward is loosely friends with Robert!
			
			//How does Robert feel about everyone?
			relationshipSocialNet.network[robertID][karenID] = 25; // Robert isn't terribly friendly with Karen
			relationshipSocialNet.network[robertID][edwardID] = 60; // Robert is loosely friends with Edward
			relationshipSocialNet.network[robertID][robertID] = -999; // Doesn't have feeling for himself.
			
			//Init the ROMANCE social net!
			//How does Karen feel about everyone
			romanceSocialNet.network[karenID][karenID] = -999; //people don't have feelings for themselves.
			romanceSocialNet.network[karenID][edwardID] = 100; // Karen LOVE Edward a lot.
			romanceSocialNet.network[karenID][robertID] = 10; // karen and robert don't get along too well.
			
			//How does Edward feel about everyone?
			romanceSocialNet.network[edwardID][karenID] = 85; // Edward likes Karen!
			romanceSocialNet.network[edwardID][edwardID] = -999; //people don't have feelings for themselves.
			romanceSocialNet.network[edwardID][robertID] = 0; // Edward has no romantic interest in Robert.
			
			//How does Robert feel about everyone?
			romanceSocialNet.network[robertID][karenID] = 15; // Robert isn't terribly friendly with Karen
			romanceSocialNet.network[robertID][edwardID] = 20; // Robert actually is kind of secretly in love with Edward!
			romanceSocialNet.network[robertID][robertID] = -999; // Doesn't have feeling for himself.
			
			//Init the AUTHENTICITY social net!
			//How does Karen feel about everyone
			authenticitySocialNet.network[karenID][karenID] = -999; //people don't have feelings for themselves.
			authenticitySocialNet.network[karenID][edwardID] = 75; // Karen thinks Edward is pretty cool.
			authenticitySocialNet.network[karenID][robertID] = 50; // karen thinks Robert is so so .
			
			//How does Edward feel about everyone?
			authenticitySocialNet.network[edwardID][karenID] = 65; // Edward thinks Karen is so so!
			authenticitySocialNet.network[edwardID][edwardID] = -999; //people don't have feelings for themselves.
			authenticitySocialNet.network[edwardID][robertID] = 80; // Edward actually thinks robert is pretty neat!
			
			//How does Robert feel about everyone?
			authenticitySocialNet.network[robertID][karenID] = 30; // Robert thinks Karen is kind of lame.
			authenticitySocialNet.network[robertID][edwardID] = 80; // Robert thinks Edward is cool!
			authenticitySocialNet.network[robertID][robertID] = -999; // Doesn't have feeling for himself.
		}
		
		private function initSocialGames():void {
			var romanceUp1:SocialGame = new SocialGame("Conversation Flirt", false, SocialGame.ROMANCE_UP);
			romanceUp1.addLine("A","Hey there, hot stuff! You doing anything tonight?","flirt_wave", 10);
			romanceUp1.addLine("B",  "Eh, probably not with you. Look %%INITIATOR%%, I don't know if you know " +
                    "this, but my friends despise you, and I just can't risk being seen with you!",
					"shocked", 10);
			romanceUpSG.push(romanceUp1);

			var relationshipUp1:SocialGame = new SocialGame("Share Mutual Interest", true, SocialGame.RELATIONSHIP_UP);		
			relationshipUp1.addLine("A","%%TARGET%%! What's your take on Goth Music!","talking", 10);
			relationshipUp1.addLine("B", "Well, it just so happens that I'm a big fan.  What's it to ya?", "talking2", 10);
			relationshipUp1.addLine("A", "Hey, me too! I can't get enough of it!","happy_talk", 10);
			relationshipUp1.addLine("B", "I thought I was the only one! You know %%INITIATOR%%, you're not half bad, kid", "happy_talk", 10);
			relationshipUpSG.push(relationshipUp1);
			
			var romanceUp2:SocialGame = new SocialGame("Conversation Flirt", true, SocialGame.ROMANCE_UP);
			romanceUp2.addLine("A", "Has anyone ever told you how easy it is to get lost in your eyes, %%TARGET%%.","flirt_wave", 10);
			romanceUp2.addLine("B", "Lots of times, but hearing it from your lips, it's the first time that it's ever mattered!","blush", 10);
			romanceUpSG.push(romanceUp2);
			
			var dating1:SocialGame = new SocialGame("Ask Out", true, SocialGame.DATING);
			dating1.addLine("A", "Hey, I'm just gonna bite the bullet and say it: I like you.","blush", 10);
			dating1.addLine("B", "I know %%INITIATOR%%... I like you too!","blush", 10);
			dating1.addLine("A", "It's like a million summer days!", "happy_talk", 10);
			datingSG.push(dating1);
			
			var relationshipDown1:SocialGame = new SocialGame("Joke At Expense Of", true, SocialGame.RELATIONSHIP_DOWN);
			relationshipDown1.addLine("A", "Woah, who let the hippos out!  Looks like you've been packing on the pounds, %%TARGET%%","accuse", 10, "shocked");
			relationshipDown1.addLine("B", "Hey, what's your malfunction, pal?!? Lay off!", "agitated_talk", 10);
			relationshipDownSG.push(relationshipDown1);
			
			var notFriends1:SocialGame = new SocialGame("Cancel Plans to Hang Out", true, SocialGame.NOT_FRIENDS);
			notFriends1.addLine("A", "You know how we had plans to make fun of bad movies tonight?","talking", 4);
			notFriends1.addLine("B", "Yeah?","talking2", 2);
			notFriends1.addLine("A", "I think I'm gonna have to cancel them.","talking2", 4);
			notFriends1.addLine("B", "How come?","agitated_talk", 2);
			notFriends1.addLine("A", "On account of termination of friendship.  Smell ya later, %%TARGET%%.","accuse", 7);
			notFriendsSG.push(notFriends1);
			
			var romanceUp3:SocialGame = new SocialGame("Physical Flirt", true, SocialGame.ROMANCE_UP);
			//romanceUp3 = new SocialGame("Physical Flirt", true);
			romanceUp3.addLine("A","%%TARGET%%, you must get this all the time, but I have to know... could I give your muscles a squeeze?","tickling", 6, "tickled");
			romanceUp3.addLine("B", "Hey hey hey, go for it! And just so you don't think I'm all brawn, check out this feat of dexterity!","happy_talk", 7);
			romanceUp3.addLine("B", "Not bad, huh!","lightsaber_practice", 3,"shocked");
			romanceUp3.addLine("A", "Hee hee! Very impressive, %%TARGET%%","blush", 4);
			romanceUp3.addLine("B", "And I've got brains too--for example, I can always appreciate a fine specimen who appreciates me back!","tickling", 7, "tickled");
			romanceUpSG.push(romanceUp3);
			
			var dating2:SocialGame = new SocialGame("Pick Up Line", true, SocialGame.DATING);
			dating2.addLine("A", "Hey %%TARGET%%.","talking2", 2);
			dating2.addLine("B", "Yeah %%INITIATOR%%?","talking", 2);
			dating2.addLine("A", "If I could be reborn into anything in the world, it would be a tear drop... so I could be born in your eyes, live life on your cheek, and die on your lips.","happy_talk", 8);
			dating2.addLine("B", "Ohhh, that's so sweet!","blush", 4);
			dating2.addLine("A", "%%TARGET%%, will you be my main squeeze?","tickle", 5,"tickled");
			dating2.addLine("B", "Oh %%INITIATOR%%! Yes, yes, a thousand times yes!", "blush", 5);
			datingSG.push(dating2);
		}
		
		private function initHierarchies():void {
			//DATING HIERARCHY
			var myCond:Condition = new Condition()
			myCond.setNetworkCondition(Condition.NETWORK, 70, "B", "A", ">", SocialNetwork.ROMANCE);
			var myInfluence:Influence = new Influence(1, 40);
			myInfluence.conditions.push(myCond);
			
			var myCond2:Condition = new Condition();
			myCond2.setTraitCondition(Condition.TRAIT, Trait.SEX_MAGNET, "A");
			var myInfluence2:Influence = new Influence(2, 50);
			myInfluence2.conditions.push(myCond2);
			
			var myCond3:Condition = new Condition();
			myCond3.setNetworkCondition(Condition.NETWORK, 90, "B", "A", ">", SocialNetwork.ROMANCE);
			var myInfluence3:Influence = new Influence(3, 60);
			myInfluence3.conditions.push(myCond3);
			
			var myCond4:Condition = new Condition();
			myCond4.setStatusCondition(Condition.STATUS, "A", "B", SocialGame.FRIENDS);
			var myInfluence4:Influence = new Influence(1, 30);
			myInfluence4.conditions.push(myCond4);
			
			
			var influenceVector:Vector.<Influence> = new Vector.<Influence>();
			influenceVector.push(myInfluence);
			influenceVector.push(myInfluence2);
			influenceVector.push(myInfluence3);
			influenceVector.push(myInfluence4);
			var datingHierarchy:Hierarchy = new Hierarchy(influenceVector, SocialGame.DATING);
			
			
			
			//ROMANCE UP HIERARCHY
			var myCond5:Condition = new Condition()
			myCond5.setStatusCondition(Condition.STATUS, "A", "B", SocialGame.DATING);
			var myInfluence5:Influence = new Influence(1, 50);
			myInfluence5.conditions.push(myCond5);
			
			var myCond6:Condition = new Condition()
			myCond6.setTraitCondition(Condition.TRAIT, Trait.PROMISCUOUS, "B");
			var myInfluence6:Influence = new Influence(1, 15);
			myInfluence6.conditions.push(myCond6);
			
			var myCond7:Condition = new Condition()
			myCond7.setTraitCondition(Condition.TRAIT, Trait.DESPERATE, "B");
			var myInfluence7:Influence = new Influence(2, 30);
			myInfluence7.conditions.push(myCond7);
			
			var myCond8:Condition = new Condition()
			myCond8.setTraitCondition(Condition.TRAIT, Trait.CONFIDENT, "A");
			var myInfluence8:Influence = new Influence(2, 40);
			myInfluence8.conditions.push(myCond8);
			
			var myCond9:Condition = new Condition()
			myCond9.setTraitCondition(Condition.TRAIT, Trait.REGULATION_HOTTIE, "A");
			var myCond10:Condition = new Condition()
			myCond10.setTraitCondition(Condition.NOTTRAIT, Trait.WILLPOWER, "B");
			var myInfluence9:Influence = new Influence(2, 40);
			myInfluence9.conditions.push(myCond9);
			myInfluence9.conditions.push(myCond10);
			
			var myCond11:Condition = new Condition()
			myCond11.setNetworkCondition(Condition.NETWORK, 75, "B", "A", ">", SocialNetwork.ROMANCE);
			var myCond12:Condition = new Condition()
			myCond12.setTraitCondition(Condition.NOTTRAIT, Trait.CONFIDENT, "A");
			var myInfluence10:Influence = new Influence( -2, -40);
			myInfluence10.conditions.push(myCond11);
			myInfluence10.conditions.push(myCond12);
			
			var myCond40:Condition = new Condition()
			myCond40.setNetworkCondition(Condition.NETWORK, 35, "A", "B", "FriendsOpinion", SocialNetwork.RELATIONSHIP);
			var myInfluence40:Influence = new Influence(2, -60);
			myInfluence40.conditions.push(myCond40);
			
			
			//THERE ARE OTHER NEGATIVE INFLUENCES IN HERE FOR NOT DATING,
			//BUT THEY INVOLVE THINGS THAT WE DO NOT REALLY HAVE IMPLEMENTED YET!!!
			
			var influenceVector2:Vector.<Influence> = new Vector.<Influence>();
			influenceVector2.push(myInfluence5);
			influenceVector2.push(myInfluence6);
			influenceVector2.push(myInfluence7);
			influenceVector2.push(myInfluence8);
			influenceVector2.push(myInfluence9);
			influenceVector2.push(myInfluence10);
			influenceVector2.push(myInfluence40); // The cool new average friends network!
			var romanceUpHierarchy:Hierarchy = new Hierarchy(influenceVector2, SocialGame.ROMANCE_UP);
			
			//RELATIONSHIP UP!
			var myCond13:Condition = new Condition()
			myCond13.setStatusCondition(Condition.STATUS, "A", "B", SocialGame.FRIENDS);
			var myInfluence11:Influence = new Influence(1, 50);
			myInfluence11.conditions.push(myCond13);
			
			var myCond14:Condition = new Condition()
			myCond14.setTraitCondition(Condition.TRAIT, Trait.CONFIDENT, "A");
			var myCond15:Condition = new Condition()
			myCond15.setTraitCondition(Condition.TRAIT, Trait.LOST, "B");
			var myInfluence12:Influence = new Influence(1, 40);
			myInfluence12.conditions.push(myCond14);
			myInfluence12.conditions.push(myCond15);
			
			var myCond16:Condition = new Condition()
			myCond16.setTraitCondition(Condition.TRAIT, Trait.CONFIDENT, "A");
			var myCond17:Condition = new Condition()
			myCond17.setTraitCondition(Condition.TRAIT, Trait.CONFIDENT, "B");
			var myInfluence13:Influence = new Influence(2, 40);
			myInfluence13.conditions.push(myCond16);
			myInfluence13.conditions.push(myCond17);	
			
			var myCond18:Condition = new Condition()
			myCond18.setTraitCondition(Condition.TRAIT, Trait.REGULATION_HOTTIE, "A");
			var myCond19:Condition = new Condition()
			myCond19.setTraitCondition(Condition.TRAIT, Trait.REGULATION_HOTTIE, "B");
			var myInfluence14:Influence = new Influence(2, 40);
			myInfluence14.conditions.push(myCond18);
			myInfluence14.conditions.push(myCond19);
			
			var myCond20:Condition = new Condition()
			myCond20.setStatusCondition(Condition.NOTSTATUS,"A", "B", SocialGame.FRIENDS);
			var myInfluence15:Influence = new Influence(-1, -20);
			myInfluence15.conditions.push(myCond20);

			var myCond21:Condition = new Condition()
			myCond21.setTraitCondition(Condition.TRAIT,Trait.LOST, "B");
			var myCond22:Condition = new Condition()
			myCond22.setTraitCondition(Condition.NOTTRAIT, Trait.CONFIDENT, "A");
			var myInfluence16:Influence = new Influence(-2, -40);
			myInfluence16.conditions.push(myCond21);
			myInfluence16.conditions.push(myCond22);
			
			var influenceVector3:Vector.<Influence> = new Vector.<Influence>();
			influenceVector3.push(myInfluence11);
			influenceVector3.push(myInfluence12);
			influenceVector3.push(myInfluence13);
			influenceVector3.push(myInfluence14);
			influenceVector3.push(myInfluence15);
			influenceVector3.push(myInfluence16);
			var relationshipUpHierarchy:Hierarchy = new Hierarchy(influenceVector3, SocialGame.RELATIONSHIP_UP);
			
			//RELATIONSHIP DOWN!
			var myCond23:Condition = new Condition()
			myCond23.setTraitCondition(Condition.TRAIT,Trait.ABUSIVE, "A");
			var myCond24:Condition = new Condition()
			myCond24.setTraitCondition(Condition.TRAIT, Trait.SENSITIVE, "B");
			var myInfluence17:Influence = new Influence(1, 80);
			myInfluence17.conditions.push(myCond23);
			myInfluence17.conditions.push(myCond24);
			
			var myCond25:Condition = new Condition()
			myCond25.setTraitCondition(Condition.NOTTRAIT,Trait.SEX_MAGNET, "A");
			var myCond26:Condition = new Condition()
			myCond26.setTraitCondition(Condition.NOTTRAIT, Trait.SEX_MAGNET, "B");
			var myInfluence18:Influence = new Influence(2, 40);
			myInfluence18.conditions.push(myCond25);
			myInfluence18.conditions.push(myCond26);
			
			var myCond27:Condition = new Condition()
			myCond27.setStatusCondition(Condition.STATUS, "A", "B", SocialGame.FRIENDS);
			var myInfluence19:Influence = new Influence(-1, -20);
			myInfluence19.conditions.push(myCond27);
			
			var myCond28:Condition = new Condition()
			myCond28.setTraitCondition(Condition.TRAIT, Trait.FRIENDS_WITH_EVERYONE, "B");
			var myInfluence20:Influence = new Influence(-2, -40);
			myInfluence20.conditions.push(myCond28);
			
			var influenceVector4:Vector.<Influence> = new Vector.<Influence>();
			influenceVector4.push(myInfluence17);
			influenceVector4.push(myInfluence18);
			influenceVector4.push(myInfluence19);
			influenceVector4.push(myInfluence20);
			var relationshipDownHierarchy:Hierarchy = new Hierarchy(influenceVector4, SocialGame.RELATIONSHIP_DOWN);

			//STOP BEING FRIENDS!
			var myCond29:Condition = new Condition()
			myCond29.setTraitCondition(Condition.NOTTRAIT, Trait.FRIENDS_WITH_EVERYONE, "A");
			var myCond30:Condition = new Condition()
			myCond30.setTraitCondition(Condition.NOTTRAIT, Trait.FRIENDS_WITH_EVERYONE, "B");
			var myInfluence21:Influence = new Influence(1, 30);
			myInfluence21.conditions.push(myCond29);
			myInfluence21.conditions.push(myCond30);
			
			var myCond31:Condition = new Condition()
			myCond31.setNetworkCondition(Condition.NETWORK, 35, "B", "A", "<", SocialNetwork.RELATIONSHIP);
			var myCond32:Condition = new Condition()
			myCond32.setNetworkCondition(Condition.NETWORK, 35, "A", "B", "<", SocialNetwork.RELATIONSHIP);
			var myInfluence22:Influence = new Influence(2, 40);
			myInfluence22.conditions.push(myCond31);
			myInfluence22.conditions.push(myCond32);	
			
			var myCond33:Condition = new Condition()
			myCond33.setTraitCondition(Condition.TRAIT, Trait.READS_INTO_THINGS, "A");
			var myCond34:Condition = new Condition();
			myCond34.setTraitCondition(Condition.TRAIT, Trait.PROMISCUOUS, "B");
			var myInfluence23:Influence = new Influence(2, 40);
			myInfluence23.conditions.push(myCond33);
			myInfluence23.conditions.push(myCond34);
			
			var myCond35:Condition = new Condition();
			myCond35.setNetworkCondition(Condition.NETWORK, 70, "B", "A", ">", SocialNetwork.ROMANCE);
			var myInfluence24:Influence = new Influence(-1, -20);
			myInfluence24.conditions.push(myCond35);
			
			var myCond36:Condition = new Condition();
			myCond36.setTraitCondition(Condition.TRAIT, Trait.FRIENDS_WITH_EVERYONE, "A");
			var myInfluence25:Influence = new Influence(-2, -10);
			myInfluence25.conditions.push(myCond36);
			
			var myCond37:Condition = new Condition();
			myCond37.setTraitCondition(Condition.TRAIT, Trait.FRIENDS_WITH_EVERYONE, "B");
			var myInfluence26:Influence = new Influence(-2, -10);
			myInfluence26.conditions.push(myCond37);
			
			var influenceVector5:Vector.<Influence> = new Vector.<Influence>();
			influenceVector5.push(myInfluence17);
			influenceVector5.push(myInfluence18);
			influenceVector5.push(myInfluence19);
			influenceVector5.push(myInfluence20);
			var notFriendsHierarchy:Hierarchy = new Hierarchy(influenceVector5, SocialGame.NOT_FRIENDS);

			
			//And finally, push all of the hierarchies into our vector!
			hierarchies.push(datingHierarchy);
			hierarchies.push(romanceUpHierarchy);
			hierarchies.push(relationshipUpHierarchy);
			hierarchies.push(relationshipDownHierarchy);
			hierarchies.push(notFriendsHierarchy);
		}
	}

}

