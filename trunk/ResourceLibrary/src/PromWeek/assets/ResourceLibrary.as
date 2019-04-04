package PromWeek.assets 
{

	//import PromWeek.Setting;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
    import flash.display.DisplayObjectContainer;
	import mx.controls.Image;  
	import com.util.SmoothImage;
	import mx.core.ClassFactory;
    import mx.core.BitmapAsset;
	import mx.flash.UIMovieClip;
	import spark.components.Group;
		import spark.primitives.BitmapImage;
		import spark.primitives.Graphic;
	import spark.core.SpriteVisualElement;
	//import PromWeek.assets.settings.*;
	import PromWeek.*;
    import CiF.Debug;
	import com.util.SmoothImage;
	
    
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class ResourceLibrary
	{
		private static var _instance:ResourceLibrary = new ResourceLibrary();
		
		public var characterClips:Dictionary;
		public var backgrounds:Dictionary;
		public var statusIcons:Dictionary;
		public var relationshipIcons:Dictionary;
		public var networkArrowIcons:Dictionary;
		public var uiIcons:Dictionary;
		public var socialChangeRecordArrows:Dictionary;
        public var percentIcons:Dictionary;
		public var portraits:Dictionary;
		public var charHeads:Dictionary;
		public var tutorialScreenshots:Dictionary;
		public var mainMenuBackground:Class;
		public var achievementBackground:Class;
		
		public function ResourceLibrary() 
		{
			if (_instance != null)
			{
				throw new Error("There can only be one ResourceLibrary and one already exists.");
			}
			
			networkArrowIcons = new Dictionary();
			characterClips = new Dictionary();
			statusIcons = new Dictionary();
			relationshipIcons = new Dictionary();
			portraits = new Dictionary();
			charHeads = new Dictionary();
			backgrounds = new Dictionary();
			socialChangeRecordArrows = new Dictionary();
			uiIcons = new Dictionary();
            percentIcons = new Dictionary();
			tutorialScreenshots = new Dictionary();
            
            var bma:BitmapAsset = new BitmapAsset();
            
			
			initializeResources();
		}
		
		public function initializeResources():void
		{
			//temporary image reference
			var img:SmoothImage;
			
			
			//THIS WORKS, RIGHT BUT NOT FOR PROMKING!
			//characterClips["edward"] = new zach() as UIMovieClip;
			//characterClips["nelson"] = new simon() as UIMovieClip;
			//characterClips["mave"] = new buzz() as UIMovieClip;
			//characterClips["karen"] = new lil() as UIMovieClip;
			
			
			//Additional characters for our PromKing scenario

			characterClips["doug"] = new skeleton() as UIMovieClip
			characterClips["jordan"] = new skeleton() as UIMovieClip;
			characterClips["buzz"] = new skeleton() as UIMovieClip;
			characterClips["naomi"] = new skeleton() as UIMovieClip;
			characterClips["lil"] = new skeleton() as UIMovieClip;
			characterClips["nicholas"] = new skeleton() as UIMovieClip;
			characterClips["zack"] = new skeleton() as UIMovieClip;
			characterClips["chloe"] = new skeleton() as UIMovieClip;
			characterClips["simon"] = new skeleton() as UIMovieClip;
			characterClips["monica"] = new skeleton() as UIMovieClip;
			characterClips["edward"] = new skeleton() as UIMovieClip;
			characterClips["oswald"] = new skeleton() as UIMovieClip;
			characterClips["mave"] = new skeleton() as UIMovieClip;
			characterClips["cassandra"] = new skeleton() as UIMovieClip;
			characterClips["gunter"] = new skeleton() as UIMovieClip;
			characterClips["lucas"] = new skeleton() as UIMovieClip;
			characterClips["kate"] = new skeleton() as UIMovieClip;
			characterClips["phoebe"] = new skeleton() as UIMovieClip;
			characterClips["grace"] = new skeleton() as UIMovieClip;
			characterClips["trip"] = new skeleton() as UIMovieClip;
		
			characterClips["dougProm"] = new skeleton() as UIMovieClip;
			characterClips["jordanProm"] = new skeleton() as UIMovieClip;
			characterClips["buzzProm"] = new skeleton() as UIMovieClip;
			characterClips["naomiProm"] = new skeleton() as UIMovieClip;
			characterClips["lilProm"] = new skeleton() as UIMovieClip;
			characterClips["nicholasProm"] = new skeleton() as UIMovieClip;
			characterClips["zackProm"] = new skeleton() as UIMovieClip;
			characterClips["chloeProm"] = new skeleton() as UIMovieClip;
			characterClips["simonProm"] = new skeleton() as UIMovieClip;
			characterClips["monicaProm"] = new skeleton() as UIMovieClip;
			characterClips["edwardProm"] = new skeleton() as UIMovieClip;
			characterClips["oswaldProm"] = new skeleton() as UIMovieClip;
			characterClips["maveProm"] = new skeleton() as UIMovieClip;
			characterClips["cassandraProm"] = new skeleton() as UIMovieClip;
			characterClips["gunterProm"] = new skeleton() as UIMovieClip;
			characterClips["lucasProm"] = new skeleton() as UIMovieClip;
			characterClips["kateProm"] = new skeleton() as UIMovieClip;
			characterClips["phoebeProm"] = new skeleton() as UIMovieClip;
			//Grace has no prom outfit! ;)
			//Trip has no prom outfit! :(

			/*
			characterClips["dougProm"] = new doug_prom() as UIMovieClip;
			characterClips["jordanProm"] = new jordan_prom() as UIMovieClip;
			characterClips["buzzProm"] = new buzz_prom() as UIMovieClip;
			characterClips["naomiProm"] = new naomi_prom() as UIMovieClip;
			characterClips["lilProm"] = new lil_prom() as UIMovieClip;
			characterClips["nicholasProm"] = new nicholas_prom() as UIMovieClip;
			characterClips["zackProm"] = new zack_prom() as UIMovieClip;
			characterClips["chloeProm"] = new chloe_prom() as UIMovieClip;
			characterClips["simonProm"] = new simon_prom() as UIMovieClip;
			characterClips["monicaProm"] = new monica_prom() as UIMovieClip;
			characterClips["edwardProm"] = new edward_prom() as UIMovieClip;
			characterClips["oswaldProm"] = new oswald_prom() as UIMovieClip;
			characterClips["maveProm"] = new mave_prom() as UIMovieClip;
			characterClips["cassandraProm"] = new cassandra_prom() as UIMovieClip;
			characterClips["gunterProm"] = new gunter_prom() as UIMovieClip;
			characterClips["lucasProm"] = new lucas_prom() as UIMovieClip;
			characterClips["kateProm"] = new kate_prom() as UIMovieClip;
			characterClips["phoebeProm"] = new phoebe_prom() as UIMovieClip;
			*/
			
			
			// now set them all up!
			for (var s:String in characterClips) {
				setupSkin(s)
			}
			
			// Start embedding the images for the backgrounds
			//[Embed(source='settings/lockers_bg.svg')]
			//[Embed(source='settings/lockers_square07312011_150dpi.png')] // KAREN'S FIRST INSIDE DRAFT
			[Embed(source='settings/lockers_square07312011.svg')] // KAREN'S FIRST INSIDE DRAFT
			var lockersBGData:Class;
			
			//classroom
			//[Embed(source='settings/classroom_bg.svg')] // KAREN'S FIRST INSIDE DRAFT
			//[Embed(source='settings/classroom_90dpi.png')] // KAREN'S FIRST INSIDE DRAFT
			[Embed(source='settings/classroom_72dpi.png')] // KAREN'S FIRST INSIDE DRAFT
			var classroomBGData:Class;
			
			//cornerstore
			//[Embed(source = "settings/cornerstore_bg.svg")]
			//[Embed(source = "settings/cornerstore_bg_150dpi.png")]
			[Embed(source = "settings/cornerstore_bg_90dpi.png")]
			var cornerstoreBGData:Class;

			// neighborhood
			//[Embed(source = "settings/neighborhood.svg")]
			//[Embed(source = "settings/neighborhood_square.svg")]
			[Embed(source = "settings/neighborhood_square.png")]
			var neighborhoodBGData:Class;
			
			//[Embed(source = "settings/park_bg.svg")]
			//[Embed(source = "settings/park_square.svg")]
			[Embed(source = "settings/park_square.png")]
			var parkBGData:Class;
			//import PromWeek.assets.settings.park_square;
			//var parkBGData:park_square;
			
			//[Embed(source = "settings/parkinglot_bg.svg")]
			[Embed(source = "settings/parkinglot_square.png")]
			var parkinglotBGData:Class;
			
			// prom
			[Embed(source = "settings/prom_90dpi.png")]
			var promBGData:Class;
			
			[Embed(source = "settings/quad.png")]
			var quadBGData:Class;
			
			//[Embed(source = "../../../data/icons/statuses/embarrassed.svg")]
			//var embarrassedData:Class;

			[Embed(source = "settings/facade.png")]
			var facadeData:Class;

			img = new SmoothImage();
			img.source = facadeData;
			backgrounds["facade"] = img;
			
			img = new SmoothImage();
			img.source = lockersBGData;
			backgrounds["lockers"] = img;
			
			img = new SmoothImage();
			img.source = classroomBGData;
			backgrounds["classroom"] = img;
			
			img = new SmoothImage();
			img.source = cornerstoreBGData;
			backgrounds["cornerstore"] = img;
		
			img = new SmoothImage();
			img.source = promBGData;
			backgrounds["prom"] = img;
			
			//neighborhood
			
			img = new SmoothImage();
			img.source = neighborhoodBGData;
			backgrounds["neighborhood"] = img;

			[Embed(source = "../../../data/levelBackgrounds/blank_paper_small.jpg")]
			var blankPaper:Class;
			backgrounds["blankpapersmall"] = blankPaper;
			
			[Embed(source = "../../../data/levelBackgrounds/blank_paper_big.jpg")]
			var blankPaperBig:Class;
			backgrounds["blankpaperbig"] = blankPaperBig;
			
			[Embed(source = "../../../data/icons/greenDialogueBubble.png")]
			var greenBubble:Class;
			backgrounds["greenbubble"] = greenBubble;
			
			[Embed(source = "../../../data/icons/blueDialogueBubble.png")]
			var blueBubble:Class;
			backgrounds["bluebubble"] = blueBubble;
			
			[Embed(source = "../../../data/icons/silverDialogueBubble.png")]
			var silverBubble:Class;
			backgrounds["silverbubble"] = silverBubble;
			
			[Embed(source = "../../../data/icons/sgTranscriptBackgroundStrip.png")]
			var sgTranscriptBackground:Class;
			backgrounds["sgTranscriptBackground"] = sgTranscriptBackground;
			
			//park
			//var sprite:SpriteVisualElement = new SpriteVisualElement();
			//var g:Group = new Group();
			//g.addElement((new park_square()) as SpriteVisualElement);
			//var bitMap:BitmapImage = new BitmapImage();
			//bitMap.source = new park_square();
			//g.addElement(bitMap);
			//g.addElement(new park_square() as SpriteVisualElement);
			//backgrounds["park"] = g;
			img = new SmoothImage();
			img.source = parkBGData;
			backgrounds["park"] = img;
			
			//parkinglot
			img = new SmoothImage();
			img.source = parkinglotBGData;
			backgrounds["parkinglot"] = img;
			
			//quad
			img = new SmoothImage();
			img.source = quadBGData;
			backgrounds["quad"] = img;
	
			//STATUS ICONS
			//public static const EMBARRASSED:int = 6;
			[Embed(source = "../../../data/icons/statuses/embarrassed.svg")]
			
			var embarrassedData:Class;
			statusIcons["embarrassed"] = embarrassedData;
			//public static const CHEATER:int = 7
			[Embed(source = "../../../data/icons/statuses/cheater.svg")]
			var cheaterData:Class;
			statusIcons["cheater"] = cheaterData;
			//public static const SHAKEN:int = 8
			[Embed(source = "../../../data/icons/statuses/shaken.png")]
			var shakenData:Class;
			statusIcons["shaken"] = shakenData;
			//public static const DESPERATE:int = 9
			[Embed(source = "../../../data/icons/statuses/desperate.svg")]
			var desperateData:Class;
			statusIcons["desperate"] = desperateData;
			//public static const CLASS_CLOWN:int = 10
			[Embed(source = "../../../data/icons/statuses/classClown.svg")]
			var classClownData:Class;
			statusIcons["class clown"] = classClownData;
			//public static const BULLY:int = 11
			[Embed(source = "../../../data/icons/statuses/bully.svg")]
			var bullyData:Class;
			statusIcons["bully"] = bullyData;
			//public static const LOVE_STRUCK:int = 12
			[Embed(source = "../../../data/icons/statuses/loveStruck.svg")]
			var loveStruckData:Class;
			statusIcons["love struck"] = loveStruckData;			
			//public static const GROSSED_OUT:int = 13
			[Embed(source = "../../../data/icons/statuses/grossedOut.svg")]
			var grossedOutData:Class;
			statusIcons["grossed out"] = grossedOutData;
			//public static const EXCITED:int = 14
			[Embed(source = "../../../data/icons/statuses/excited.svg")]
			var excitedData:Class;
			statusIcons["excited"] = excitedData;
			//public static const POPULAR:int = 15
			[Embed(source = "../../../data/icons/statuses/popular.svg")]
			var popularData:Class;
			statusIcons["popular"] = popularData;			
			//public static const SAD:int = 16
			[Embed(source = "../../../data/icons/statuses/sad.png")]
			var sadData:Class;
			statusIcons["sad"] = sadData;			
			[Embed(source = "../../../data/icons/statuses/homewrecker.svg")]
			var homewreckerData:Class;
			statusIcons["homewrecker"] = homewreckerData;
			//public static const ANXIOUS:int = 17
			[Embed(source = "../../../data/icons/statuses/anxious.svg")]
			var anxiousData:Class;
			statusIcons["anxious"] = anxiousData;
			//public static const HONOR_ROLL:int = 18
			[Embed(source = "../../../data/icons/statuses/honorRoll.svg")]
			var honorRollData:Class;
			statusIcons["honor roll"] = honorRollData;
			//public static const LOOKING_FOR_TROUBLE:int = 19
			[Embed(source = "../../../data/icons/statuses/lookingForTrouble.svg")]
			var lookingForTroubleData:Class;
			statusIcons["looking for trouble"] = lookingForTroubleData;			
			//public static const GUILTY:int = 20
			[Embed(source = "../../../data/icons/statuses/guilty.svg")]
			var guiltyData:Class;
			statusIcons["guilty"] = guiltyData;			
			//public static const FEELS_OUT_OF_PLACE:int = 21
			[Embed(source = "../../../data/icons/statuses/feelsOutOfPlace.svg")]
			var feelsOutOfPlaceData:Class;
			statusIcons["feels out of place"] = feelsOutOfPlaceData;			
			//public static const HEARTBROKEN:int = 22
			[Embed(source = "../../../data/icons/statuses/heartbroken.svg")]
			var heartbrokenData:Class;
			statusIcons["heartbroken"] = heartbrokenData;			
			//public static const CHEERFUL:int = 23
			[Embed(source = "../../../data/icons/statuses/cheerful.svg")]
			var cheerfulData:Class;
			statusIcons["cheerful"] = cheerfulData;			
			//public static const CONFUSED:int = 24
			[Embed(source = "../../../data/icons/statuses/confused.svg")]
			var confusedData:Class;
			statusIcons["confused"] = confusedData;			
			//public static const LONELY:int = 25
			[Embed(source = "../../../data/icons/statuses/lonely.png")]
			var lonelyData:Class;
			statusIcons["lonely"] = lonelyData;			
			//public static const HAS_A_CRUSH_ON:int = 26
			[Embed(source = "../../../data/icons/statuses/hasACrushOn.svg")]
			var hasACrushOnData:Class;
			statusIcons["has a crush on"] = hasACrushOnData;			
			//public static const ANGRY_AT:int = 27
			[Embed(source = "../../../data/icons/statuses/angryAt.svg")]
			var angryAtData:Class;
			statusIcons["angry at"] = angryAtData;	
			//public static const WANTS_TO_PICK_ON:int = 28
			[Embed(source = "../../../data/icons/statuses/wantsToPickOn.svg")]
			var wantsToPickOnData:Class;
			statusIcons["wants to pick on"] = wantsToPickOnData;			
			//public static const JEALOUS_OF:int = 29
			[Embed(source = "../../../data/icons/statuses/jealousOf.svg")]
			var jealousOfData:Class;
			statusIcons["jealous of"] = jealousOfData;			
			//public static const ANNOYED_WITH:int = 30
			[Embed(source = "../../../data/icons/statuses/annoyedWith.svg")]
			var annoyedWithData:Class;
			statusIcons["annoyed with"] = annoyedWithData;			
			//public static const SCARED_OF:int = 31
			[Embed(source = "../../../data/icons/statuses/scaredOf.svg")]
			var scaredOfData:Class;
			statusIcons["scared of"] = scaredOfData;			
			//public static const PITIES:int = 32
			[Embed(source = "../../../data/icons/statuses/pities.svg")]
			var pitiesData:Class;
			statusIcons["pities"] = pitiesData;			
			//public static const ENVIES:int = 33
			[Embed(source = "../../../data/icons/statuses/envies.svg")]
			var enviesData:Class;
			statusIcons["envies"] = enviesData;			
			//public static const GRATEFUL_TOWARD:int = 34
			[Embed(source = "../../../data/icons/statuses/gratefulToward.svg")]
			var gratefulTowardData:Class;
			statusIcons["grateful toward"] = gratefulTowardData;			
			//public static const TRUSTS:int = 35
			[Embed(source = "../../../data/icons/statuses/trusts.svg")]
			var trustsData:Class;
			statusIcons["trusts"] = trustsData;			
			//public static const FEELS_SUPERIOR_TO:int = 36
			[Embed(source = "../../../data/icons/statuses/feelsSuperiorTo.svg")]
			var feelsSuperiorToData:Class;
			statusIcons["feels superior to"] = feelsSuperiorToData;						
			//public static const FEELS_SUPERIOR_TO:int = 37
			[Embed(source = "../../../data/icons/statuses/cheatingOn.svg")]
			var cheatingOnData:Class;
			statusIcons["cheating on"] = cheatingOnData;
			[Embed(source = "../../../data/icons/statuses/cheatingOn.svg")]
			var cheatedOnByData:Class;
			statusIcons["cheated on by"] = cheatedOnByData;
			[Embed(source = "../../../data/icons/statuses/cheatingOn.svg")]
			var homewrecked:Class;
			statusIcons["homewrecked"] = homewrecked;
			
			[Embed(source = "../../../data/icons/closeIconUp.png")]
			var closeButtonUp:Class;
			uiIcons["closeButtonUp"] = closeButtonUp;

			[Embed(source = "../../../data/icons/closeIconOver.png")]
			var closeButtonOver:Class;
			uiIcons["closeButtonOver"] = closeButtonOver;

			[Embed(source = "../../../data/icons/closeIconDown.png")]
			var closeButtonDown:Class;
			uiIcons["closeButtonDown"] = closeButtonDown;

			[Embed(source = "../../../data/icons/bigThoughtBubbleToggleButton/selected.png")]
			var btbSelected:Class;
			uiIcons["sgThoughtBubToggleSelected"] = btbSelected;

			[Embed(source = "../../../data/icons/bigThoughtBubbleToggleButton/unlockedNotSelectedUp.png")]
			var btbToggleUnlockedUp:Class;
			uiIcons["sgThoughtBubToggleUnlockedUp"] = btbToggleUnlockedUp;

			[Embed(source = "../../../data/icons/bigThoughtBubbleToggleButton/unlockedNotSelectedOver.png")]
			var btbToggleUnlockedOver:Class;
			uiIcons["sgThoughtBubToggleUnlockedOver"] = btbToggleUnlockedOver;

			[Embed(source = "../../../data/icons/bigThoughtBubbleToggleButton/unlockedNotSelectedDown.png")]
			var btbToggleUnlockedDown:Class;
			uiIcons["sgThoughtBubToggleUnlockedDown"] = btbToggleUnlockedDown;

			[Embed(source = "../../../data/icons/backOver.png")]
			var bOver:Class;
			uiIcons["backOver"] = bOver;

			[Embed(source = "../../../data/icons/backUp.png")]
			var bUp:Class;
			uiIcons["backUp"] = bUp;

			[Embed(source = "../../../data/icons/backDown.png")]
			var bDown:Class;
			uiIcons["backDown"] = bDown;

			[Embed(source = "../../../data/icons/lockedDownSocialExchangeButton.png")]
			var ldseb:Class;
			uiIcons["lockedSocialExchangeButtonDown"] = ldseb;

			[Embed(source = "../../../data/icons/lockedOverSocialExchangeButton.png")]
			var loseb:Class;
			uiIcons["lockedSocialExchangeButtonOver"] = loseb;

			[Embed(source = "../../../data/icons/lockedUpSocialExchangeButton.png")]
			var luseb:Class;
			uiIcons["lockedSocialExchangeButtonUp"] = luseb;

			[Embed(source = "../../../data/icons/unlockedDownSocialExchangeButton.png")]
			var uldseb:Class;
			uiIcons["unlockedSocialExchangeButtonDown"] = uldseb;

			[Embed(source = "../../../data/icons/unlockedOverSocialExchangeButton.png")]
			var uloseb:Class;
			uiIcons["unlockedSocialExchangeButtonOver"] = uloseb;

			[Embed(source = "../../../data/icons/unlockedUpSocialExchangeButton.png")]
			var uluseb:Class;
			uiIcons["unlockedSocialExchangeButtonUp"] = uluseb;


			
			//MenuScreen
			[Embed(source = "../../../data/menus/curtains.jpg")]
			var facadeCurtains:Class;
			uiIcons["facadeCurtains"] = facadeCurtains;

			[Embed(source = "../../../data/menus/promscrn_notebookconcept.png")]
			var mainMenuBackground1:Class;
			mainMenuBackground = mainMenuBackground1;
			
			[Embed(source = "../../../data/menus/titleScreen.png")]
			var mainMenuBackground2:Class;
			uiIcons["titleScreen"] = mainMenuBackground2;
			
			//[Embed(source = "../../../data/menus/logo.png")]
			//var logo:Class;
			//uiIcons["logo"] = logo;
			
			[Embed(source = "../../../data/menus/facade.png")]
			var facade:Class;
			uiIcons["facade"] = facade;
			
			[Embed(source = "../../../data/menus/credits.png")]
			var creditsBackground1:Class;
			uiIcons["credits"] = creditsBackground1;
			
			//Achievements
			[Embed(source = "../../../data/menus/lockerexample1.png")]
			var achievementBackground1:Class;
			achievementBackground = achievementBackground1;
			
			//PORTRAITS
			[Embed(source="../../../data/portraits/noOne-portrait.png")]
			var noOnePortraitData:Class;
			portraits["noOne"] = noOnePortraitData;
			
			[Embed(source="../../../data/portraits/edward-portrait.png")]
			var edwardPortraitData:Class;
			portraits["edward"] = edwardPortraitData;
			
			[Embed(source="../../../data/portraits/kate-portrait.png")]
			var katePortraitData:Class;
			portraits["kate"] = katePortraitData;
			
			[Embed(source="../../../data/portraits/lucas-portrait.png")]
			var lucasPortraitData:Class;
			portraits["lucas"] = lucasPortraitData;

			[Embed(source="../../../data/portraits/mave-portrait.png")]
			var mavePortraitData:Class;
			portraits["mave"] = mavePortraitData;

			[Embed(source="../../../data/portraits/phoebe-portrait.png")]
			var phoebePortraitData:Class;
			portraits["phoebe"] = phoebePortraitData;
			
			//Other portraits we need for Prom King:
			[Embed(source="../../../data/portraits/jordan-portrait.png")]
			var jordanPortraitData:Class;
			portraits["jordan"] = jordanPortraitData;
			
			[Embed(source="../../../data/portraits/doug-portrait.png")]
			var dougPortraitData:Class;
			portraits["doug"] = dougPortraitData;
			
			[Embed(source="../../../data/portraits/buzz-portrait.png")]
			var buzzPortraitData:Class;
			portraits["buzz"] = buzzPortraitData;
			
			[Embed(source="../../../data/portraits/naomi-portrait.png")]
			var naomiPortraitData:Class;
			portraits["naomi"] = naomiPortraitData;
			
			[Embed(source="../../../data/portraits/lil-portrait.png")]
			var lilPortraitData:Class;
			portraits["lil"] = lilPortraitData;
			
			[Embed(source="../../../data/portraits/nicholas-portrait.png")]
			var nicholasPortraitData:Class;
			portraits["nicholas"] = nicholasPortraitData;
			
			[Embed(source="../../../data/portraits/zack-portrait.png")]
			var zackPortraitData:Class;
			portraits["zack"] = zackPortraitData;
		
			[Embed(source="../../../data/portraits/chloe-portrait.png")]
			var chloePortraitData:Class;
			portraits["chloe"] = chloePortraitData;
			
			[Embed(source="../../../data/portraits/simon-portrait.png")]
			var simonPortraitData:Class;
			portraits["simon"] = simonPortraitData;
			
			[Embed(source="../../../data/portraits/monica-portrait.png")]
			var monicaPortraitData:Class;
			portraits["monica"] = monicaPortraitData;
			
			[Embed(source="../../../data/portraits/cassandra-portrait.png")]
			var cassandraPortraitData:Class;
			portraits["cassandra"] = cassandraPortraitData;
			
			[Embed(source="../../../data/portraits/oswald-portrait.png")]
			var oswaldPortraitData:Class;
			portraits["oswald"] = oswaldPortraitData;
			
			[Embed(source="../../../data/portraits/gunter-portrait.png")]
			var gunterPortraitData:Class;
			portraits["gunter"] = gunterPortraitData;
			
			[Embed(source="../../../data/portraits/grace-portrait.png")]
			var gracePortraitData:Class;
			portraits["grace"] = gracePortraitData;
			
			[Embed(source="../../../data/portraits/trip-portrait.png")]
			var tripPortraitData:Class;
			portraits["trip"] = tripPortraitData;
			//END PORTRAITS FOR PROM KING
			
			
			//NETWORK ARROWS
			//CHAR HEADS
			[Embed(source="../../../data/icons/charHeads/edward-head.png")]
			var edwardHeadData:Class;
			charHeads["edward"] = edwardHeadData;
			 
			[Embed(source="../../../data/icons/charHeads/zack-head.png")]
			var zackHeadData:Class;
			charHeads["zack"] = zackHeadData;
			
			[Embed(source="../../../data/icons/charHeads/kate-head.png")]
			var kateHeadData:Class;
			charHeads["kate"] = kateHeadData;
			
			[Embed(source="../../../data/icons/charHeads/lucas-head.png")]
			var lucasHeadData:Class;
			charHeads["lucas"] = lucasHeadData;

			[Embed(source="../../../data/icons/charHeads/mave-head.png")]
			var maveHeadData:Class;
			charHeads["mave"] = maveHeadData;

			[Embed(source="../../../data/icons/charHeads/phoebe-head.png")]
			var phoebeHeadData:Class;
			charHeads["phoebe"] = phoebeHeadData;
			
			[Embed(source="../../../data/icons/charHeads/jordan-head.png")]
			var jordanHeadData:Class;
			charHeads["jordan"] = jordanHeadData;
			
			[Embed(source="../../../data/icons/charHeads/doug-head.png")]
			var dougHeadData:Class;
			charHeads["doug"] = dougHeadData;
			
			[Embed(source="../../../data/icons/charHeads/buzz-head.png")]
			var buzzHeadData:Class;
			charHeads["buzz"] = buzzHeadData;
			
			[Embed(source="../../../data/icons/charHeads/naomi-head.png")]
			var naomiHeadData:Class;
			charHeads["naomi"] = naomiHeadData;
			
			[Embed(source="../../../data/icons/charHeads/lil-head.png")]
			var lilHeadData:Class;
			charHeads["lil"] = lilHeadData;
			
			[Embed(source="../../../data/icons/charHeads/nicholas-head.png")]
			var nicholasHeadData:Class;
			charHeads["nicholas"] = nicholasHeadData;
		
			[Embed(source="../../../data/icons/charHeads/chloe-head.png")]
			var chloeHeadData:Class;
			charHeads["chloe"] = chloeHeadData;
			
			[Embed(source="../../../data/icons/charHeads/simon-head.png")]
			var simonHeadData:Class;
			charHeads["simon"] = simonHeadData;
			
			[Embed(source="../../../data/icons/charHeads/monica-head.png")]
			var monicaHeadData:Class;
			charHeads["monica"] = monicaHeadData;
			
			[Embed(source="../../../data/icons/charHeads/cassandra-head.png")]
			var cassandraHeadData:Class;
			charHeads["cassandra"] = cassandraHeadData;
			
			[Embed(source="../../../data/icons/charHeads/oswald-head.png")]
			var oswaldHeadData:Class;
			charHeads["oswald"] = oswaldHeadData;
			
			[Embed(source="../../../data/icons/charHeads/gunter-head.png")]
			var gunterHeadData:Class;
			charHeads["gunter"] = gunterHeadData;
			
			[Embed(source="../../../data/icons/charHeads/grace-head.png")]
			var graceHeadData:Class;
			charHeads["grace"] = graceHeadData;
			
			[Embed(source="../../../data/icons/charHeads/trip-head.png")]
			var tripHeadData:Class;
			charHeads["trip"] = tripHeadData;
			
			//END CHAR_HEADS
			
			[Embed(source = "../../../data/icons/networks/buddy.svg")]
			var buddyArrowData:Class;
			networkArrowIcons["buddy"] = buddyArrowData;	
			
			[Embed(source = "../../../data/icons/networks/buddyUp.svg")]
			var buddyArrowDataUp:Class;
			networkArrowIcons["buddyUp"] = buddyArrowDataUp;

			[Embed(source = "../../../data/icons/networks/buddyDown.svg")]
			var buddyArrowDataDown:Class;
			networkArrowIcons["buddyDown"] = buddyArrowDataDown;
			
			[Embed(source = "../../../data/icons/networks/romance.svg")]
			var romanceArrowData:Class;
			networkArrowIcons["romance"] = romanceArrowData;				
			
			[Embed(source = "../../../data/icons/networks/romanceUp.svg")]
			var romanceArrowDataUp:Class;
			networkArrowIcons["romanceUp"] = romanceArrowDataUp;

			[Embed(source = "../../../data/icons/networks/romanceDown.svg")]
			var romanceArrowDataDown:Class;
			networkArrowIcons["romanceDown"] = romanceArrowDataDown;
			
			[Embed(source = "../../../data/icons/networks/cool.svg")]
			var coolArrowData:Class;
			networkArrowIcons["cool"] = coolArrowData;
			
			[Embed(source = "../../../data/icons/networks/coolUp.svg")]
			var coolArrowDataUp:Class;
			networkArrowIcons["coolUp"] = coolArrowDataUp;

			[Embed(source = "../../../data/icons/networks/coolDown.svg")]
			var coolArrowDataDown:Class;
			networkArrowIcons["coolDown"] = coolArrowDataDown;
			
			
			//LEFT/RIGHT ARROWS FOR SOCIAL CHANGE RECORD
			[Embed(source = "../../../data/icons/leftarrow.svg")]
			var leftArrowData:Class;
			socialChangeRecordArrows["previous"] = leftArrowData;	
			
			[Embed(source = "../../../data/icons/rightarrow.svg")]
			var rightArrowData:Class;
			socialChangeRecordArrows["next"] = rightArrowData;				
			
			[Embed(source = "../../../data/icons/leftarrowgrey.svg")]
			var leftArrowGreyData:Class;
			socialChangeRecordArrows["previousgrey"] = leftArrowGreyData;	
			
			[Embed(source = "../../../data/icons/rightarrowgrey.svg")]
			var rightArrowGreyData:Class;
			socialChangeRecordArrows["nextgrey"] = rightArrowGreyData;	
			
			[Embed(source = "../../../data/icons/relationships/friendsIcon.png")]
			var friendsData:Class;
			relationshipIcons["friends"] = friendsData;
			
			[Embed(source = "../../../data/icons/relationships/notFriendsIcon.png")]
			var notFriendsData:Class;
			relationshipIcons["notFriends"] = notFriendsData;
			
			[Embed(source = "../../../data/icons/relationships/endFriends.png")]
			var endFriendsData:Class;
			relationshipIcons["endFriends"] = endFriendsData;
			
			[Embed(source = "../../../data/icons/relationships/datingIcon.png")]
			var datingData:Class;
			relationshipIcons["dating"] = datingData;
			
			[Embed(source = "../../../data/icons/relationships/notDatingIcon.png")]
			var notDatingData:Class;
			relationshipIcons["notDating"] = notDatingData;
			
			[Embed(source = "../../../data/icons/relationships/endDating.png")]
			var endDatingData:Class;
			relationshipIcons["endDating"] = endDatingData;
			
			[Embed(source = "../../../data/icons/relationships/enemiesIcon.png")]
			var enemiesData:Class;
			relationshipIcons["enemies"] = enemiesData;
			
			[Embed(source = "../../../data/icons/relationships/notEnemiesIcon.png")]
			var notEnemiesData:Class;
			relationshipIcons["notEnemies"] = notEnemiesData;
			
			[Embed(source = "../../../data/icons/relationships/endEnemies.png")]
			var endEnemiesData:Class;
			relationshipIcons["endEnemies"] = endEnemiesData;
            
            // Embed the percentage icons!
            [Embed(source = "../../../data/menus/percentbar-00.png")]
            var percent00:Class;
            percentIcons["00"] = percent00;
            
            [Embed(source = "../../../data/menus/percentbar-10.png")]
            var percent10:Class;
            percentIcons["10"] = percent10;
            
            [Embed(source = "../../../data/menus/percentbar-20.png")]
            var percent20:Class;
            percentIcons["20"] = percent20;
            
            [Embed(source = "../../../data/menus/percentbar-30.png")]
            var percent30:Class;
            percentIcons["30"] = percent30;
            
            [Embed(source = "../../../data/menus/percentbar-40.png")]
            var percent40:Class;
            percentIcons["40"] = percent40;
            
            [Embed(source = "../../../data/menus/percentbar-50.png")]
            var percent50:Class;
            percentIcons["50"] = percent50;
            
            [Embed(source = "../../../data/menus/percentbar-60.png")]
            var percent60:Class;
            percentIcons["60"] = percent60;
            
            [Embed(source = "../../../data/menus/percentbar-70.png")]
            var percent70:Class;
            percentIcons["70"] = percent70;
            
            [Embed(source = "../../../data/menus/percentbar-80.png")]
            var percent80:Class;
            percentIcons["80"] = percent80;
            
            [Embed(source = "../../../data/menus/percentbar-90.png")]
            var percent90:Class;
            percentIcons["90"] = percent90;
            
            [Embed(source = "../../../data/menus/percentbar-100.png")]
            var percent100:Class;
            percentIcons["100"] = percent100;

            [Embed(source = "../../../data/icons/switchUp.png")]
            var switchUp:Class;
            uiIcons["switchUp"] = switchUp;
			
			[Embed(source = "../../../data/icons/switchOver.png")]
            var switchOver:Class;
            uiIcons["switchOver"] = switchOver;
			
			[Embed(source = "../../../data/icons/switchDown.png")]
            var switchDown:Class;
            uiIcons["switchDown"] = switchDown;
			
			[Embed(source = "../../../data/icons/minimizeIcon.png")]
            var minimizeIcon:Class;
            uiIcons["minimize"] = minimizeIcon;
			
            [Embed(source = "../../../data/icons/aaIcon.svg")]
            var aaIcon:Class;
            uiIcons["aaIcon"] = aaIcon;
			
            [Embed(source = "../../../data/icons/star.png")]
            var starIcon:Class;
            uiIcons["star"] = starIcon;
			
            [Embed(source = "../../../data/icons/plusIcon.png")]
            var plusIcon:Class;
            uiIcons["plusIcon"] = plusIcon;
			
            [Embed(source = "../../../data/icons/minusIcon.png")]
            var minusIcon:Class;
            uiIcons["minusIcon"] = minusIcon;
			
            [Embed(source = "../../../data/icons/notificationIcon.png")]
            var notificationIcon:Class;
            uiIcons["notification"] = notificationIcon;

            [Embed(source = "../../../data/icons/farLeftBackground.svg")]
            var farL:Class;
            uiIcons["farLeftBackground"] = farL;
			
            [Embed(source = "../../../data/icons/singleCharIcon.png")]
            var singleCharData:Class;
            uiIcons["singleCharIcon"] = singleCharData;
			
            [Embed(source = "../../../data/icons/twoCharIcon.png")]
            var twoCharData:Class;
            uiIcons["twoCharIcon"] = twoCharData;
			
            [Embed(source = "../../../data/icons/socialState.png")]
            var socialStateIcon:Class;
            uiIcons["socialState"] = socialStateIcon;
			
            [Embed(source = "../../../data/icons/playIcon.png")]
            var playIconData:Class;
            uiIcons["playIcon"] = playIconData;
			
            [Embed(source = "../../../data/icons/wrench.png")]
            var wrenchIconData:Class;
            uiIcons["wrench"] = wrenchIconData; 
			
			[Embed(source = "../../../data/icons/fullScreen.png")]
            var fullScreenData:Class;
            uiIcons["fullScreen"] = fullScreenData;
			
            [Embed(source = "../../../data/icons/plus.png")]
            var zoomInIconData:Class;
            uiIcons["zoomIn"] = zoomInIconData;
			
            [Embed(source = "../../../data/icons/minus.png")]
            var zoomOutIconData:Class;
            uiIcons["zoomOut"] = zoomOutIconData;
			
            [Embed(source = "../../../data/icons/sound.png")]
            var soundIconData:Class;
            uiIcons["sound"] = soundIconData;
			
            [Embed(source = "../../../data/icons/noSound.png")]
            var noSoundIconData:Class;
            uiIcons["noSound"] = noSoundIconData;

            
            [Embed(source = "../../../data/menus/arrow_down.png")]
            var arrowDown:Class;
            uiIcons["arrow_down"] = arrowDown;
            
            [Embed(source = "../../../data/menus/arrow_right.png")]
            var arrowRight:Class;
            uiIcons["arrow_right"] = arrowRight;
            
            [Embed(source = "../../../data/icons/check.png")]
            var check1:Class;
            uiIcons["check"] = check1;

            [Embed(source = "../../../data/icons/blueCheck.png")]
            var bcheck1:Class;
            uiIcons["blueCheck"] = bcheck1;
			
			[Embed(source = "../../../data/icons/cross.png")]
            var cross:Class;
            uiIcons["cross"] = cross;
            
            [Embed(source = "../../../data/icons/thoughtRay.png")]
            var tRay:Class;
            uiIcons["thoughtRay"] = tRay;
			
			[Embed(source = "../../../data/icons/thoughtBubble1.png")]
            var tBub:Class;
            uiIcons["thoughtBubble"] = tBub;
			
			[Embed(source = "../../../data/icons/bigTBub.png")]
            var btBub:Class;
            uiIcons["bigThoughtBubble"] = btBub;
			
			[Embed(source = "../../../data/icons/preresponseInfoTBub.png")]
            var preresponseInfoTBub:Class;
            uiIcons["preresponseInfoTBub"] = preresponseInfoTBub;
			
			[Embed(source = "../../../data/icons/bigTBubStem.png")]
            var btBubStem:Class;
            uiIcons["bigThoughtBubbleStem"] = btBubStem;
			
			[Embed(source = "../../../data/icons/responderBigTBubStem.png")]
            var rbtBubStem:Class;
            uiIcons["responderBigThoughtBubbleStem"] = rbtBubStem;
			
			[Embed(source = "../../../data/icons/juice.png")]
			var juice:Class;
			uiIcons["juice"] = juice;
			
			[Embed(source = "../../../data/icons/lock.png")]
			var lock:Class;
			uiIcons["lock"] = lock;
			
			[Embed(source = "../../../data/icons/phone.png")]
			var phone:Class;
			uiIcons["phone"] = phone;
			
			[Embed(source = "../../../data/icons/arrowUp.png")]
			var aUp:Class;
			uiIcons["arrowUp"] = aUp;
			
			[Embed(source = "../../../data/icons/arrowOver.png")]
			var aOver:Class;
			uiIcons["arrowOver"] = aOver;
			
			[Embed(source = "../../../data/icons/arrowDown.png")]
			var aDown:Class;
			uiIcons["arrowDown"] = aDown;
			
			[Embed(source = "../../../data/icons/sgInfoUp.png")]
			var sgInfoUp:Class;
			uiIcons["sgInfoUp"] = sgInfoUp;
			
			[Embed(source = "../../../data/icons/sgInfoOver.png")]
			var sgInfoOver:Class;
			uiIcons["sgInfoOver"] = sgInfoOver;
			
			[Embed(source = "../../../data/icons/sgInfoDown.png")]
			var sgInfoDown:Class;
			uiIcons["sgInfoDown"] = sgInfoDown;
			
			[Embed(source = "../../../data/icons/sgResponseUp.png")]
			var sgResponseUp:Class;
			uiIcons["sgResponseUp"] = sgResponseUp;
			
			[Embed(source = "../../../data/icons/sgResponseOver.png")]
			var sgResponseOver:Class;
			uiIcons["sgResponseOver"] = sgResponseOver;
			
			[Embed(source = "../../../data/icons/sgResponseDown.png")]
			var sgResponseDown:Class;
			uiIcons["sgResponseDown"] = sgResponseDown;
			
			[Embed(source = "../../../data/icons/history.png")]
			var history:Class;
			uiIcons["history"] = history;
			
			[Embed(source = "../../../data/icons/miniMapIcon.png")]
			var miniMapIcon:Class;
			uiIcons["miniMapIcon"] = miniMapIcon;

			[Embed(source = "../../../data/menus/tutorialFilter.png")]
			var tutorialFilter:Class;
			uiIcons["tutorialFilter"] = tutorialFilter;			
			
			[Embed(source = "../../../data/menus/tutorialFilterShort.png")]
			var tutorialFilterShort:Class;
			uiIcons["tutorialFilterShort"] = tutorialFilterShort;			
			
			[Embed(source = "../../../data/menus/tutorialFilterSmall.png")]
			var tutorialFilterSmall:Class;
			uiIcons["tutorialFilterSmall"] = tutorialFilterSmall;		
			
			[Embed(source = "../../../data/menus/characterFilter.png")]
			var characterFilter:Class;
			uiIcons["characterFilter"] = characterFilter;		
			
			[Embed(source = "../../../data/icons/relationshipIcon.png")]
			var relationshipIcon:Class;
			uiIcons["relationshipIcon"] = relationshipIcon;
			
            [Embed(source = "../../../data/icons/mousegrabber.png")]
            var mouseGrab:Class;
            uiIcons["mouse_grab"] = mouseGrab;
			
            [Embed(source = "../../../data/icons/twitterT.png")]
            var twitterT:Class;
            uiIcons["twitter"] = twitterT;
			
            [Embed(source = "../../../data/icons/facebookIcon.png")]
            var facebookIcon:Class;
            uiIcons["facebook"] = facebookIcon;
			
			
			//Tutorial Screenshots
			[Embed(source = "../../../data/tutorialScreenshots/MegaUI.png")]
            var megaUItutorial:Class;
            tutorialScreenshots["MegaUI"] = megaUItutorial;
			
			[Embed(source = "../../../data/tutorialScreenshots/SocialGame.png")]
            var socialGameTutorial:Class;
            tutorialScreenshots["SocialGame"] = socialGameTutorial;

			/*
			[Embed(source = "../../../data/tutorialScreenshots/ZackAndChloeCloseUp.png")]
            var gameplayBasicsTutorial:Class;
            tutorialScreenshots["gameplayBasicsOLD"] = gameplayBasicsTutorial;
			*/
			
			[Embed(source = "../../../data/tutorialScreenshots/ZackAndChloeCloseUpTwo.png")]
            var gameplayBasicsTutorial:Class;
            tutorialScreenshots["gameplayBasics"] = gameplayBasicsTutorial;

			
            //[Embed(source = "../../../data/icons/lock.png")]
            //var myLock:Class;
            //uiIcons["lock"] = myLock
			
			
			// Stuff for the AutonomousActionNotifier
			uiIcons["aan_emphasizer"] = new _emphasizer() as UIMovieClip;
			
			[Embed(source = "../../../data/icons/AutonomousActionNotifier.svg")]
			var exclamationPt:Class;
			uiIcons["exclamationPt"] = exclamationPt
			
			
		}
		
        private function adjustSize(movee:DisplayObjectContainer):void {
            movee.x -= movee.x
            movee.y -= movee.y
            //changeRegPt(movee,dx,dy)
        }
        
		/** 
		 * replaces all of the components of the skeleton with the skin's
		 */
        public function setupSkin(char:String):void{
        var skin:UIMovieClip
            switch(char) {
				case "buzz":
					skin = new buzz_skin()
					break;
				case "buzzProm":
					skin = new buzz_prom_skin()
					break;
				case "cassandra":
					skin = new cassandra_skin()
					break;
				case "cassandraProm":
					skin = new cassandra_prom_skin()
					break;
				case "chloe":
					skin = new chloe_skin()
					break;
				case "chloeProm":
					skin = new chloe_prom_skin()
					break;
				case "doug":
					skin = new doug_skin()
					break;
				case "dougProm":
					skin = new doug_prom_skin()
					break;
				case "edward":
					skin = new edward_skin()
					break;
				case "edwardProm":
					skin = new edward_prom_skin()
					break;
				case "gunter":
					skin = new gunter_skin()
					break;
				case "gunterProm":
					skin = new gunter_prom_skin()
					break;
				case "jordan":
					skin = new jordan_skin()
					break;
				case "jordanProm":
					skin = new jordan_prom_skin()
					break;
				case "kate":
					skin = new kate_skin()
					break;
				case "kateProm":
					skin = new kate_prom_skin()
					break;
				case "lil":
					skin = new lil_skin()
					break;
				case "lilProm":
					skin = new lil_prom_skin()
					break;
				case "lucas":
					skin = new lucas_skin()
					break;
				case "lucasProm":
					skin = new lucas_prom_skin()
					break;
				case "mave":
					skin = new mave_skin()
					break;
				case "maveProm":
					skin = new mave_prom_skin()
					break;
				case "monica":
					skin = new monica_skin()
					break;
				case "monicaProm":
					skin = new monica_prom_skin()
					break;
				case "naomi":
					skin = new naomi_skin()
					break;
				case "naomiProm":
					skin = new naomi_prom_skin()
					break;
				case "nicholas":
					skin = new nicholas_skin()
					break;
				case "nicholasProm":
					skin = new nicholas_prom_skin()
					break;
				case "oswald":
					skin = new oswald_skin()
					break;
				case "oswaldProm":
					skin = new oswald_prom_skin()
					break;
				case "phoebe":
					skin = new phoebe_skin()
					break;
				case "phoebeProm":
					skin = new phoebe_prom_skin()
					break;
				case "simon":
					skin = new simon_skin()
					break;
				case "simonProm":
					skin = new simon_prom_skin()
					break;
				case "zack":
					skin = new zack_skin()
					break;
				case "zackProm":
					skin = new zack_prom_skin()
					break;
				case "grace":
					skin = new grace_skin()
					break;
				case "trip":
					skin = new trip_skin()
					break;
                default:
                    Debug.debug(this,"Incorrect argument for setupSkin!")
            }
            characterClips[char].leftLeg.addChild(skin.leftLeg)
			adjustSize(skin.leftLeg)
			characterClips[char].rightLeg.addChild(skin.rightLeg)
			adjustSize(skin.rightLeg)
			characterClips[char].body.addChild(skin.body)
			adjustSize(skin.body)
			characterClips[char].rightLowerArm.addChild(skin.rightLowerArm)
			adjustSize(skin.rightLowerArm)
			characterClips[char].rightUpperArm.addChild(skin.rightUpperArm)
			adjustSize(skin.rightUpperArm)
			characterClips[char].leftLowerArm.addChild(skin.leftLowerArm)
			adjustSize(skin.leftLowerArm)
			characterClips[char].leftUpperArm.addChild(skin.leftUpperArm)
			adjustSize(skin.leftUpperArm)
			if(skin.hairBack){
                characterClips[char].hairBack.addChild(skin.hairBack)
                adjustSize(skin.hairBack)
            }
            if(skin.hair){
                characterClips[char].hair.addChild(skin.hair)
                adjustSize(skin.hair)
            }
			characterClips[char].head.addChild(skin.head)
			adjustSize(skin.head)
			characterClips[char].faceMC.addChild(skin.faceMC)
			adjustSize(skin.faceMC)
            //characterClips[char].faceMC.rEye.addChild(skin.faceMC.rEye)
			//adjustSize(skin.faceMC.rEye)
			//characterClips[char].faceMC.lEye.addChild(skin.faceMC.lEye)
			//adjustSize(skin.faceMC.lEye)
			//characterClips[char].faceMC.lPupil.addChild(skin.faceMC.lPupil)
			//adjustSize(skin.faceMC.lPupil)
			//characterClips[char].faceMC.rPupil.addChild(skin.faceMC.rPupil)
			//adjustSize(skin.faceMC.rPupil)
			//characterClips[char].faceMC.rBrow.addChild(skin.faceMC.rBrow)
			//adjustSize(skin.faceMC.rBrow)
			//characterClips[char].faceMC.lBrow.addChild(skin.faceMC.lBrow)
			//adjustSize(skin.faceMC.lBrow)
			//characterClips[char].faceMC.mouth.addChild(skin.faceMC.mouth)
			//adjustSize(skin.faceMC.mouth)
        }
		
		public function getRelationshipIcon(type:String):UIMovieClip
		{
			switch(type)
			{
				case "friends":
					return new friendsAnimation() as UIMovieClip;
					//return new DatingAnimation() as UIMovieClip;
					break;
				case "friendsEnd":
					return new friendEndAnim() as UIMovieClip;
					break;
				case "dating":
					return new datingAnim() as UIMovieClip;
					break;
				case "datingEnd":
					return new datingEndAnim() as UIMovieClip;
					break;
				case "enemies":
					return new enemyAnim() as UIMovieClip;
					break;
				case "enemiesEnd":
					return new enemiesEndAnimation() as UIMovieClip;
					break;
				default:
					//this is bad and icky
					return new friendsAnimation() as UIMovieClip;
			}
		}
		/*
		/*public function getSubjectiveChangeAnimation(type:String):UIMovieClip
		{
			if (type == "bud_up")
			{
				return new greenUp3() as UIMovieClip;
			}
			else if (type == "bud_down")
			{
				return new greenDown3() as UIMovieClip;
			}
			else if (type == "rom_up")
			{
				return new redUp3() as UIMovieClip;
			}
			else if (type == "rom_down")
			{
				return new redDown3() as UIMovieClip;
			}
			else if (type == "cool_up")
			{
				return new blueUp3() as UIMovieClip;
			}
			else if (type == "cool_down")
			{
				return new blueDown3() as UIMovieClip;
			}
			return null;
		}*/
		
		public static function getInstance():ResourceLibrary
		{
			return _instance;
		}
	}
}