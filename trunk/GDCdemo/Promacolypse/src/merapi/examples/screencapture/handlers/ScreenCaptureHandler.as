////////////////////////////////////////////////////////////////////////////////
//
//  This program is free software; you can redistribute it and/or modify 
//  it under the terms of the GNU General Public License as published by the 
//  Free Software Foundation; either version 3 of the License, or (at your 
//  option) any later version.
//
//  This program is distributed in the hope that it will be useful, but 
//  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY 
//  or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License 
//  for more details.
//
//  You should have received a copy of the GNU General Public License along 
//  with this program; if not, see <http://www.gnu.org/licenses>.
//
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
//
// Screen Capture example was written by Rich Tretola
// http://www.twitter.com/richtretola
// http://blog.everythingflex.com
// http://www.happytoad.com
//
////////////////////////////////////////////////////////////////////////////////

package merapi.examples.screencapture.handlers
{

import flash.events.Event;

import merapi.examples.screencapture.messages.ScreenCaptureMessage;
import merapi.handlers.mxml.MessageHandler;
import merapi.messages.IMessage;
import merapi.Bridge;

//--------------------------------------
//  Events
//--------------------------------------

/**
 *  Signals a change in the filePath value.
 *
 *  @type flash.events.Event
 */
[Event(name="change", type="flash.events.Event")]	
	
[Bindable]
/**
 *  The <code>ScreenCaptureHandler</code> class extends <code>Message</code> as an example of a 
 *  custom Merapi message.
 *
 *  @see merapi.messages.Message;
 */
public class ScreenCaptureHandler extends MessageHandler
{
    //--------------------------------------------------------------------------
    //
    //  Constants
    //
    //--------------------------------------------------------------------------

    /**
     *  Message type for a Screen Capture message.
     */
    public static const SCREEN_CAPTURE_COMPLETED : String = "screenCaptureCompleted";
     
            
    //--------------------------------------------------------------------------
    //
    //  Constructor
    //
    //--------------------------------------------------------------------------

    /**
     *  Constructor.
     */     
    public function ScreenCaptureHandler() 
    {
        //super( ScreenCaptureHandler.SCREEN_CAPTURE_COMPLETED );
		super("takeScreenShot");
		//this.addMessageType("takeScreenShot");
        //connectMerapi();
		Bridge.connect();
    }
    
    
    //--------------------------------------------------------------------------
    //
    //  Properties
    //
    //--------------------------------------------------------------------------

    //----------------------------------
    //  imagePath
    //----------------------------------

    /**
     *  The imagePath of the new screen capture
     */     
    public var imagePath : String = "";

    //--------------------------------------------------------------------------
    //
    //  Methods
    //
    //--------------------------------------------------------------------------

	override public function handleMessage( message : IMessage ) : void
	{
		trace("ScreenCaptureHandler.handleMessage(): Received a message.");
		if ( message is ScreenCaptureMessage )
		{
			var scMessage : ScreenCaptureMessage = message as ScreenCaptureMessage;
			//imagePath 		= scMessage.imagePath;
			//dispatchEvent( new Event( Event.CHANGE ) );
			trace("ScreenCaptureHandler.handleMessage(): UID: "+scMessage.uid + " message.data: " + scMessage.data);
		}
	}
    
} //  end class
} //  end package

