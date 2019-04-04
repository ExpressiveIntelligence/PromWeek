/********************************************************************************************
   KeyManager

   Author:            Keith Hair
   Date:            Feburary-13-2010
   Updated:            March-2-2011
   Email:            khos2007@gmail.com
   Website:            http://keith-hair.net
   Version:            1.0.1
   License:            Creative Commons http://creativecommons.org/licenses/by/3.0/
   Description:
   A class for setting functions to execute for assigned key combinations or key sequences.
   A KeyManagerEvent is dispatched from this class to help monitor keyboard interactivity.
   The KeyManagerEvent is only dispatched for keys used by addKey or addKeySequence methods.

   Changes:
   *Feb-19-2011
    - Function Keys F1 through F12 are supported except F10.
    - Break/Pause Key is detected but KeyManager will not respond to it as expected when adding this key.
    - Keys not supported:
     F10,Print Screen,Alt/Option,Windows Key.
    -New public methods added:
     capsLock():Boolean
     shiftKeyDown():Boolean
     ctrlKeyDown():Boolean
     commandKeyDown():Boolean //Mac only.
     altKeyDown():Boolean //Only works on Adobe AIR.
    -Now dispatches a KeyManagerEvent for when assigned keys are pressed and release.
   *Mar-1-2011
    -Key Combos are recognized regardless of order.
    -Dispatches a KeyManagerEvent.KEY_DOWN at the moment all assigned keys of a combos are completed on key press.
    -Dispatches a KeyManagerEvent.KEY_UP at the moment any assigned keys combos are incomplete on key release.
    -Dispatches a KeyManagerEvent.KEY_SEQUENCE when a sequence of keys are presse in order.
   Example Usage of KeyManager:

   //------------------------------------------------------------------------------------------------------
   //Define a KeyManager instance, giving it a stage for the class to internally assign KeyboardEvent listeners to.
   //------------------------------------------------------------------------------------------------------
   var keyManager:KeyManager=new KeyManager(stage);

   //---------------------------------------------------------
   //Sets up control where the shift key and right arrow key must be pressed together to execute "goRight"
   //"stopRight" will execute when this key combination is no longer pressed.
   //----------------------------------------------------------
   keyManager.addKey(["shift","right"], goRight,stopRight);

   //----------------------------------------------------------------
   //"openEasterEgg" will execute if all of the keys in the Array are pressed in sequence.
   //-----------------------------------------------------------------
   keyManager.addKeySequence(["up","up","down","down","left","right","left","right"],openEasterEgg);

   //----------------------------------------------------------------
   //You can add handlers for KEY_DOWN or KEY_UP events.
   //(These only execute for keys assigned for your KeyManager instance)
   //-----------------------------------------------------------------
   keyManager.addEventListener(KeyManagerEvent.KEY_DOWN, onKeyDownListener);
   keyManager.addEventListener(KeyManagerEvent.KEY_UP, onKeyUpListener);

   * Note 1:
   I recommend you use the keycode constants of the Keyboard class, although
   the "addKey/addKeySequence" methods will attempt a lexical match to the relevant keycode.
   For example, Number "1" key is different from "Number Pad 1" key. (Keyboard.NUMBER_1 vs Keyboard.NUMPAD_1)
   or ("1" vs "numpad1").

   Note 2:
   For Flash AS3 only projects, it's best to use the main "stage" as the host parameter in KeyManager constructor.
   Also if using in Flex, I recommend using the application's stage as the host parameter.
 **********************************************************************************************/
package net.keithhair.managers
{
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.events.KeyboardEvent;
    import flash.ui.Keyboard;
    import mx.controls.Alert;

    public class KeyManager extends EventDispatcher
    {
        private var _host:IEventDispatcher;
        private var _keys:Object;
        private var _pressed:Object;
        private var _seq:Array;
        private var _seqlimit:int=0;
        private var _seqstr:String="";
        private var _hasseq:Boolean=false;
        private var _kevt:KeyboardEvent;
        private var _lastFCall:Function=null;
        private var _lastKC:Object;

        /**
         *@param host This is an Object that implements IEventDispatcher.
         *"host" is an object that KeyboardEvent listeners will be automatically added to.
         **/
        public function KeyManager(host:IEventDispatcher)
        {
            _kevt=new KeyboardEvent(KeyboardEvent.KEY_DOWN);
            _keys={};
            _pressed={};
            _seq=[];
            _host=host;
            addListeners();
        }

        /**
         * @param    keycombo The combination of keys as an Array. If key in the keycombo is a String, this method will attempt to find the lexical keycode match, but it is recommnded you use strict keycodes from the Keyboard class constants.
         * @param    startFunc The start Function to execute when all of the keys in the keycombo Array are pressed.
         * @param    endFunc The end Function to execute when the current key combination is no longer complete.
         * @param    id A String to make storage of each key combination unique. If an "id" is not given, the id will automatically be set to the current number of keycombos added with addKey.
         * @param    singular If true, this keycombo will cancel execution of other keycombos and execute alone. If false, this keycombo will execute along with other keycombo's pressed.
         * @return    true if the key id has not been added before, false if the id is already added.
         *
         * Note:
         * -String entries are case insensitive purposely.
         **/
        public function addKey(keycombo:Array, startFunc:Function=null, endFunc:Function=null, id:String="", singular:Boolean=true):Boolean
        {
            //-----------------------------------------------------------------------------------
            //formatKeyArray will find the lexical keycode match of each in the key combination.
            //-----------------------------------------------------------------------------------
            var a:Array=formatKeyArray(keycombo);
            //-------------------------------------------
            //Set default unique id if one is not given.
            //-------------------------------------------
            id=id || getTotalKeys().toString();
            //-----------------------------------
            //Prevent same key id from being adding 
            //----------------------------------
            if (getKeyByID(id) != null)
            {
                return false;
            }
            _keys[id]={keys: a, startfunc: startFunc, endfunc: endFunc, id: id, singular: singular};
            return true;
        }

        /**
         *
         * @param    keyseq The sequence of keys to press to execute the given Function in "func".
         * @param    func The function to execute a sequence of key presses match "keyseq"
         * @param    id A String to make storage of each key combination unique. If an "id" is not given, the id will automatically be set to the current number of keycombos added with addKeySequence.
         * @return    true if the key id has not been added before, false if the id is already added.
         */
        public function addKeySequence(keyseq:Array, func:Function=null, id:String=""):Boolean
        {
            //-----------------------------------------------------------------------------------
            //formatKeyArray will find the lexical keycode match of each in the key in the sequence.
            //-----------------------------------------------------------------------------------            
            var a:Array=formatKeyArray(keyseq);
            //-------------------------------------------
            //Set default unique id if one is not given.
            //-------------------------------------------
            id=id || getTotalKeys().toString();
            //-----------------------------------
            //Prevent same key id from being adding 
            //----------------------------------
            if (getKeyByID(id) != null)
            {
                return false;
            }
            _hasseq=true;
            _seqlimit=Math.max(_seqlimit, a.length);
            _keys[id]={keys: a, startfunc: func, id: id, isSeq: true};
            return true;
        }

        /**
         * @param    id The id used in add the key combination with "addKey".
         * @return    True if the id existed and was removed. False, if the id does not exist.
         **/
        public function removeKey(id:String):Boolean
        {
            if (getKeyByID(id) == null)
            {
                return false;
            }
            delete _keys[id];
            var ko:Object;
            var i:int=0;
            for each (ko in _keys)
            {
                if (ko.isSeq)
                {
                    i++;
                    break;
                }
            }
            _hasseq=i > 0;
            return true;
        }

        /**
         *Clears all key combination added with "addKey".
         **/
        public function removeAllKeys():void
        {
            _keys={};
            _seqlimit=0;
        }

        /**
         *This is the disposal method that should be called before clearing references to this class's instances.
         **/
        public function remove():void
        {
            removeAllKeys();
            processKeysUp();
            removeListeners();
            _pressed={};
            _seq=[]
            _host=null;
            _hasseq=false;
            _seqstr="";
            _kevt=null;
        }

        /**
         * @return Array of all key codes currently held down.
         **/
        public function getKeysCodesDown():Array
        {
            var a:Array=[];
            var p:*;
            for (p in _pressed)
            {
                a.push(p);
            }
            return a;
        }

        /**
         * @return    true if Shift key is currently held down.
         **/
        public function shiftKeyDown():Boolean
        {
            return _kevt.shiftKey;
        }

        /**
         * @return    true if Alt (on Win) or Option (on Mac) key is currently held down.
         * Only works in Adobe AIR.
         **/
        public function altKeyDown():Boolean
        {
            return _kevt.altKey;
        }

        /**
         * @return    true if Control key is currently held down.
         **/
        public function ctrlKeyDown():Boolean
        {
            return _kevt.ctrlKey;
        }

        /**
         * @return    true if Caps Lock is currently active, whether it held down or not.
         **/
        public function capsLock():Boolean
        {
            return Keyboard.capsLock;
        }

        /** Mac only.
         * @return    true if Command Key is currently held down.
         **/
        public function commandKeyDown():Boolean
        {
            if (_kevt.hasOwnProperty("commandKey"))
            {
                return _kevt["commandKey"];
            }
            return false;
        }

        /**
         * @param    id The String used to uniquely name a key combination with "addKey"
         * @return    An Object containing the given id.
         **/
        private function getKeyByID(id:String):Object
        {
            return _keys[id];
        }

        private function __onKeyDown(evt:KeyboardEvent):void
        {
            var k:int=evt.keyCode;
            _kevt=evt;
            //-------------------------------------------------
            //Dont process keys that are already detected down.
            //-------------------------------------------------            
            if (_pressed[k] != null)
            {
                return;
            }
            _pressed[k]=true;
            if (_hasseq)
            {
                _seq.push(k);
                _seqstr=_seq.toString();
                //-------------------------------------------------------------------------
                //Shave off beginning element each time number of key presses grow larger
                //length of largest sequence...helps conserve memory.
                //-------------------------------------------------------------------------
                if (_seq.length > _seqlimit)
                {
                    _seq.shift();
                }
            }
            processKeysDown(false, false, k);
        }

        private function __onKeyUp(evt:KeyboardEvent):void
        {
            evt.updateAfterEvent();
            //-------------------------------------------------
            //Unmark any key to be detected as released.
            //-------------------------------------------------            
            var k:int=evt.keyCode;
            delete _pressed[k];
            _kevt=evt;
            processKeysUp();
        }

        private function addListeners():void
        {
            removeListeners();
            _host.addEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
            _host.addEventListener(KeyboardEvent.KEY_UP, __onKeyUp);
        }

        private function removeListeners():void
        {
            _host.removeEventListener(KeyboardEvent.KEY_DOWN, __onKeyDown);
            _host.removeEventListener(KeyboardEvent.KEY_UP, __onKeyUp);
        }

        /**
         * Sees if a combo is missing additional keys and
         * helps decide which key combos should be active betweem those that share same keys.
         **/
        private function foundOtherThan(ko:Object):Object
        {
            var c:int=0;
            var o:Object;
            var n:int;
            var ka:Array;
            for each (o in _keys)
            {
                if (o != ko && o.executed == null)
                {
                    ka=o.keys as Array;
                    c=0;
                    n=ka.length - 1;
                    while (n > -1)
                    {
                        if (_pressed[ka[n]])
                        {
                            c++;
                            if (c == ka.length)
                            {
                                return o;
                            }
                        }
                        n--;
                    }
                }
            }
            return null;
        }

        private function processKeysDown(ignoreExec:Boolean=false, isUp:Boolean=false, k:int=-1, ke:KeyManagerEvent=null):Boolean
        {
            var ko:Object;
            var n:int;
            var cnt:int=0;
            var i:int;
            var kp:Boolean=false;
            var ke:KeyManagerEvent;
            var evtKO:Object;
            var ka:Array;
            var otherKO:Object;
            for each (ko in _keys)
            {
                ka=ko.keys as Array;
                //------------------------------------------------
                //If key combo is active already, skip iteration.
                //------------------------------------------------
                if (ko.executed && !ignoreExec)
                {
                    continue;
                }
                cnt=0;
                n=ka.length - 1;
                while (n > -1)
                {
                    //----------------------------------------------
                    //If a key is found in _pressed object count it.
                    //----------------------------------------------
                    if (_pressed[ka[n]])
                    {
                        cnt++;
                        otherKO=foundOtherThan(ko)
                        if (cnt == ka.length && otherKO != null && otherKO.keys.length > 1)
                        {
                            ko=otherKO;
                            break;
                        }
                    }
                    n--;
                }
                //------------------------------------------------------
                //Detect if all keys in combo is pressed and mark it active.
                //------------------------------------------------------ 
                if (cnt == ka.length)
                {
                    if (ko.singular)
                    {
                        kp=true;
                        evtKO=ko;
                        cropToCombo(ko);
                    }
                    if (!ko.isSeq)
                    {
                        if (!isUp)
                        {
                            kp=true;
                            if (ko.startfunc != null)
                            {
                                ko.startfunc();
                            }
                        }
                        if (isUp && ko != _lastKC)
                        {
                            kp=true;
                            if (ko.startfunc != null)
                            {
                                ko.startfunc();
                            }
                        }
                        ko.executed=true;
                        evtKO=ko;
                        //Keep this break, Seems to allow combos of both rev and fwd order.
                        break;
                    }
                }
                //------------------------------------------------------
                //Detect key sequence, and execute if found.
                //------------------------------------------------------                 
                if (ko.isSeq)
                {
                    if (checkSequence(ko.keys) && !isUp)
                    {
                        if (ko.startfunc != null)
                        {
                            ko.startfunc();
                        }
                        ke=new KeyManagerEvent(KeyManagerEvent.KEY_SEQUENCE);
                        ke.startFunc=ko.startfunc;
                        ke.keyCombo=ko.keys;
                        ke.id=ko.id;
                        dispatchEvent(ke);
                        _seq=[];
                        evtKO=ko;
                    }
                }
            }
            dispatchDown(evtKO);
            if (kp && evtKO != null && evtKO != _lastKC && _pressed[k] != null)
            {
                return true;
            }
            return false;
        }

        private function dispatchDown(ko:Object, ke:KeyManagerEvent=null):void
        {
            _lastKC=ko;
            if (ko != null)
            {
                if (ke == null)
                {
                    ke=new KeyManagerEvent(KeyManagerEvent.KEY_DOWN);
                    ke.startFunc=ko.startfunc;
                    ke.keyCombo=ko.keys;
                    ke.id=ko.id;
                }
                dispatchEvent(ke);
            }
        }

        private function dispatchUp(ko:Object):void
        {
            var ke:KeyManagerEvent
            if (ko != null)
            {
                ke=new KeyManagerEvent(KeyManagerEvent.KEY_UP);
                ke.endFunc=ko.endfunc;
                ke.keyCombo=ko.keys;
                ke.id=ko.id;
                dispatchEvent(ke);
            }
        }

        private function processKeysUp():void
        {
            var ko:Object;
            var n:int;
            var cnt:int=0;
            var missing:Boolean;
            var ke:KeyManagerEvent;
            var evtKO:Object;
            var ka:Array;
            for each (ko in _keys)
            {
                missing=false;
                ka=ko.keys as Array;
                n=ka.length - 1;
                while (n > -1)
                {
                    if (_pressed[ka[n]] == null && ko.executed && !ko.isSeq)
                    {
                        ko.executed=null;
                        if (ko.endfunc != null)
                        {
                            ko.endfunc();
                        }
                        evtKO=ko;
                        dispatchUp(evtKO);
                        break;
                    }
                    n--;
                }
            }
            processKeysDown(true, true);
        }

        /**
         * @return total keys pressed down at one time.
         **/
        private function totalPressed():int
        {
            var o:Object;
            var n:int=0;
            for each (o in _pressed)
            {
                n++;
            }
            return n;
        }

        private function cropToCombo(keyobj:Object):Boolean
        {
            var ko:Object;
            var n:int;
            keyobj.executed=null;
            for each (ko in _keys)
            {
                if (ko.id != keyobj.id)
                {
                    if (ko.executed)
                    {
                        if (ko.endfunc != null)
                        {
                            ko.endfunc();
                            return true;
                        }
                    }
                }
            }
            return false;
        }

        private function checkSequence(a:Array):Boolean
        {
            if (_seqstr.indexOf(a.toString()) != -1)
            {
                return true;
            }
            return false;
        }

        private function formatKeyArray(a:Array):Array
        {
            var n:int=a.length - 1;
            while (n > -1)
            {
                a[n]=findKey(a[n]);
                n--;
            }
            return a.slice();
        }

        private function getTotalKeys():int
        {
            var c:int=0;
            var ko:Object;
            for each (ko in _keys)
            {
                c++;
            }
            return c;
        }

        /**
         * Used privately by the KeyManager class, but is public for possible use outside of class.
         * @param key A
         * @return key code match from lexical key parameter.
         **/
        public static function findKey(key:Object):int
        {
            var s:String;
            var code:int;
            var t:String;
            if (key is String)
            {
                s=key.toString().toUpperCase();
                t=key.toString().toLowerCase();
                if (s.length > 1 || s.match(/\w|[^\w]|\-|\=|\'|\\|\/|\'\`|\[|\]|\,|\.|\d/ig) != null)
                {
                    if (Keyboard[s] != null)
                    {
                        code=Keyboard[s];
                    }
                    else
                    {
                        switch (t)
                        {
                            case "shift":
                            case "shft":
                            case "shf":
                                code=Keyboard.SHIFT;
                                break;
                            case "-":
                            case "minus":
                                code=Keyboard.MINUS;
                                break;
                            case "=":
                            case "equal":
                                code=Keyboard.EQUAL;
                                break;
                            case "rightbracket":
                            case "]":
                                code=Keyboard.RIGHTBRACKET;
                                break;
                            case "leftbracket":
                            case "[":
                                code=Keyboard.LEFTBRACKET;
                                break;
                            case "cmd":
                            case "command":
                                code=Keyboard.COMMAND;
                                break;
                            case ",":
                            case "comma":
                            case "cma":
                                code=Keyboard.COMMA;
                                break;
                            case ".":
                            case "period":
                            case "prd":
                                code=Keyboard.PERIOD;
                                break;
                            case "esc":
                            case "escape":
                                code=Keyboard.ESCAPE;
                                break;
                            case "`":
                            case "tilde":
                            case "tld":
                                code=192;
                                break;
                            case "\\":
                            case "backslash":
                                code=Keyboard.BACKSLASH;
                                break;
                            case "/":
                            case "slash":
                                code=Keyboard.SLASH;
                                break;
                            case "pageup":
                            case "pgup":
                                code=Keyboard.PAGE_UP;
                                break;
                            case "pagedown":
                            case "pgdn":
                                code=Keyboard.PAGE_DOWN;
                                break;
                            case "ins":
                            case "insert":
                                code=Keyboard.INSERT;
                                break;
                            case "del":
                            case "delete":
                                code=Keyboard.DELETE;
                                break;
                            case ";":
                                code=Keyboard.SEMICOLON;
                                break;
                            case "'":
                                code=Keyboard.QUOTE;
                                break;
                            case "bksp":
                            case "backspace":
                                code=Keyboard.BACKSPACE;
                                break;
                            case "space":
                                code=Keyboard.SPACE;
                                break;
                            case "enter":
                                code=Keyboard.ENTER;
                                break;
                            case "tab":
                                code=Keyboard.TAB;
                                break;
                            case "ctrl":
                            case "ctl":
                            case "control":
                                code=Keyboard.CONTROL;
                                break;
                            case "<":
                            case "left":
                            case "&lt;":
                                code=Keyboard.LEFT;
                                break;
                            case ">":
                            case "right":
                            case "&gt;":
                                code=Keyboard.RIGHT;
                                break;
                            case "/\\":
                            case "up":
                                code=Keyboard.UP;
                                break;
                            case "\\/":
                            case "down":
                            case "dn":
                                code=Keyboard.DOWN;
                                break;
                            case "home":
                            case "hom":
                                code=Keyboard.HOME;
                                break;
                            case "caps":
                            case "capslock":
                                code=Keyboard.CAPS_LOCK;
                                break;
                            case "break":
                            case "brk":
                                code=19;
                                break;
                            case "scrollock":
                            case "scrolllock":
                            case "scrollk":
                            case "sclk":
                            case "slok":
                                code=145;
                                break;
                            default:
                                code=0;
                        }
                        if (s.match(/\d/) != null)
                        {
                            code=Number(s) + 48;
                        }
                    }
                }
                else
                {
                    if (code == 0)
                    {
                        code=s.charCodeAt(0);
                    }
                }
                if (code == 0)
                {
                    if (s.search(/nump|p\d+|pad\d+/mig) != -1)
                    {
                        t="NUMPAD_" + s.replace(/\D+/mig, "");
                        code=Keyboard[t];
                    }
                    else if (s.search(/number|n\d+|num\d+/mig) != -1)
                    {
                        t="NUMBER_" + s.replace(/\D+/mig, "");
                        code=Keyboard[t];
                    }
                    else if (s.search(/f\d+/mig) != -1)
                    {
                        t="F" + s.replace(/\D+/mig, "");
                        code=Keyboard[t];
                    }
                }
            }
            else
            {
                code=key as int;
            }
            return code;
        }
    }
}