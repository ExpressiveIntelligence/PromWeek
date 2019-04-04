package PromWeek 
{
	import CiF.CiFSingleton;
	import CiF.SocialGame;
	import CiF.SocialGamesLib;
	import flash.events.EventDispatcher;
	
	public class DropDownItem extends EventDispatcher
	{

	import flash.events.IEventDispatcher;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import CiF.Debug;
	import CiF.SocialGame;
	import CiF.SocialGamesLib;
	import CiF.CiFSingleton;
	import CiF.Predicate;
	import CiF.RelationshipNetwork;
	import CiF.SocialNetwork;
	import PromWeek.assets.ResourceLibrary;
		
	
		private var resourceLibrary:PromWeek.assets.ResourceLibrary;
	
		//private var _ed:EventDispatcher;
		[Bindable]
		public var _game:String;
		[Bindable]
		public var cost:int;
		[Bindable]
		public var backgroundColor:Number;
		[Bindable]
		public var directionality:String;
		
		public var intentType:Number;
		public var intentCategory:Number;
		[Bindable]
		public var showRelationshipIcon:Boolean;
		[Bindable]
		public var relationshipChange:Number;
		[Bindable]
		public var relationshipType:Number;
		
		[Bindable]
		public var relIconSource:String;
		
		[Bindable]
		public var relIconNegated:Boolean;
		
		public var relationshipTypeChanged:Number;
		
		[Bindable]
		public var showNegated:Boolean;
		
		[Bindable]
		public var relIcon:RelationshipButtonIcon;
		
		[Bindable]
		public var isLocked:Boolean;
		//[Bindable]
		//public var lockImage
		
		public function DropDownItem() {
			_game = "";
			cost = 0;
			resourceLibrary = PromWeek.assets.ResourceLibrary.getInstance();
		}
		
		public function onCreationComplete():void 
		{

		}
		
		public function set game(game:String):void {
			this._game = game;
			//Debug.debug(this, "dropDownItem() setting game name");
			//Maybe I can set the background color based on the game name and stuff.
			
			var sgLib:SocialGamesLib = SocialGamesLib.getInstance();
			var sg:SocialGame = sgLib.getByName(this._game);
			
			if(!intentType)
				this.intentType = CiFSingleton.getInstance().socialGamesLib.getByName(this._game).intents[0].predicates[0].getIntentType()
				
			if (!backgroundColor) {
				this.intentCategory = getIntentCategory();
				switch(this.intentCategory) {
					case SocialGameButton.BUDDY:
						backgroundColor = GameEngine.BUDDY_COLOR;
						//Debug.debug(this, "setting background color to buddy: " + backgroundColor + " for " + game);
						break;
					case SocialGameButton.ROMANCE:
						backgroundColor = GameEngine.ROMANCE_COLOR;
						//Debug.debug(this, "setting background color to romance: " + backgroundColor + " for " + game);
						break;
					case SocialGameButton.COOL:
						backgroundColor = GameEngine.COOL_COLOR;
						//Debug.debug(this, "setting background color to cool: " + backgroundColor + " for " + game);
						break;
					default:
						//Debug.debug(this, "setGame() unrecognized intent category!");
				}
			}
			
			if (this.intentType == Predicate.INTENT_ROMANCE_DOWN || this.intentType == Predicate.INTENT_BUDDY_DOWN || 
				this.intentType == Predicate.INTENT_COOL_DOWN)
			{
				this.directionality = "   \\/";
			}
			else if (this.intentType == Predicate.INTENT_ROMANCE_UP || this.intentType == Predicate.INTENT_BUDDY_UP 
				|| this.intentType == Predicate.INTENT_COOL_UP)
			{
				this.directionality = "   /\\";
			}
			else this.directionality = "";
			//Debug.debug(this, "directionality is going to be: " + directionality);
			//Debug.debug(this, "social game name is going to be: " + this._game);
			
			//Display the little relationship picture, if need be.
			relationshipChange = this.getRelationshipChange();
			if (this.relationshipChange!= SocialGameButton.NO_RELATIONSHIP_CHANGE) {
				this.showRelationshipIcon = true;
				switch (this.relationshipChange) {
					case SocialGameButton.NOT_FRIENDS_CHANGE:
					case SocialGameButton.NOT_DATING_CHANGE:
					case SocialGameButton.NOT_ENEMIES_CHANGE:
						this.showNegated = true;
						break;
					default:
						this.showNegated = false;
				}
				
				switch (relationshipChange) {
					case SocialGameButton.NOT_FRIENDS_CHANGE:
					case SocialGameButton.FRIENDS_CHANGE:
						this.relationshipTypeChanged = RelationshipNetwork.FRIENDS;
						//this.relationshipTypeChanged = SocialGameButton.FRIENDS
						break;
					case SocialGameButton.NOT_DATING_CHANGE:
					case SocialGameButton.DATING_CHANGE:
						this.relationshipTypeChanged = RelationshipNetwork.DATING;
						//this.relationshipTypeChanged = SocialGameButton.DATING;
						break;
					case SocialGameButton.NOT_ENEMIES_CHANGE:
					case SocialGameButton.ENEMIES_CHANGE:
						this.relationshipTypeChanged = RelationshipNetwork.ENEMIES;
						//this.relationshipTypeChanged = SocialGameButton.ENEMIES;
						break;
				}
				
			} else {
				this.showRelationshipIcon = false;
			}
			
			
			if (showRelationshipIcon) {
				
				var negated:Boolean = false;
				//switch (relationshipTypeChanged) {
				switch (relationshipChange){
					case SocialGameButton.FRIENDS_CHANGE:
						relationshipType = RelationshipNetwork.FRIENDS;															
						break;
					case SocialGameButton.NOT_FRIENDS_CHANGE:
						relationshipType = RelationshipNetwork.FRIENDS;															
						break;
					case SocialGameButton.DATING_CHANGE:
						relationshipType = RelationshipNetwork.DATING;
						break;
					case SocialGameButton.NOT_DATING_CHANGE:
						relationshipType = RelationshipNetwork.DATING;
						break;
					case SocialGameButton.ENEMIES_CHANGE:
						relationshipType = RelationshipNetwork.ENEMIES;
						break;
					case SocialGameButton.NOT_ENEMIES_CHANGE:
						relationshipType = RelationshipNetwork.ENEMIES;
						break;
				}
			}
			
			
			if (showRelationshipIcon) {
				if(!relIcon){
					relIcon = new PromWeek.RelationshipButtonIcon();
					relIconSource = resourceLibrary.relationshipIcons[RelationshipNetwork.getRelationshipNameByNumber(relationshipType)]
					//relIcon.relationshipImage.source = resourceLibrary.relationshipIcons[RelationshipNetwork.getRelationshipNameByNumber(relationshipType)];
					
					//Debug.debug(this, "rel icon source is: " + relIconSource);
				}
				relIcon.loadRelationshipImagesToIcon(relationshipType, false);
				//this.relIcon.loadRelationshipImagesToIcon(relationshipType, showNegated);
			} 
			
			
		}
		
		public function get game():String {
			return _game;
		}
		
		public function getIntentCategory():int {
			//var intentPred:Predicate = CiFSingleton.getInstance().socialGamesLib.getByName(this._game).intents[0].predicates[0];
			switch (this.intentType) {
				case Predicate.INTENT_BUDDY_UP:
				case Predicate.INTENT_BUDDY_DOWN:
				case Predicate.INTENT_END_ENEMIES:
				case Predicate.INTENT_ENEMIES:
				case Predicate.INTENT_END_FRIENDS:
				case Predicate.INTENT_FRIENDS:
					return SocialGameButton.BUDDY;
				case Predicate.INTENT_ROMANCE_DOWN:
				case Predicate.INTENT_ROMANCE_UP:
				case Predicate.INTENT_DATING:
				case Predicate.INTENT_END_DATING:
					return SocialGameButton.ROMANCE;
				case Predicate.INTENT_COOL_DOWN:
				case Predicate.INTENT_COOL_UP:
					return SocialGameButton.COOL;
					/*
				case RelationshipNetwork.FRIENDS:
				case RelationshipNetwork.ENEMIES:
					return SocialGameButton.BUDDY;
				case RelationshipNetwork.DATING:
					return SocialGameButton.ROMANCE;
					*/
				default:
					//Debug.debug(this, "returning an invalid intent for: " + this._game);
					return SocialGameButton.INVALID_INTENT;
			}
		}
		
		public function getRelationshipChange():int {
			var intentPred:Predicate = CiFSingleton.getInstance().socialGamesLib.getByName(this._game).intents[0].predicates[0];
			if (Predicate.RELATIONSHIP == intentPred.type) {
				switch (intentPred.relationship) {
					case RelationshipNetwork.FRIENDS:
						return (intentPred.negated)?SocialGameButton.NOT_FRIENDS_CHANGE:SocialGameButton.FRIENDS_CHANGE;
					case RelationshipNetwork.ENEMIES:
						return (intentPred.negated)?SocialGameButton.NOT_ENEMIES_CHANGE:SocialGameButton.ENEMIES_CHANGE;
					case RelationshipNetwork.DATING:
						return (intentPred.negated)?SocialGameButton.NOT_DATING_CHANGE:SocialGameButton.DATING_CHANGE;
				}
			}
			return SocialGameButton.NO_RELATIONSHIP_CHANGE;
		}

		
	}
}
