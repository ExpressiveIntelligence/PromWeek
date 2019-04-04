package merapi.examples.screencapture.messages
{

import merapi.messages.Message;

[RemoteClass( alias="merapi.examples.screencapture.messages.ScreenCaptureMessage" )]
public class ScreenCaptureMessage extends Message
{

    public static const TAKE_SCREEN_SHOT : String = "takeScreenShot";
     
    public function ScreenCaptureMessage() 
    {
        super( TAKE_SCREEN_SHOT );
    }
    
    
    public var storagePath : String = null;
    public var imagePath : String = null;
    
    
} //  end class
} //  end package

