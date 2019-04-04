/********************************************************************************************
   KeyManagerEvent

   Author:			Keith Hair
   Date:			Feburary-19-2011
   Updated:			March-2-2011
   Email:			khos2007@gmail.com
   Website:			http://keith-hair.net
   Version:			1.0.1
   License:			Creative Commons http://creativecommons.org/licenses/by/3.0/
   Description:   
   KeyManagerEvent is dispatched by net.keithhair.managers.KeyManager class.
 */
package com.keithhair.managers
{
	import flash.events.Event;

	public class KeyManagerEvent extends Event
	{
		/**
		 * Type dispatched when user presses all keys included in "keyCombo" parameter
		 * of net.keithhair.managers.KeyManager "addKey" or "addKeySequence" methods.
		 */
		public static const KEY_DOWN:String="keyDown";
		
		/**
		 * Type dispatched when a previous "keyCombo" is no longer held down.  
		 */		
		public static const KEY_UP:String="keyUp";
		
		/**
		 * Type dispatched when a sequence of keys is pressed in the order they where given in a "addKeySequence" method.  
		 */		
		public static const KEY_SEQUENCE:String="keySequence";		



		private var _startFunc:Function;
		private var _endFunc:Function;
		private var _keyCombo:Array;
		private var _id:String="";

		public function KeyManagerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id=value;
		}		
		/**
		 * @return Reference to the "endFunc" function if one was added with
		 * the KeyManager's addKey or addKeySequence methods.  
		 **/
		public function get endFunc():Function
		{
			return _endFunc;
		}

		public function set endFunc(value:Function):void
		{
			_endFunc=value;
		}

		/**
		 * @return Reference to the "startFunc" function if one was added with
		 * the KeyManager's addKey or addKeySequence methods.  
		 **/		
		public function get startFunc():Function
		{
			return _startFunc;
		}

		public function set startFunc(value:Function):void
		{
			_startFunc=value;
		}

		/**
		 * @return Reference to the "keyCombo" Array added with
		 * the KeyManager's addKey or addKeySequence methods.  
		 **/		
		public function get keyCombo():Array
		{
			return _keyCombo || [];
		}

		public function set keyCombo(value:Array):void
		{
			_keyCombo=value;
		}
		
		/**
		 * @return A copy of this KeyManagerEvent.
		 **/ 
		override public function clone():Event
		{
			var kevt:KeyManagerEvent=new KeyManagerEvent(type, bubbles, cancelable);
			kevt.keyCombo=_keyCombo;
			kevt.startFunc=_startFunc;
			kevt.endFunc=_endFunc;
			kevt.id=_id;
			return kevt;
		}
	}
}