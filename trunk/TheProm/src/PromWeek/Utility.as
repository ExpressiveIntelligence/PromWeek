package PromWeek 
{
	//import com.demonsters.debugger.MonsterDebugger;
	import CiF.Debug;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.external.ExternalInterface;
	
	
	
	public class Utility
	{
		public static var useExternalInterface:Boolean = true;
		
		public static function randRange(minNum:Number, maxNum:Number):Number
		{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
		public static function makeStringFirstPerson(lineToMakeFirstPerson:String,nameToMakeFirstPerson:String, other1PersonName:String,other2PersonName:String):String 
		{
			
			var returnString:String = lineToMakeFirstPerson.toLowerCase();
			nameToMakeFirstPerson = nameToMakeFirstPerson.toLowerCase();
			other1PersonName = other1PersonName.toLowerCase();
			other2PersonName = other2PersonName.toLowerCase();
			//with init -> with me
			returnString = returnString.replace(("with " + nameToMakeFirstPerson), "with me");
			//init is -> I am
			returnString = returnString.replace((nameToMakeFirstPerson + " is"), "I am");
			//init has -> I have
			returnString = returnString.replace((nameToMakeFirstPerson + " has"), "I have");
			//init wants -> I want
			returnString = returnString.replace((nameToMakeFirstPerson + " wants"), "I want");
			//init thinks -> I think
			returnString = returnString.replace((nameToMakeFirstPerson + " thinks"), "I think");
			//init likes -> I like
			returnString = returnString.replace((nameToMakeFirstPerson + " likes"), "I like");
			//init dislikes -> I dislike
			returnString = returnString.replace((nameToMakeFirstPerson + " dislikes"), "I dislike");
			//init knows -> I know
			returnString = returnString.replace((nameToMakeFirstPerson + " knows"), "I know");
			//init feels -> I feel
			returnString = returnString.replace((nameToMakeFirstPerson + " feels"), "I feel");
			//init and resp -> resp and I
			returnString = returnString.replace((nameToMakeFirstPerson + " and " + other1PersonName), (other1PersonName + " and I"));
			//returnString = returnString.replace((nameToMakeFirstPerson + " and " + other2PersonName), (other2PersonName + " and I"));
			//resp and init -> resp and I
			returnString = returnString.replace((other1PersonName + " and " + nameToMakeFirstPerson), (other1PersonName + " and I"));
			//returnString = returnString.replace((other2PersonName + " and " + nameToMakeFirstPerson), (other2PersonName + " and I"));
			//init's -> my
			returnString = returnString.replace((nameToMakeFirstPerson + "'s"), "my");
			//to init -> to me
			returnString = returnString.replace(("to " + nameToMakeFirstPerson), "to me");
			//init doesn't -> I don't
			returnString = returnString.replace((nameToMakeFirstPerson + " doesn't"), "I don't");
			//init does -> I do
			returnString = returnString.replace((nameToMakeFirstPerson + " does "), "I do ");
			
			if (returnString.toLowerCase() == lineToMakeFirstPerson.toLowerCase())
			{
				//this means none of the above have been true
				
				var words:Array = returnString.split(" ");
				var word:String;
				var i:int;
				if (words.length > 0)
				{
					//if none of the above and init IS first -> change to I
					if (words[0].toLowerCase() == nameToMakeFirstPerson.toLowerCase())
					{
						returnString = "I ";
						for (i = 1; i < words.length; i++ )
						{
							returnString += words[i];
							if (i != words.length - 1)
							{
								returnString += " ";
							}
						}
					}
					else
					{
						//if not any of the above and first word IS NOT init -> all after should be me
						returnString = returnString.replace(nameToMakeFirstPerson, "me");
					}
				}
			}
			
			return returnString;
		}
		

		public static function getSocialGameConsiderationPhraseForInitiator(sgName:String,responder:String):String
		{
			sgName = sgName.toLowerCase();
			
			switch(sgName)
			{
				case "annoy":
					return "annoy " + responder;
				case "ask out":
					return "ask out " + responder;
				case "back me up!":
					return "Ask " + responder + " to back me up";
				case "backstab":
					return "backstab " + responder;
				case "bicker":
					return "bicker with " + responder;
				case "blow off plans":
					return "blow off plans with " + responder;
				case "brash remark":
					return "make a brash remark to " + responder;
				case "brag":
					return "brag to " + responder;
				case "broke my heart!":
					return "tell " + responder + " they broke my heart";
				case "brutal break-up":
					return "brutally break-up with " + responder;
				case "bully":
					return "bully " + responder;
				case "concede":
					return "concede to " + responder;
				case "confide in":
					return "confide in " + responder;
				case "declare war":
					return "declare war on " + responder;
				case "embarrass self":
					return "embrrass self in front of " + responder;
				case "flirt":
					return "flirt with " + responder;
				case "give advice":
					return "give advice to " + responder;
				case "humble self":
					return "humble self to " + responder;
				case "idolize":
					return "idolize " + responder;
				case "insult":
					return "insult " + responder;
				case "insult friend of":
					return "insult friend of " + responder;
				case "it's over!":
					return "tell " + responder + " it's over";
				case "leave me alone!":
					return "tell " + responder + " to leave me alone";
				case "let's be friends!":
					return "tell " + responder + "let's be friends";
				case "make plans":
					return "make plans with " + responder;
				case "make up":
					return "make up with " + responder;
				case "open up":
					return "open up to " + responder;
				case "physical flirt":
					return "physical flirt with " + responder;
				case "pick-up line":
					return "Pick-up on " + responder;
				case "reminisce":
					return "reminisce with " + responder;
				case "share interest":
					return "share an interest with " + responder;
				case "shoot down":
					return "shoot down " + responder;
				case "show off":
					return "show off to " + responder;
				case "spread rumors":
					return "spread rumors to " + responder;
				case "turn off":
					return "turn off " + responder;
				case "txt break up":
					return "break up with " + responder + "over text";
				case "weird out":
					return "weird out " + responder;
				case "woo":
					return "woo " + responder;
				case "woo enemy":
					return "woo my enemy " + responder;
			}
			return "";
		}
		
		public static function getSocialGameConsiderationPhraseForResponder(sgName:String,initiator:String):String
		{
			sgName = sgName.toLowerCase();
			
			switch(sgName)
			{
				case "annoy":
					return "be annoyed by " + initiator;
				case "ask out":
					return "asked out by " + initiator;
				case "back me up!":
					return "back up " + initiator;
				case "backstab":
					return "backstabbed by " + initiator;
				case "bicker":
					return "bickered with by " + initiator;
				case "blow off plans":
					return "if " + initiator + "blew off plans";
				case "brag":
					return "bragged to by " + initiator;
				case "brash remark":
					return  initiator + "made a brash remark";
				case "broke my heart!":
					return "if I broke " + initiator + "'s heart";
				case "brutal break-up":
					return initiator + " brutally broke up with me";
				case "bully":
					return "bullied by " + initiator;
				case "concede":
					return "conceded to by " + initiator;
				case "confide in":
					return "confided in by " + initiator;
				case "declare war":
					return "if " + initiator + " declared war";
				case "embarrass self":
					return "if " + initiator + " was embarrassing";
				case "flirt":
					return "flirted with by " + initiator;
				case "give advice":
					return "given advice by " + initiator;
				case "humble self":
					return  initiator + " humbled themself";
				case "idolize":
					return "idolized by " + initiator;
				case "insult":
					return "insulted by " + initiator;
				case "insult friend of":
					return initiator + " insulted my friend";
				case "it's over!":
					return  "if " + initiator + " told me it's over";
				case "leave me alone!":
					return "if " + initiator + " said \"leave me alone\"";
				case "let's be friends!":
					return "if " + initiator + " said \"let's be friends\"";
				case "make plans":
					return "make plans with " + initiator;
				case "make up":
					return "make up with " + initiator;
				case "open up":
					return "opened up to by " + initiator;
				case "physical flirt":
					return "physically flirted with by " + initiator;
				case "pick-up line":
					return "picked-up on by " + initiator;
				case "reminisce":
					return "reminisce with " + initiator;
				case "share interest":
					return "share an interest with " + initiator;
				case "shoot down":
					return "shot down by " + initiator;
				case "show off":
					return  initiator + " showed off to me";
				case "spread rumors":
					return "spread rumors with " + initiator;
				case "turn off":
					return "turned off by " + initiator;
				case "txt break up":
					return  initiator + " broke up with me thru txt?!";
				case "weird out":
					return "weirded out by " + initiator;
				case "woo":
					return "wooed by " + initiator;
				case "woo enemy":
					return "wooed by my enemy " + initiator;
			}
			return "";
		}
		
		
		public static function log(caller:Object, obj:Object, person:String = null, label:String = null ):void {
			CONFIG::monster {
				MonsterDebugger.trace(obj, obj, person, label);
			}
			if (useExternalInterface) {
				try{
				ExternalInterface.call('console.log', obj as String);
				}
				catch (e:Error) {
					trace("Utility.log oops, no external interface. Stop trying to use it.");
					useExternalInterface = false;
				}
			}
		}
		
		
		/**
		 * Translates a point in the fromDomain to it's corresponding value in toDomain.
		 * 
		 * @param	pt
		 * @param	fromDomain
		 * @param	toDomain
		 * @return
		 */
		public static function translatePoint(pt:Point, fromDomain:DisplayObject, toDomain:DisplayObject):Point {
		   var newPt:Point;
		   newPt = pt.clone(); // clone point so that original point is not modified
		   newPt = fromDomain.localToGlobal(newPt);
		   newPt = toDomain.globalToLocal(newPt);
		   return newPt;
		}
		
		/**
		 * Because there are a few places that can send out a tweet, let's just write the function that
		 * opens up the user's browser once, here in Util!
		 * This opens up the user's browser to a page that lets them 'type in a tweet' (and prepopulates the
		 * text box with the value of tweetText, with an AT Prom_Week appended to the end
		 * @param	tweetText
		 */
		public static function handleTweet(tweetText:String):void {
			
			//The path to the status page
			var path:URLRequest = new URLRequest("http://twitter.com/home");

			//using the GET method means you will use a QueryString to send the variables
			//twitter likes this
			path.method = URLRequestMethod.GET;

			//The custom status message to send. Might as well let twitter worry about the char count
			var tweetVars:URLVariables = new URLVariables();//escape("Major Callisto rocks my world http://www.majorcallisto.com");

			//Twitter uses a "status" variable to prepopulate the page
			var tweetContent:String = tweetText + " @Prom_Week";
			tweetVars.status = tweetContent;

			//Add the variables to the URLRequest
			path.data = tweetVars;

			//Open the page in a "_blank" (new) window and let the user worry about closing
			navigateToURL(path, "_blank");
		}
		
		public static function postToFacebookWall(name:String, caption:String, description:String, fileName:String=""):void {
			name = name.replace(" ", "%20");
			caption = caption.replace(" ", "%20"); // because this is a url we are creating, spaces are encoded as %20
			description = description.replace(" ", "%20");
			
			var fileNameWithHTML:String = fileName + ".html";
			
			Debug.debug(null, "This is the value of filename (inside of Utility.as): " + fileName);
			
			Debug.debug(null, "wha ha hwa hdha dhfd adhfdf hdf?");
			
			var requestString:String = "http://www.facebook.com/dialog/feed?" +
			"app_id=229227247093324&";
			
			if(fileName == "")
				requestString += "link=facebook.com/promweek/&";
			else
				requestString += "link=http://promweek.soe.ucsc.edu/sgTranscriptImages/" + fileNameWithHTML + "&";
				
			
				
			requestString += "picture=http://promweek.soe.ucsc.edu/images/promWeek.jpg&";
			
			
			//requestString += "picture=http://promweek.soe.ucsc.edu/images/" + fileName + ".jpg&";
			/*
			if(fileName != "")
				requestString += "source=http://promweek.soe.ucsc.edu/sgTranscriptImages/" + fileName + "&";
			*/	
			requestString += "name=" + name + "&" +
			"caption=" + caption + "&" + 
			"description=" + description + "&" +
			"redirect_uri=http://www.facebook.com";
			
			var path:URLRequest = new URLRequest(requestString);
			
			/*
			var path:URLRequest = new URLRequest("http://www.facebook.com/dialog/feed?" +
			"app_id=229227247093324&" +
			"link=facebook.com/promweek/&" +
			"picture=http://promweek.soe.ucsc.edu/images/promWeek.jpg&" + 
			
			"source=http://promweek.soe.ucsc.edu/sgTranscriptImages/" + fileName + "&" + 
			"name=" + name + "&" +
			"caption=" + caption + "&" + 
			"description=" + description + "&" +
			"redirect_uri=http://www.facebook.com");
			*/
			
			
			path.method = URLRequestMethod.POST;
			
			navigateToURL(path, "_blank");
		}
		
	/*	public function getBitmapData( target : UIComponent ) : BitmapData {
			var bd : BitmapData = new BitmapData( target.width, target.height );
			var m : Matrix = new Matrix();
			bd.draw( target, m );
			return bd;
		}
*/
	}

}