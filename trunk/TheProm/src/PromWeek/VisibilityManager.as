package PromWeek 
{
	
	import CiF.Debug;
	import CiF.RelationshipNetwork;
	import CiF.SocialFactsDB;
	import CiF.Status;
	import com.util.SmoothImage;
	import flash.display.Sprite;
	import flash.text.TextLineMetrics;
	import flash.utils.Dictionary;
	import CiF.SocialGameContext;
	import CiF.Predicate;
	import CiF.CiFSingleton;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.formats.VerticalAlign;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	import mx.accessibility.LabelAccImpl;
	import mx.controls.Label;
	import mx.controls.RichTextEditor;
	import mx.controls.Text;
	import mx.core.IVisualElement;
	import mx.core.UITextField;
	import mx.core.UITextFormat;
	import PromWeek.assets.ResourceLibrary;
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.RichText;
	import spark.components.VGroup;
	import spark.utils.TextFlowUtil;
	
	/**
	 * ...
	 * @author Ben*
	 * 
	 * The goal of this manager is keep track of logic which turns on or off various components and functionality.
	 * we have a lot of logic towards the top of Main.mxml, gameEngine, and hudgroup, that should really all be kept in
	 * one centralized location -- this is that location.
	 * 
	 * 
	 */
	public class VisibilityManager
	{
		
		private static var _instance:VisibilityManager = new VisibilityManager();
		private var gameEngine:GameEngine;
		private var cif:CiFSingleton;
		private var dm:DifficultyManager;
		private var resourceLibrary:ResourceLibrary
		
		/**
		 * The _useResetStateButton refers to whether or not we should use the 'resetStateButton' which lives inside
		 * of the hudGroup.  If true, we should use it, and it will appear in the game.  If false, it will keep its visibility
		 * to false.  Right now, the plan is to have reset state only be visible during quick plays.
		 */
		private var _useResetStateButton:Boolean 
		
		/**
		 * The _useNextQuickPlayButton lets us know if we should make the 'next' button to proceed to the next quick play challege be visible or not.
		 * True means it should be visible, false means it should be invisible.
		 */
		private var _useNextQuickPlayButton:Boolean
		
		/**
		 * The _quickPlayLevelGoalsCompeted mean that the player has completed all of the goals of this particular quick play level, and they are ready to move on to the next one!
		 */
		private var _quickPlayLevelGoalsCompleted:Boolean
		 
		/**
		 *  The useSSUs variable refers to whether or not we should allow SSUs to fill up the right hand side of the screen.
		 *  If false, then we shouldn't use SSUs at all. If true, then using them is OK. 'true' is the 'normal' state.
		 *  At the time of this variable's creation, the only time we would want it to be false is during 'quick play' mode, so as to not to overwhelm the player.
		 */
		private var _useSSUs:Boolean
		
		/**
		 * This is the label that tells you what you are supposed to do in a quick play level
		 * (for example, "Make Gunter and Naomi start dating")
		 */
		private var _useQuickPlayLevelInstructions:Boolean
		
		/**
		 * Keeps track as to whether or not the quick play level text has been rendered, because we use
		 * a crazy programmatic HGroup to populate it, and we only want to do it once. If false, it means
		 * we haven't seen it yet (for this level) and we want to populate it. If true, it means that
		 * we have already rendered it and we don't want to render it again... will have to be updated between levels.
		 */
		//private var _quickPlayLevelTextHasBeenRendered:Boolean
		
		/**
		 * Keeps track as to whether or not the 'ending text' of a quick play level has been rendered or not.
		 * If it has been rendered, then we won't bother wasting resources rendering it again.  Otherwise
		 * we will!
		 */
		private var _quickPlayEndingTextHasBeenRendered:Boolean
		
		/**
		 * This will allow us to use the old interface, the MegaUI and such!
		 */
		private var _useOldInterface:Boolean;
		
		/**
		 * The last time a hint was displayed in a quickplay level.
		 */
		private var _lastQuickPlayHintSeenTime:Number
		
		/**
		 * The time the user last did something that made progress towards the goal (as we envision it...)
		 */
		private var _timeOfLastGoodQuickPlayAction:Number
		
		private var isHintCurrentlyDisplayed:Boolean;
		
		private var hintStep:int = 0;
		
		public function VisibilityManager() 
		{
			gameEngine = GameEngine.getInstance();
			cif = CiFSingleton.getInstance();
			dm = DifficultyManager.getInstance();
			resourceLibrary = ResourceLibrary.getInstance();
		}
		
		public static function getInstance():VisibilityManager {
			return _instance;
		}
		
		public function get useResetStateButton():Boolean {
			return _useResetStateButton;
		}
		
		public function set useResetStateButton(val:Boolean):void {
			_useResetStateButton = val;
			if (val) {
				gameEngine.hudGroup.resetStateButton.visible = false; // going to try not even using the reset state button for now.
			}
			else {
				gameEngine.hudGroup.resetStateButton.visible = false;
			}
		}
		
		public function get lastQuickPlayHintSeenTime():Number {
			return _lastQuickPlayHintSeenTime;
		}
		
		public function set lastQuickPlayHintSeenTime(val:Number):void {
			_lastQuickPlayHintSeenTime = val;
		}
		
		public function get timeOfLastGoodQuickPlayAction():Number {
			return _timeOfLastGoodQuickPlayAction;
		}
		
		public function set timeOfLastGoodQuickPlayAction(val:Number):void {
			_timeOfLastGoodQuickPlayAction = val;
		}
		
		
		
		
		/**
		 * 
		 */
		public function get useSSUs():Boolean {
			return _useSSUs;
		}
		
		public function set useSSUs(val:Boolean):void {
			_useSSUs = val;
		}
		
		public function get useQuickPlayLevelInstructions():Boolean {
			return _useQuickPlayLevelInstructions
		}
		
		public function set useQuickPlayLevelInstructions(val:Boolean):void {
			_useQuickPlayLevelInstructions = val;
			if (val) {
				gameEngine.hudGroup.quickPlayLevelInstructionsLabel.visible = true;
				//quickPlayLevelTextHasBeenRendered = false;
			}
			else {
				gameEngine.hudGroup.quickPlayLevelInstructionsLabel.visible = false;
			}
		}
		
		//public function get quickPlayLevelTextHasBeenRendered():Boolean {
			//return _quickPlayLevelTextHasBeenRendered;
		//}
		
		//public function set quickPlayLevelTextHasBeenRendered(val:Boolean):void {
			//_quickPlayLevelTextHasBeenRendered = val;
		//}
		
		public function get quickPlayEndingTextHasBeenRendered():Boolean {
			return _quickPlayEndingTextHasBeenRendered;
		}
		
		public function set quickPlayEndingTextHasBeenRendered(val:Boolean):void {
			_quickPlayEndingTextHasBeenRendered = val;
		}
		
		public function get quickPlayLevelGoalsCompleted():Boolean {
			return _quickPlayLevelGoalsCompleted;
		}
		
		public function set quickPlayLevelGoalsCompleted(val:Boolean):void {
			_quickPlayLevelGoalsCompleted = val;
			if (val) {
				useNextQuickPlayButton = true;			
				gameEngine.hudGroup.inGameOptionMenu.disableGameplayClicks();
				gameEngine.hudGroup.resetStateButton.visible = false;
				//useQuickPlayLevelInstructions = false;
			}
		}
		
		public function get useNextQuickPlayButton():Boolean {
			return _useNextQuickPlayButton
		}
		
		public function set useNextQuickPlayButton(val:Boolean):void {
			_useNextQuickPlayButton = val
			if (val) {
				if (gameEngine.aaronTestMode)
				{
					gameEngine.hudGroup.nextQuickPlayButton.visible = true;
				}
				//make the use next quick play button look special if they finished all quick play challenges!
				if (gameEngine.currentStory.nextChallengeName == "NONE") {
					gameEngine.hudGroup.nextQuickPlayButton.label = "Return to main menu";
				}
				else {
					gameEngine.hudGroup.nextQuickPlayButton.label = "Next Challenge!";
				}
			}
			else {
				gameEngine.hudGroup.nextQuickPlayButton.visible = false;
				gameEngine.hudGroup.nextQuickPlayButton.label = "Next Challenge!";
			}
		}
		
		public function get useOldInterface():Boolean {
			return _useOldInterface;
		}
		
		public function set useOldInterface(val:Boolean):void {
			_useOldInterface = val;
			
			if (_useOldInterface)
			{
				gameEngine.hudGroup.storyGoalWindow.cloakOfInvisibility.visible = true;
				
				gameEngine.hudGroup.optionsDropDownPanel.x = gameEngine.hudGroup.optionsButton.x;
				gameEngine.hudGroup.optionsDropDownPanel.y = gameEngine.hudGroup.optionsButton.height;
				gameEngine.hudGroup.optionsButton.visible = true;
				
				gameEngine.hudGroup.zoomOutButton.visible = true;
				gameEngine.hudGroup.zoomInButton.visible = true;
				
				//gameEngine.hudGroup.intentProgressBar.top = 35; 
				//gameEngine.hudGroup.intentProgressBar.left = 2; 
				
				gameEngine.hudGroup.topBar.visible = false;
				
				gameEngine.hudGroup.megaUI.cloakOfInvisibility.visible = true;
				gameEngine.hudGroup.juiceBar.visible = true;
				
				gameEngine.hudGroup.selectInitiatorGroup.visible = false;
				gameEngine.hudGroup.initiatorSelectedComponent.visible = false;
				
				gameEngine.hudGroup.socialGameButtonRingCloakOfInvisibility.visible = true;
			}
			else
			{
				gameEngine.hudGroup.storyGoalWindow.cloakOfInvisibility.visible = false;
				
				gameEngine.hudGroup.optionsDropDownPanel.x = gameEngine.APPLICATION_WIDTH - gameEngine.hudGroup.optionsDropDownPanel.width;
				gameEngine.hudGroup.optionsDropDownPanel.y = gameEngine.hudGroup.topBar.optionsButton.height;
				gameEngine.hudGroup.optionsButton.visible = false;
				
				gameEngine.hudGroup.zoomOutButton.visible = false;
				gameEngine.hudGroup.zoomInButton.visible = false;
				
				//gameEngine.hudGroup.soundButton.x = gameEngine.hudGroup.topBar.soundButton.x;
				//gameEngine.hudGroup.soundButton.y = gameEngine.hudGroup.topBar.soundButton.y;
				
				gameEngine.hudGroup.intentProgressBar.top = 45; 
				//gameEngine.hudGroup.intentProgressBar.right = 10;
				
				gameEngine.hudGroup.topBar.visible = true;
				
				gameEngine.hudGroup.megaUI.cloakOfInvisibility.visible = false;
				gameEngine.hudGroup.juiceBar.visible = false;
				
				gameEngine.hudGroup.selectInitiatorGroup.visible = true;
				
				gameEngine.hudGroup.socialGameButtonRingCloakOfInvisibility.visible = false;
			}
		}
		
		/**
		 * This function should get called whenever we are about to start a new story (be it quick play, campaign, or sandbox).
		 * This function takes care of a lot of the logic that pertains to the specifics of different story types 
		 * For example, quick play stories have certain UI elements that non-quick play stories do not have, and vice versa.
		 * @param	story the story that is about to be started.
		 */
		public function handleNewStorySettings(story:Story, isFreeplay:Boolean = false ):void {
			if (isFreeplay)
			{
				gameEngine.hudGroup.topBar.changeVisibilityForNotQuickplay();
				gameEngine.hudGroup.topBar.goalButton.update("Prom Week",true);
				gameEngine.hudGroup.topBar.numTurnsLeftButton.update( -1, "Free Play", true);
			}
			else
			{
				if (story.isQuickPlay)
				{
					gameEngine.hudGroup.topBar.changeVisibilityForQuickplay();
				}
				else
				{
					gameEngine.hudGroup.topBar.goalButton.update(story.storyLeadCharacter);
					gameEngine.hudGroup.topBar.changeVisibilityForNotQuickplay();	
					
					gameEngine.hudGroup.newStoryGoalWindow.populateStoryGoalWindow(story);
				}
				
				
			}
			
			
			
			if (story.isQuickPlay) {
				useResetStateButton = true;
				useSSUs = false;
				useQuickPlayLevelInstructions = true;
				useNextQuickPlayButton = true; // changed this to true for Aaron
				quickPlayLevelGoalsCompleted = false;
				quickPlayEndingTextHasBeenRendered = false;
				//quickPlayLevelTextHasBeenRendered = false;
				lastQuickPlayHintSeenTime = new Date().time;
				
			}
			if (!story.isQuickPlay) {
				useResetStateButton = false;
				useSSUs = true;
				useQuickPlayLevelInstructions = false;
				useNextQuickPlayButton = false;
				quickPlayLevelGoalsCompleted = false;
				quickPlayEndingTextHasBeenRendered = false;
				//quickPlayLevelTextHasBeenRendered = false;
			}
		}
		
		public function handleEndOfLevel():void 
		{
			gameEngine.hudGroup.initiatorSelectedComponent.visible = false;
			gameEngine.hudGroup.initiatorSelectedComponent.turnOffCharacterSheet();
			gameEngine.hudGroup.responderPreResponseThoughtBubble.visible = false;
			gameEngine.hudGroup.responderThoughtBubble.visible = false;
			gameEngine.hudGroup.topBar.visible = false;
			gameEngine.hudGroup.responderSubjectiveThoughtBubble.visible = false;
			gameEngine.hudGroup.selectInitiatorGroup.visible = false;
		}
		
		public function startOfPerformance():void 
		{
			if (!this.useOldInterface)
			{
				gameEngine.hudGroup.selectInitiatorGroup.visible = false;
				gameEngine.hudGroup.initiatorSelectedComponent.visible = false;
				gameEngine.hudGroup.initiatorSelectedComponent.initiatorThoughtBubble.visible = false;
				//gameEngine.hudGroup.topBar.visible = false;//handled when init and resp arrive for performance
				gameEngine.hudGroup.responderSubjectiveThoughtBubble.visible = false;
				gameEngine.hudGroup.responderPreResponseThoughtBubble.visible = false;
				gameEngine.hudGroup.responderThoughtBubble.visible = false;
				//gameEngine.hudGroup.quickPlayLevelHintText.visible = false;
				
				if(gameEngine.currentStory.isQuickPlay){
					gameEngine.hudGroup.quickPlayInstructionsText.visible = false;
					gameEngine.hudGroup.quickPlayHintGroup.visible = false;
					isHintCurrentlyDisplayed = false;
					
				}
				
			}
		}
		
		public function startOfInteraction():void 
		{
			if (!this.useOldInterface)
			{
				gameEngine.hudGroup.selectInitiatorGroup.visible = true;
				gameEngine.hudGroup.topBar.visible = true;
				timeOfLastGoodQuickPlayAction = new Date().time; // reset the clock!
				if (gameEngine.currentStory.isQuickPlay) {
					this.findAComponentInTheThingsToGoOnTopGroup("quickPlayLevelInstructionHGroup").visible = true;
				}
				gameEngine.hudGroup.initSelectGroup.deselectAll();
				
				gameEngine.hudGroup.newStoryGoalWindow.populateStoryGoalWindow(gameEngine.currentStory);
			}
		}
		
		/**
		 * Takes everything from the tutorial from way back when that had to do with rendering special items in text, and
		 * specifically applies it to the quick play level instructions
		 * @param	theText The text to be converted to special rendering (that has icons and stuff in it, probably)
		 */
		public function handleQuickPlayLevelInstructionRendering(theText:String):void {	
			//HANDLE RICH TEXT STUFF!
			var tempTextFlow:TextFlow = new TextFlow(); // the 'text flow' is how special things like colors and images are handled!
			
			//THIS WORKS GREAT!
			//tempTextFlow = TextFlowUtil.importFromString(ts.preText); // We start off by grabbing the starting text flow as specified in the tutorial script.
			
			//Try using the 'internal' text instead!
			tempTextFlow = TextFlowUtil.importFromString(theText); // We start off by grabbing the starting text flow as specified in the tutorial script.
			
			var leaf:FlowLeafElement; // used for iteration
			leaf = tempTextFlow.getFirstLeaf();
			var rootPara:ParagraphElement = tempTextFlow.getChildAt(0) as ParagraphElement;  //We'll be adding our new 'span' elements to this paragraph element.
			var tempGraphic:InlineGraphicElement;
			
	
			//We are going to loop through all of the span elements that were specified in the tutorial file, to see if any of the 'special codes' indicating
			//images were specified.
			var leafIndex:int = 0; // Used to figure out WHERE an image should go, if anywhere.
			var shouldDeleteALeaf:Boolean = false;
			//while ((leaf = SpanElement(leaf.getNextLeaf())) != null) {
			while (leaf != null) {
				tempGraphic = new InlineGraphicElement(); //Used for placing an image inside of the rich text component.
				if (leaf.text == "FRIENDS") {
					tempGraphic.source = resourceLibrary.relationshipIcons["friends"];
					tempGraphic.width = 20;
					tempGraphic.height = 20;
					//rootPara.removeChild(leaf);
					//rootPara.removeChildAt(leafIndex);
					shouldDeleteALeaf = true;
					rootPara.addChildAt(leafIndex, tempGraphic);
				}
				else if (leaf.text == "ENDFRIENDS") {
					tempGraphic.source = resourceLibrary.relationshipIcons["endFriends"];
					tempGraphic.width = 20;
					tempGraphic.height = 20;
					//rootPara.removeChild(leaf);
					shouldDeleteALeaf = true;
					rootPara.addChildAt(leafIndex, tempGraphic);
				}
				else if (leaf.text == "DATING") {
					tempGraphic.source = resourceLibrary.relationshipIcons["dating"];
					tempGraphic.width = 20;
					tempGraphic.height = 20;
					//rootPara.removeChild(leaf);
					shouldDeleteALeaf = true;
					rootPara.addChildAt(leafIndex, tempGraphic);
				}
				else if (leaf.text == "ENDDATING") {
					tempGraphic.source = resourceLibrary.relationshipIcons["endDating"];
					tempGraphic.width = 20;
					tempGraphic.height = 20;
					//rootPara.removeChild(leaf);
					shouldDeleteALeaf = true;
					rootPara.addChildAt(leafIndex, tempGraphic);
				}
				else if (leaf.text == "ENEMIES") {
					tempGraphic.source = resourceLibrary.relationshipIcons["enemies"];
					tempGraphic.width = 20;
					tempGraphic.height = 20;
					//rootPara.removeChild(leaf);
					shouldDeleteALeaf = true;
					rootPara.addChildAt(leafIndex, tempGraphic);
				}
				else if (leaf.text == "ENDENEMIES") {
					tempGraphic.source = resourceLibrary.relationshipIcons["endEnemies"];
					tempGraphic.width = 20;
					tempGraphic.height = 20;
					//rootPara.removeChild(leaf);
					//rootPara.removeChildAt(leafIndex);
					shouldDeleteALeaf = true;
					rootPara.addChildAt(leafIndex, tempGraphic);
				}
				else if (leaf.text == "LOCK") {
					tempGraphic.source = resourceLibrary.uiIcons["lock"];
					tempGraphic.width = 20;
					tempGraphic.height = 20;
					//rootPara.removeChild(leaf);
					shouldDeleteALeaf = true;
					rootPara.addChildAt(leafIndex, tempGraphic);
				}
				else if (leaf.text == "PLAYBUTTON") {
					tempGraphic.source = resourceLibrary.uiIcons["playIcon"];
					tempGraphic.width = 40;
					tempGraphic.height = 40;
					//rootPara.removeChild(leaf);
					shouldDeleteALeaf = true;
					rootPara.addChildAt(leafIndex, tempGraphic);
				}
				else if (Avatar.isStringACharacterName(leaf.text)) { // deal with inserting avatars!
					tempGraphic.source = resourceLibrary.charHeads[leaf.text.toLowerCase()];
					tempGraphic.width = 80;
					tempGraphic.height = 80;
					tempGraphic.paddingTop = 5;
					var ca:TextLayoutFormat = new TextLayoutFormat(); 
					var va:VerticalAlign = new VerticalAlign();
					
					ca.verticalAlign = VerticalAlign.MIDDLE;
					ca.paddingTop = 150;
					tempGraphic.format = ca;
					
					shouldDeleteALeaf = true;
					rootPara.addChildAt(leafIndex, tempGraphic);
				}
				leafIndex++;
				leaf = SpanElement(leaf.getNextLeaf());
				if (shouldDeleteALeaf) {
					shouldDeleteALeaf = false;
					rootPara.removeChildAt(leafIndex);
				}
			}
			
			//This is the kind of thing that we would have been parsing.
			//<![CDATA[Make <span color='0xFFFF00' style='display:inline-block; vertical-align:middle'>GUNTER</span> and <span color='0xFFFF00'>NAOMI</span> date! ]]>
			
			//Now that we've manipulated our tempTextFlow to be what we want, stuff it into the actual richText's text flow property!
			gameEngine.hudGroup.quickPlayLevelInstructionsLabel.textFlow = tempTextFlow;
		}
		
		
		public function onEnterJustInitiatorSelected():void
		{
			gameEngine.hudGroup.initiatorSelectedComponent.initSelectGroup.alpha = GameEngine.deemphasizedAlpha;
			
		}
		public function onEnterInitiatorAndResponderSelected():void
		{
			gameEngine.hudGroup.initiatorSelectedComponent.initSelectGroup.alpha = GameEngine.deemphasizedAlpha;
			//thoughtRayImage
			//respSelectGroup
			//thoughtBubbleStemGroup
			//statusGroup
			
		}
	
		
		
		
		//public function createGroupWithTextAndImages(theText:String, groupIdName:String, styleName:String, top:Number, left:Number, imageDimension:Number=60, useFadeEffects:Boolean = true):HGroup {
		public function createGroupWithTextAndImages(theText:String, styleName:String = "QuickPlayInstructionStyle",imageDimension:Number = 35, maxWidth:Number = -1):VGroup 
		{
			var vGroup:VGroup =  new VGroup();
			var group:HGroup =  new HGroup();
			var gapWidth:Number = 5;
			group.gap = gapWidth;
			vGroup.addElement(group);
			//group.height = imageDimension;
			var numHGroups:int = 1;
			
			group.verticalAlign = "middle";
			
			var currentGroupWidth:Number = 0;
			
			//First, we want to 'clean out' the old group, if it exists.
			//removeAComponentFromTheThingsToGoOnTopGroup(group.id);
			var tempArray:Array = theText.split("###");
			var tempLabel:spark.components.Label;
			var tempSmoothImage:SmoothImage;
			var numElementsAddedToHGroup:int = 0;
			for (var i:int = 0; i < tempArray.length; i++) 
			{
				tempSmoothImage = null;
				var tempString:String = tempArray[i];
				if (Avatar.isStringACharacterName(tempString)) 
				{
					tempSmoothImage = this.getImage(resourceLibrary.charHeads[tempString.toLowerCase()], imageDimension);
				}
				else if (Status.getStatusNumberByName(tempString.toLowerCase()) != -1)
				{
					tempSmoothImage = this.getImage(resourceLibrary.statusIcons[tempString.toLowerCase()], imageDimension);
				}
				else if (tempString == "FRIENDS")
				{
					tempSmoothImage = this.getImage(resourceLibrary.relationshipIcons["friends"], imageDimension);
				}
				else if (tempString == "NOT FRIENDS")
				{
					tempSmoothImage = this.getImage(resourceLibrary.relationshipIcons["endFriends"], imageDimension);
				}
				else if (tempString == "DATING")
				{
					tempSmoothImage = this.getImage(resourceLibrary.relationshipIcons["dating"], imageDimension);
				}
				else if (tempString == "NOT DATING")
				{
					tempSmoothImage = this.getImage(resourceLibrary.relationshipIcons["endDating"], imageDimension);
				}
				else if (tempString == "ENEMIES")
				{
					tempSmoothImage = this.getImage(resourceLibrary.relationshipIcons["enemies"], imageDimension);
				}
				else if (tempString == "NOT ENEMIES")
				{
					tempSmoothImage = this.getImage(resourceLibrary.relationshipIcons["endEnemies"], imageDimension);
				}
				else if (tempString == "SGINFO")
				{
					tempSmoothImage = this.getImage(resourceLibrary.uiIcons["sgInfoUp"], imageDimension);
				}
				else if (tempString == "LOCK")
				{
					tempSmoothImage = this.getImage(resourceLibrary.uiIcons["lock"], imageDimension);
				}
				else if (tempString == "COOL UP") {
					tempSmoothImage = this.getImage(resourceLibrary.networkArrowIcons["coolUp"], imageDimension);
					tempSmoothImage.width = tempSmoothImage.width / 2;
				}
				else if (tempString == "COOL DOWN") {
					tempSmoothImage = this.getImage(resourceLibrary.networkArrowIcons["coolDown"], imageDimension);
					tempSmoothImage.width = tempSmoothImage.width / 2;
				}
				else if (tempString == "BUDDY UP") {
					tempSmoothImage = this.getImage(resourceLibrary.networkArrowIcons["buddyUp"], imageDimension);
					tempSmoothImage.width = tempSmoothImage.width / 2;
				}
				else if (tempString == "BUDDY DOWN") {
					tempSmoothImage = this.getImage(resourceLibrary.networkArrowIcons["buddyDown"], imageDimension);
					tempSmoothImage.width = tempSmoothImage.width / 2;
				}
				else if (tempString == "ROMANCE UP") {
					tempSmoothImage = this.getImage(resourceLibrary.networkArrowIcons["romanceUp"], imageDimension);
					tempSmoothImage.width = tempSmoothImage.width / 2;
				}
				else if (tempString == "ROMANCE DOWN") {
					tempSmoothImage = this.getImage(resourceLibrary.networkArrowIcons["romanceDown"], imageDimension);
					tempSmoothImage.width = tempSmoothImage.width / 2;
				}
				else 
				{ // we could deal with other else-ifs here, but for now we won't even worry about it.					
					//var uiTextField:UITextField = new UITextField();
					//uiTextField.styleName = styleName;
					//uiTextField.text = tempString;
					//uiTextField.invalidateSize();
					
					var widthOfChars:Number = 10 * tempString.length;
					
					var stringToAddToNewRow:String = "";
					var actuallyInsertedEverythingSuccessfully:Boolean = false;
					if (maxWidth != -1 && ((currentGroupWidth + widthOfChars) > maxWidth))
					{
						stringToAddToNewRow = this.addAsManyWordsAsPossibleToHGroup(tempString, group, currentGroupWidth, maxWidth, gapWidth, styleName);
						if (stringToAddToNewRow == "" || stringToAddToNewRow == " ") {
							actuallyInsertedEverythingSuccessfully = true;
						}
						group = new HGroup();
						group.verticalAlign = "middle";
						group.gap = gapWidth;
						numElementsAddedToHGroup = 0;
						vGroup.addElement(group);
						currentGroupWidth = 0;
						numHGroups++;
					}
					
					if (stringToAddToNewRow != "" && stringToAddToNewRow != " ")
					{
						tempLabel = new spark.components.Label();
						tempLabel.styleName = styleName;
						tempLabel.text = stringToAddToNewRow;
						numElementsAddedToHGroup++;
						widthOfChars = 9 * stringToAddToNewRow.length; //recompute!
						currentGroupWidth += widthOfChars + gapWidth;
						group.addElement(tempLabel);
					}				
					else if(!actuallyInsertedEverythingSuccessfully)
					{
						tempLabel = new spark.components.Label();
						tempLabel.styleName = styleName;
						tempLabel.text = tempString;
						numElementsAddedToHGroup++;
						currentGroupWidth += widthOfChars + gapWidth;
						group.addElement(tempLabel);
					}
					
				}
				
				
				if (tempSmoothImage != null)
				{
					if (maxWidth != -1 && ((currentGroupWidth + imageDimension) > maxWidth))
					{
						group = new HGroup();
						group.gap = gapWidth;
						group.verticalAlign = "middle";
						vGroup.addElement(group);
						numElementsAddedToHGroup = 0;
						currentGroupWidth = 0;
						numHGroups++;
					}
					numElementsAddedToHGroup++;
					currentGroupWidth += imageDimension + gapWidth;
					group.addElement(tempSmoothImage);
					
				}
			}
			
			vGroup.verticalAlign = "middle";

			return vGroup;
		}
		
		public function getImage(imgSource:Class,imgDim:Number):SmoothImage
		{
			var tempSmoothImage:SmoothImage = new SmoothImage();
			tempSmoothImage.source = imgSource;
			tempSmoothImage.width  = imgDim;
			tempSmoothImage.height = imgDim;
			
			return tempSmoothImage;
		}
		
		public function addAsManyWordsAsPossibleToHGroup(stringToAdd:String,hGroup:HGroup,currentWidth:Number,maxWidth:Number,gapWidth:Number,styleName:String):String
		{
			var tempArray:Array = stringToAdd.split(" ");
			for (var i:int = 0; i < tempArray.length; i++) 
			{
				var tempString:String = tempArray[i];
				
				var tempLabel:spark.components.Label = new spark.components.Label();
				tempLabel.styleName = styleName;
				tempLabel.text = tempString;
				
				var widthOfChars:Number = 10 * tempString.length;
				
				if (maxWidth != -1 && ((currentWidth + widthOfChars) > maxWidth))
				{
					//in this case, we assemble our string and return
					var stringToReturn:String = "";
					for (var j:int = i; j < tempArray.length; j++ )
					{
						stringToReturn += tempArray[j];
						if (j != tempArray.length - 1)
						{
							stringToReturn += " ";
						}
					}
					return stringToReturn;
				}
				else
				{
					//in this case, we add the thingy to the group
					currentWidth += widthOfChars + gapWidth;
					hGroup.addElement(tempLabel);
				}
			}
			return "";
		}
		
		
		public function findAComponentInTheThingsToGoOnTopGroup(id:String):Object {
			for (var i:int = 0; i < gameEngine.hudGroup.stuffToGoOnTopGroup.numElements; i++ ) {
				var o:Object = new Object();
				o = gameEngine.hudGroup.stuffToGoOnTopGroup.getElementAt(i);
				if (o.id == id) {
					Debug.debug(this, "found!");
					return o;
				}
				else {
					
				}
			}
			return new Object(); // didn't find anything... return null! (kind of scary...)
		}
		
		public function removeAComponentFromTheThingsToGoOnTopGroup(id:String):void {
			var tempVisualElement:IVisualElement = findAComponentInTheThingsToGoOnTopGroup(id) as IVisualElement;
			if(tempVisualElement != null)
				gameEngine.hudGroup.stuffToGoOnTopGroup.removeElement(tempVisualElement);
		}
		
		public function handleQuickPlayHintVisiblity():void {			
			if (!gameEngine.currentStory)
				return; // don't even bother with this if we aren't in a story yet.
				
			if (quickPlayLevelGoalsCompleted) {
				//gameEngine.hudGroup.quickPlayLevelHintText.visible = false;
				gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				isHintCurrentlyDisplayed = false;
				return; // we don't need to display any hints! They solved everything already!
			}
				
			
			if(gameEngine.currentState == "Interaction"){ // only want to deal with hints during interaction!
				if (gameEngine.currentStory.isQuickPlay) {
					if (gameEngine.currentStory.title == "QP1") { // right now it is PRETTY HARD CODED...
						handleQuickPlayOneHintVisibility();
					}
					else if (gameEngine.currentStory.title == "QP2") {
						handleQuickPlayTwoHintVisibility();
					}
					else if (gameEngine.currentStory.title == "QP3") {
						handleQuickPlayThreeHintVisibility();
					}
					//else if (gameEngine.currentStory.title == "QP4") {
						//handleQuickPlayFourHintVisibility();
					//}
					//else if (gameEngine.currentStory.title == "QP5") {
						//handleQuickPlayFiveHintVisibility();
					//}
					else if (gameEngine.currentStory.title == "QP6") {
						handleQuickPlaySixHintVisibility();
					}
					else if (gameEngine.currentStory.title == "QP7") {
						handleQuickPlaySevenHintVisibility();
					}
				}
			}
		}
		
		private function handleQuickPlayOneHintVisibility():void {
			var currentTime:Number = new Date().time;
			var hintGroup:Group;
			var primaryName:String = gameEngine.primaryAvatarSelection;
			var secondaryName:String = gameEngine.secondaryAvatarSelection;
			if (primaryName == null) primaryName = "null";
			if (secondaryName == null) secondaryName = "null";
			var hintText:String = "";
			var difference:Number = currentTime - timeOfLastGoodQuickPlayAction;
			if (difference > 3000) { // you get 10 seconds before a hint shows up, maybe?
				if (primaryName.toLowerCase() == "chloe")
				{
					hintText = "Click the background to deselect, then click on ###ZACK###";
					isHintCurrentlyDisplayed = true;					
				}
				else if (primaryName.toLowerCase() != "zack" && hintStep < 1) {
					hintText = "Click on ###ZACK### to select him.";
					isHintCurrentlyDisplayed = true;
				}
				else if (secondaryName.toLowerCase() != "chloe" && hintStep < 2) {
					hintText = "Click on ###CHLOE### to see what ###ZACK### wants to do with her.";
					isHintCurrentlyDisplayed = true;
				}
				else {
					hintText = "Click on Ask Out.";
					isHintCurrentlyDisplayed = true;
				}
				
				
				if (hintText != "")
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.populateHint(hintText);
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = true;
				}
				else
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				}
			}
			else{
				//make the hint invisible.
				this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				isHintCurrentlyDisplayed = false;
			}
		}
		
		private function handleQuickPlayTwoHintVisibility():void {
			var currentTime:Number = new Date().time;
			var hintGroup:Group;
			var primaryName:String = gameEngine.primaryAvatarSelection;
			var secondaryName:String = gameEngine.secondaryAvatarSelection;
			if (primaryName == null) primaryName = "null";
			if (secondaryName == null) secondaryName = "null";
			var hintText:String = "";
			var difference:Number = currentTime - timeOfLastGoodQuickPlayAction;
			if (difference > 3000) { // you get 10 seconds before a hint shows up, maybe?
				if (primaryName.toLowerCase() == "kate")
				{
					hintText = "Click the background to deselect, then click on ###CHLOE###";
					isHintCurrentlyDisplayed = true;					
				}
				else if (primaryName.toLowerCase() != "chloe" && hintStep < 1) {
					hintText = "Click on ###Chloe### to select her.";
					isHintCurrentlyDisplayed = true;
				}
				else if (secondaryName.toLowerCase() != "kate" && hintStep < 2) {
					hintText = "Click on ###KATE### to see what ###CHLOE### wants to do with her.";
					isHintCurrentlyDisplayed = true;
				}
				else {
					hintText = "Click on Brag ###COOL UP###";
					isHintCurrentlyDisplayed = true;
				}
				
				
				if (hintText != "")
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.populateHint(hintText);
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = true;
				}
				else
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				}
			}
			else{
				//make the hint invisible.
				this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				isHintCurrentlyDisplayed = false;
			}
		}
		
		private function handleQuickPlayThreeHintVisibility():void {
			var currentTime:Number = new Date().time;
			var hintGroup:Group;
			var primaryName:String = gameEngine.primaryAvatarSelection;
			var secondaryName:String = gameEngine.secondaryAvatarSelection;
			if (primaryName == null) primaryName = "null";
			if (secondaryName == null) secondaryName = "null";
			var hintText:String = "";
			var difference:Number = currentTime - timeOfLastGoodQuickPlayAction;
			if (difference > 3000) { // you get 10 seconds before a hint shows up, maybe?
				if (primaryName.toLowerCase() == "zack" && gameEngine.hudGroup.initiatorSelectedComponent.initiatorThoughtBubble.visible
					&& !gameEngine.hudGroup.initiatorSelectedComponent.initiatorThoughtBubble.socialExchangeInfoGroup.visible)
				{
					hintText = "Click on ###SGINFO### next to 'Woo' to find out what ###ZACK### and ###LIL### are thinking.";
					isHintCurrentlyDisplayed = true;					
				}
				
				if (hintText != "")
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.populateHint(hintText);
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = true;
				}
				else
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				}
			}
			else{
				//make the hint invisible.
				this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				isHintCurrentlyDisplayed = false;
			}
		}
		/*private function handleQuickPlayFourHintVisibility():void {
			var currentTime:Number = new Date().time;
			var hintGroup:Group;
			var primaryName:String = gameEngine.primaryAvatarSelection;
			var secondaryName:String = gameEngine.secondaryAvatarSelection;
			if (primaryName == null) primaryName = "null";
			if (secondaryName == null) secondaryName = "null";
			var hintText:String = "";
			var difference:Number = currentTime - timeOfLastGoodQuickPlayAction;
			if (difference > 3000) { // you get 10 seconds before a hint shows up, maybe?
				//if (primaryName == null)
				//{
					hintText = "Hint: Friends ###FRIENDS### like to 'Make Plans'...";
					isHintCurrentlyDisplayed = true;					
				//}
				
				if (hintText != "")
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.populateHint(hintText);
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = true;
				}
				else
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				}
			}
			else{
				//make the hint invisible.
				this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				isHintCurrentlyDisplayed = false;
			}
		}*/
		private function handleQuickPlayFiveHintVisibility():void {
			var currentTime:Number = new Date().time;
			var hintGroup:Group;
			var primaryName:String = gameEngine.primaryAvatarSelection;
			var secondaryName:String = gameEngine.secondaryAvatarSelection;
			if (primaryName == null) primaryName = "null";
			if (secondaryName == null) secondaryName = "null";
			var hintText:String = "";
			var difference:Number = currentTime - timeOfLastGoodQuickPlayAction;
			if (difference > 3000) { // you get 10 seconds before a hint shows up, maybe?
				if (CiFSingleton.getInstance().time == 0)
				{
					hintText = "Sometimes the enemy ###ENEMIES### of an enemy ###ENEMIES### can become a friend ###FRIENDS###";
					isHintCurrentlyDisplayed = true;					
				}
				
				if (hintText != "")
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.populateHint(hintText);
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = true;
				}
				else
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				}
			}
			else{
				//make the hint invisible.
				this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				isHintCurrentlyDisplayed = false;
			}
		}
		
		private function handleQuickPlaySixHintVisibility():void {
			var currentTime:Number = new Date().time;
			var hintGroup:Group;
			var primaryName:String = gameEngine.primaryAvatarSelection;
			var secondaryName:String = gameEngine.secondaryAvatarSelection;
			if (primaryName == null) primaryName = "null";
			if (secondaryName == null) secondaryName = "null";
			var hintText:String = "";
			var difference:Number = currentTime - timeOfLastGoodQuickPlayAction;
			if (difference > 3000) { // you get 10 seconds before a hint shows up, maybe?
				if (CiFSingleton.getInstance().time == 0)
				{
					hintText = "Sometimes the enemy ###ENEMIES### of an enemy ###ENEMIES### can become a friend ###FRIENDS###";
					isHintCurrentlyDisplayed = true;					
				}
				
				if (hintText != "")
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.populateHint(hintText);
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = true;
				}
				else
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				}
			}
			else{
				//make the hint invisible.
				this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				isHintCurrentlyDisplayed = false;
			}
		}
		
		private function handleQuickPlaySevenHintVisibility():void {
			var currentTime:Number = new Date().time;
			var hintGroup:Group;
			var primaryName:String = gameEngine.primaryAvatarSelection;
			var secondaryName:String = gameEngine.secondaryAvatarSelection;
			if (primaryName == null) primaryName = "null";
			if (secondaryName == null) secondaryName = "null";
			var hintText:String = "";
			var difference:Number = currentTime - timeOfLastGoodQuickPlayAction;
			if (difference > 3000) { // you get 10 seconds before a hint shows up, maybe?
				if (secondaryName.toLowerCase() == "phoebe" && !gameEngine.hudGroup.responderThoughtBubble.visible 
					&& gameEngine.hudGroup.initiatorSelectedComponent.initiatorThoughtBubble.socialExchangeStepper.superSocialExchangeButtons[0].socialExchangeButton.locked)
				{
					//if we haven't clicked info yet
					hintText = "Unlock ###LOCK### Ask Out by clicking";
					isHintCurrentlyDisplayed = true;					
				}
				else if (secondaryName.toLowerCase() == "phoebe" && !gameEngine.hudGroup.responderPreResponseThoughtBubble.visible
					&& !gameEngine.hudGroup.responderThoughtBubble.visible 
					&& !gameEngine.hudGroup.initiatorSelectedComponent.initiatorThoughtBubble.socialExchangeStepper.superSocialExchangeButtons[0].socialExchangeButton.locked)
				{
					hintText = "Click ###SGINFO### to investigate what ###GUNTER### thinks about this";
					isHintCurrentlyDisplayed = true;										
				}
				else if (secondaryName.toLowerCase() == "phoebe"  && gameEngine.hudGroup.responderPreResponseThoughtBubble.visible)
				{
					hintText = "Find out how ###PHOEBE### will respond by clicking 'Response' ###LOCK###";
					isHintCurrentlyDisplayed = true;					
				}
				else if (secondaryName.toLowerCase() == "phoebe" && gameEngine.hudGroup.responderThoughtBubble.visible
					&& gameEngine.hudGroup.responderThoughtBubble.changeResponseButton.locked)
				{
					hintText = "Change how ###PHOEBE### responds by clicking 'Change Response' ###LOCK###";
					isHintCurrentlyDisplayed = true;					
				}
				else if (secondaryName.toLowerCase() == "phoebe" && gameEngine.hudGroup.responderThoughtBubble.visible
					&& !gameEngine.hudGroup.responderThoughtBubble.changeResponseButton.locked)
				{
					hintText = "Click 'Do It!'";
					isHintCurrentlyDisplayed = true;					
				}
				
				if (hintText != "")
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.populateHint(hintText);
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = true;
				}
				else
				{
					this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				}
			}
			else{
				//make the hint invisible.
				this.gameEngine.hudGroup.quickPlayHintGroup.visible = false;
				isHintCurrentlyDisplayed = false;
			}
		}
		
		public function newAvatarClicked(oldAvatar:String, newAvatar:String, isPrimary:Boolean):void {
			if (!gameEngine.currentStory)
				return;
			if (gameEngine.currentStory.isQuickPlay) {
				if (gameEngine.currentStory.title == "QP1") {
					if (newAvatar == null) {
						if (isPrimary) {
							//hintStep = 0;
						}
						else {
							//hintStep = 0;
						}
						return;
					}
					if (isPrimary) {
						if (newAvatar.toLowerCase() == "zack") {
							timeOfLastGoodQuickPlayAction = new Date().time;
							//hintStep = 1;
							lastQuickPlayHintSeenTime = timeOfLastGoodQuickPlayAction; // we 'reset' the clock, as it were...
						}
					}
					else if (!isPrimary) {
						if (newAvatar.toLowerCase() == "chloe") {
							timeOfLastGoodQuickPlayAction = new Date().time;
							//hintStep = 2;
							lastQuickPlayHintSeenTime = timeOfLastGoodQuickPlayAction; // we reset the clock, they are making progress on their own!
						}
					}
				}
				if (gameEngine.currentStory.title == "QP2") {
					if (newAvatar == null) {
						if (isPrimary) {
							//hintStep = 0;
						}
						else {
							//hintStep = 0;
						}
						return;
					}
					if (isPrimary) {
						if (newAvatar.toLowerCase() == "chloe") {
							timeOfLastGoodQuickPlayAction = new Date().time;
							//hintStep = 1;
							lastQuickPlayHintSeenTime = timeOfLastGoodQuickPlayAction; // we 'reset' the clock, as it were...
						}
					}
					else if (!isPrimary) {
						if (newAvatar.toLowerCase() == "kate") {
							timeOfLastGoodQuickPlayAction = new Date().time;
							//hintStep = 2;
							lastQuickPlayHintSeenTime = timeOfLastGoodQuickPlayAction; // we reset the clock, they are making progress on their own!
						}
					}
				}
			}
		}
		
	}


		


}