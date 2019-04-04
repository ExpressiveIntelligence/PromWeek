package PromWeek.assets 
{
	import flash.media.Sound;
	import flash.utils.Dictionary;

	
	/**
	 * ...
	 * @author Mike Treanor
	 */
	public class SoundLibrary
	{
		private static var _instance:SoundLibrary = new SoundLibrary();
		
		public var maleUtterances:Dictionary;
		public var femaleUtterances:Dictionary;
		public var uiSounds:Dictionary;
		public var socialStateSounds:Dictionary;
		public var music:Dictionary;
		
		
		public var numGameplaySongs:int = 0;
		
		public function SoundLibrary() 
		{
			if (_instance != null)
			{
				throw new Error("There can only be one SoundLibrary and one already exists.");
			}
			
			maleUtterances = new Dictionary();
			femaleUtterances = new Dictionary();
			uiSounds = new Dictionary();
			socialStateSounds = new Dictionary();
			music = new Dictionary();
			

			initializeResources();
		}
		
		public function initializeResources():void
		{
			//male utterances loaded in
			/* Begin removal of utterances.
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_angry.mp3")]
			var angrySound:Class;
			maleUtterances["angry"] = angrySound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_anxious.mp3")]
			var anxiousSound:Class;
			maleUtterances["anxious"] = anxiousSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_concerned.mp3")]
			var concernedSound:Class;
			maleUtterances["concerned"] = concernedSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_disinterested.mp3")]
			var disinterestedSound:Class;
			maleUtterances["disinterested"] = disinterestedSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_happy.mp3")]
			var happySound:Class;
			maleUtterances["happy"] = happySound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_idle.mp3")]
			var idleSound:Class;
			maleUtterances["idle"] = idleSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_resentful.mp3")]
			var resentfulSound:Class;
			maleUtterances["resentful"] = resentfulSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_romantic.mp3")]
			var romanticSound:Class;
			maleUtterances["romantic"] = romanticSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_sad.mp3")]
			var sadSound:Class;
			maleUtterances["sad"] = sadSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_veryhappy.mp3")]
			var veryHappySound:Class;
			maleUtterances["veryHappy"] = veryHappySound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/male_verysad.mp3")]
			var verySadSound:Class;
			maleUtterances["verySad"] = verySadSound;
			
			//female utterances loaded in
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_angry.mp3")]
			var f_angrySound:Class;
			femaleUtterances["angry"] = f_angrySound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_anxious.mp3")]
			var f_anxiousSound:Class;
			femaleUtterances["anxious"] = f_anxiousSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_concerned.mp3")]
			var f_concernedSound:Class;
			femaleUtterances["concerned"] = f_concernedSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_disinterested.mp3")]
			var f_disinterestedSound:Class;
			femaleUtterances["disinterested"] = f_disinterestedSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_happy.mp3")]
			var f_happySound:Class;
			femaleUtterances["happy"] = f_happySound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_idle.mp3")]
			var f_idleSound:Class;
			femaleUtterances["idle"] = f_idleSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_resentful.mp3")]
			var f_resentfulSound:Class;
			femaleUtterances["resentful"] = f_resentfulSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_romantic.mp3")]
			var f_romanticSound:Class;
			femaleUtterances["romantic"] = f_romanticSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_sad.mp3")]
			var f_sadSound:Class;
			femaleUtterances["sad"] = f_sadSound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_veryhappy.mp3")]
			var f_veryHappySound:Class;
			femaleUtterances["veryHappy"] = f_veryHappySound;
			
			[Embed(source = "../../../data/soundFX/emotionalUtterances/female_verysad.mp3")]
			var f_verySadSound:Class;
			femaleUtterances["verySad"] = f_verySadSound;
			End removal of utterances*/
			
			//social state sounds loaded
			[Embed(source = "../../../data/soundFX/socialStateSounds/cool_up.mp3")]
			var cool_up:Class;
			socialStateSounds["cool_up"] = cool_up;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/cool_down.mp3")]
			var cool_down:Class;
			socialStateSounds["cool_down"] = cool_down;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/dating_begin.mp3")]
			var dating_begin:Class;
			socialStateSounds["dating_begin"] = dating_begin;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/dating_end.mp3")]
			var dating_end:Class;
			socialStateSounds["dating_end"] = dating_end;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/enemies_begin.mp3")]
			var enemies_begin:Class;
			socialStateSounds["enemies_begin"] = enemies_begin;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/enemies_end.mp3")]
			var enemies_end:Class;
			socialStateSounds["enemies_end"] = enemies_end;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/friends_begin.mp3")]
			var friends_begin:Class;
			socialStateSounds["friends_begin"] = friends_begin;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/friends_end.mp3")]
			var friends_end:Class;
			socialStateSounds["friends_end"] = friends_end;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/buddy_down.mp3")]
			var buddy_down:Class;
			socialStateSounds["buddy_down"] = buddy_down;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/buddy_up.mp3")]
			var buddy_up:Class;
			socialStateSounds["buddy_up"] = buddy_up;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/romance_down.mp3")]
			var romance_down:Class;
			socialStateSounds["romance_down"] = romance_down;
			
			[Embed(source = "../../../data/soundFX/socialStateSounds/romance_up.mp3")]
			var romance_up:Class;
			socialStateSounds["romance_up"] = romance_up;
			
			//ui sounds loaded
			[Embed(source = "../../../data/soundFX/uiSounds/coin-drop-4-Lower-Sample-Rate.mp3")]
			var juiceUnlocked:Class;
			uiSounds["juice_unlocked"] = juiceUnlocked;
			
			/**
			 * Backgroud music
			 */
			[Embed(source = "../../../data/soundFX/music/gameplay1.mp3")]
			var gameplayMusic1:Class;
			music["gameplay1"] = gameplayMusic1;
			numGameplaySongs++;
			
			[Embed(source = "../../../data/soundFX/music/gameplay2.mp3")]
			var gameplayMusic2:Class;
			music["gameplay2"] = gameplayMusic2;
			numGameplaySongs++;
			
			[Embed(source = "../../../data/soundFX/music/gameplay3.mp3")]
			var gameplayMusic3:Class;
			music["gameplay3"] = gameplayMusic3;
			numGameplaySongs++;
			
			[Embed(source = "../../../data/soundFX/music/title.mp3")]
			var titleMusic:Class;
			music["title"] = titleMusic;
			
			[Embed(source = "../../../data/soundFX/music/level.mp3")]
			var levelMusic:Class;
			music["level"] = levelMusic;
			
			[Embed(source = "../../../data/soundFX/music/promLevel.mp3")]
			var promMusic:Class;
			music["prom"] = promMusic;
		}
		

		
		public static function getInstance():SoundLibrary
		{
			return _instance;
		}
	}
}