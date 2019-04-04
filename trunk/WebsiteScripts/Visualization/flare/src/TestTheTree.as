package {
	import flare.analytics.cluster.AgglomerativeCluster;
	import flash.display.Loader;
	import flash.display.Sprite
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import PromWeekVisTree
	import VisSocialGameObj
	
	/**
	 * TestTheTree
	 * This shows parts of how to use a PromWeekVisTree object (which uses Flare libraries).
	 * This class was designed by Ryan Andonian (randonia@ucsc.edu) with great help from 
	 * Josh McCoy and Christian Ress.
	 * 
	 * There was a bit of a synchronization issue using the URLLoader, so it's kind
	 * of silly the way I load the file, but it's the only way to do it without building
	 * this as an AIR project instead. Basically, I call "Load(file.txt)" and then upon completion,
	 * I call insertPathArray (whose data array is populated by parseFormattedTraceFileToArray function)
	 * and then addChild is called to actually show the tree.
	 */
	public class TestTheTree extends Sprite {
		// create a new PromWeekVisTree object using default constructor
		private var pwvt:PromWeekVisTree = new PromWeekVisTree();
		// create the data array for parseFormattedTraceFileToArray function to populate
		var dataArray:Array;
		// for debugging
		var gameCount:Number
		
		/** constructor for TestTheTree (basically, this acts as the main() function. I have 
		 * doStuff() here *just in case* there is something silly involved with data and function
		 * calls and synchronization. doStuff() does everything required
		 */
		public function TestTheTree() {
			gameCount = 0
			doStuff()
		}
		
		/**
		 * doStuff calls the parseFormattedTraceFileToArray function, which takes two arguments.
		 * The function() is a function pointer that specifies a function callback to be done
		 * once the file has been fully loaded. (this is the pain in the butt I was talking about)
		 * 
		 * insertPathArray populates the pwvt object with the data that's loaded into dataArray. 
		 * addChild takes pwvt.drawTree() (which returns a Visualization object) and adds it to
		 * this Sprite (which is why TestTheTree extends Sprite class). 
		 * 
		 *  >>> This is the key part to know. <<<
		 */
		function doStuff() {
			// MAKE SURE THE Sample Trace is in the right folder!
			parseFormattedTraceFileToArray("SampleLevelTrace-01.xml",
									function() {
										pwvt.insertPathArray(dataArray)
										addChild(pwvt.drawTree())})
		}
		
		
		/**
		 * parseFormattedTraceFileToArray takes two arguments
		 * 		file- a string that points to the file you want to read
		 * 		cb- a function callback to be called upon completion of the file loader. This
		 * 			was a source of major frustration >_<
		 */
		public function parseFormattedTraceFileToArray(file:String, cb:Function):void {
			// do the basic "read a text file" that AS3 likes to do
			var loader:URLLoader = new URLLoader()
			// once Flash has completed reading that file, it THEN starts to read the data,
			// then upon completion it does the callback. Because onTextFileLoaded doesn't use
			// events, it has no synchronicity issues.
			loader.addEventListener(Event.COMPLETE, function(e:Event) {
														onTextFileLoaded(e)
														cb()
													})
			// read the file now that the event listener is set up
			loader.load(new URLRequest(file))
		}
		
		/**
		 * onTextFileLoaded
		 * @param	e- the event, this houses the data from the text file. You grab it by 
		 * 			   accessing e.target.data
		 * This function is set up to parse a level trace from the game PromWeek, which is taken
		 * from our database designed by us awesome people.
		 * The format for this file should be:
		 * 
		 * 		initiator,responder,game,effectID
		 * 		initiator,responder,game,effectID
		 * 		>
		 * 
		 * The '>' symbol signifies a new level trace. This can be changed down below, but 
		 * as it stands, it uses this format. It can have n number of Social Games (provided 
		 * flash doesn't run out of memory).
		 * 
		 * Note: This function is PROBABLY pretty inefficient, considering it makes 4 calls to 
		 * new Array(). But this isn't called more than once, so meh.
		 */
		function onTextFileLoaded(e:Event):void {
			// give TestTheTree.dataArray a fresh new array
			this.dataArray = new Array()
			// create a temporary array
			var tArray = new Array()
			// create an array that contains each line of the text file that was read
			var data:Array = e.target.data.split("\n");
			// create an array 
			var line:Array = new Array()
			// make the playerID var so we don't call new a bazillion times (AS3 probably optimizes this for us, but just to be safe
			var playerID:Number = 0
			// now iterate through each line, and manipulate the data accordingly
			for (var i:int = 0; i < data.length; ++i) {
				if (data[i].indexOf(">") != -1 || i == data.length - 1) { // this is where the new level trace occurs
					playerID = data[i].split(" ")[1] // set the playerID variable immidiately 
					if (tArray.length != 0) {
						dataArray.push(tArray)
					}
					tArray = new Array()
					trace("new game! " + "PlayerID is: " + playerID)
					gameCount += 1
					continue
				}
				line = data[i].split(",")
				trace(line)
				// data[i].split(" ")[1] < this is how we grab the player ID. It's on the > line.
				tArray.push(new VisSocialGameObj(line[0],line[1],line[2],line[3],playerID))
			}
			trace("The number of games is: " + gameCount)
		}
	}
}
