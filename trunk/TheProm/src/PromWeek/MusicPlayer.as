package PromWeek 
{
	import CiF.Debug;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	import PromWeek.assets.ResourceLibrary;
	import PromWeek.assets.SoundLibrary;
	/**
	 * A singleton that contorls the background music.
	 * 
	 * 
	 * To play music, use the playMusic() with with one of the music constance of this class:
	 * MusicPlayer.playMusic(MusicPlayer.TITLE)
	 * 
	 * To make music loop:
	 * MusicPlayer.loop = true;
	 * 
	 * To change volume:
	 * MusicPlayer.
	 * 
	 * @author Josh McCoy
	 */
	public class MusicPlayer
	{
		private static var _instance:MusicPlayer = new MusicPlayer();
		
		private var musicLibrary:Dictionary;
		
		private var soundChannel:SoundChannel;
		private var sound:Sound;
		private var soundTransform:SoundTransform;
		
		private var currentMusicName:String;
		private var _volume:Number;
		public var musicOffsets:Dictionary;

		private static var _loop:Boolean=true;
		private static var _isPlaying:Boolean;
		
		private static var _isMuted:Boolean = false;
		
		//volume settings
		public static const HIGH_VOLUME:Number = 0.75;
		public static const LOW_VOLUME:Number = 0.20;
		
		public static const FADE_DURATION:Number = 4.0;
		public static const TITLE_REPLAY_OFFSET:Number = 3000;
		
		
		//The tracks
		public static const GAMEPLAY:String = "gameplay";
		public static const TITLE:String = "title";
		public static const LEVEL:String = "level";
		public static const STORY:String = "story";
		public static const PROM:String = "prom";
		
		public function MusicPlayer() 
		{
			if (_instance != null) {
				throw new Error("MusicPlayer (Constructor): " + "Cast can only be accessed through MusicPlayer.getInstance()");
			}
			//this.musicLibrary = new Dictionary();
			this.musicOffsets= new Dictionary();
			_loop = true;
			_isPlaying = true;
			this._volume = HIGH_VOLUME;
			this.currentMusicName = "";
			this.soundTransform = new SoundTransform(this._volume);
		}
		
		public static function getInstance():MusicPlayer {
			return _instance;
		}
		
		/**
		 * Binds the music assets in the resource library to the MusicPlayer.
		 */
		public static function init():void {
			var sl:SoundLibrary = SoundLibrary.getInstance()
			var mp:MusicPlayer = getInstance()
			mp.musicLibrary = new Dictionary()
			//mp.musicOffsets = new Dictionary()
			
			mp.musicLibrary[TITLE] = new sl.music["title"]() as Sound;
			mp.musicLibrary[GAMEPLAY] = new sl.music[("gameplay" + Utility.randRange(1,sl.numGameplaySongs).toString())]() as Sound;
			mp.musicLibrary[LEVEL] = new sl.music["level"]() as Sound;
			mp.musicLibrary[STORY] = new sl.music["level"]() as Sound; // "level" is intentional -- same track for both!
			
			//offsets
			mp.musicOffsets[TITLE] = 0.0;
			mp.musicOffsets[GAMEPLAY] = 0.0;
			mp.musicOffsets[PROM] = 0.0;
			mp.musicOffsets[LEVEL] = 0.0;
			mp.musicOffsets[STORY] = 0.0;
		}
		
		public static function setToRandomGameplaySong():void
		{
			var sl:SoundLibrary = SoundLibrary.getInstance()
			var mp:MusicPlayer = getInstance()
			mp.musicLibrary[GAMEPLAY] = new sl.music[("gameplay" + Utility.randRange(1,sl.numGameplaySongs).toString())]() as Sound;
		}

		public static function setToRandomPromSong():void
		{
			var sl:SoundLibrary = SoundLibrary.getInstance()
			var mp:MusicPlayer = getInstance()
			mp.musicLibrary[PROM] = new sl.music["prom"]() as Sound;
		}
		
		/**
		 * Starts playing music.
		 * @param	musicName	One of the consts of this class representing the music to play.
		 */
		public static function playMusic(musicName:String = GAMEPLAY):void {
			var mp:MusicPlayer = getInstance()
			
			if (!mp.musicLibrary) init();
			
			if (musicName == GAMEPLAY)
			{
				MusicPlayer.setToRandomGameplaySong();
			}
			else if (musicName == PROM)
			{
				MusicPlayer.setToRandomPromSong();
			}
			
			mp.sound = mp.musicLibrary[musicName] as Sound;
			if (!mp.sound) {
				Debug.debug(MusicPlayer, "playMusic() music was not found in the music dictionary: " + musicName + " " + mp.musicLibrary[musicName]);
				Utility.log(MusicPlayer, "playMusic() music was not found in the music dictionary: " + musicName+ " " + mp.musicLibrary[musicName]);
				return;
			}
			
			//if not already playing the desired music
			if (mp.currentMusicName != musicName) {
				mp.currentMusicName = musicName;
				mp.refreshSoundChannel();
			}
		}
		
		/**
		 * Resfreshes the music being played to reflect the state of the MusicPlayer. Volume, play/stop,
		 * and looping are all reflected.
		 */
		private function refreshSoundChannel():void {
			var mp:MusicPlayer = getInstance()
			if(mp.soundChannel) {
				mp.soundChannel.removeEventListener(Event.SOUND_COMPLETE, mp.onPlaybackComplete);
				mp.soundChannel.stop();
			}
			if(isPlaying) {
				mp.soundChannel = mp.sound.play(this.musicOffsets[this.currentMusicName],0,mp.soundTransform);
				mp.soundChannel.addEventListener(Event.SOUND_COMPLETE, mp.onPlaybackComplete);
				mp.soundChannel.soundTransform.volume = mp._volume;
			}else {
				
			}
		}
		
		/**
		 * The callback for when the sound channel has finished playing a sound.
		 * @param	e
		 */
		private function onPlaybackComplete(e:Event):void {
			
			if (MusicPlayer.loop) {
				//Debug.debug(this, "onPlaybackComplete() looping!");
				//Utility.log(this, "onPlaybackComplete() looping!");
				refreshSoundChannel()
			}
		}
		
		public static function set loop(b:Boolean):void {
			_loop = b;
			getInstance().refreshSoundChannel();
		}
		
		public static function get loop():Boolean {
			return _loop
		}
		
		public static function set isPlaying(b:Boolean):void {
			_isPlaying = b
			
			getInstance().refreshSoundChannel()
		}
		
		public static function get isPlaying():Boolean {
			return _isPlaying
		}
		
		public static function set isMuted(b:Boolean):void {
			_isMuted = b;
			if (_isMuted) {
				getInstance().soundTransform.volume = 0.0;
				getInstance().soundChannel.soundTransform = getInstance().soundTransform;
			}else {
				volume = volume;
			}
		}
		
		public static function get isMuted():Boolean {
			return _isMuted
		}
		
		public static function set volume(v:Number):void {
			//Utility.log(MusicPlayer, "set volume() volume was: " + getInstance()._volume + " and is being set to: " + v);
			getInstance()._volume = v;
			if(isPlaying && !_isMuted) {
				getInstance().soundTransform.volume = v;
				getInstance().soundChannel.soundTransform = getInstance().soundTransform;
			}
		}
		
		public static function get volume():Number {
			return getInstance()._volume;
		}

	}

}