package test 
{
	import CiF.*;
	import flexunit.framework.Assert;
	/**
	 * ...
	 * @author Ben*
	 */
	public class TestSocialGameLib
	{
		public var cif:CiFSingleton;
		public var sgl:SocialGamesLib;
		
		[Before]
		public function setUp():void {
			this.cif = CiFSingleton.getInstance();
			this.cif.clear();
			this.cif.defaultState(); //This function puts a sample social game INTO the social game library!
			this.sgl = SocialGamesLib.getInstance();
		}
		
		[Test]
		public function testToXML():void {
			var baseline:String = ""; 
			/*baseline += "<SocialGameLibrary>\n";
			baseline += "<SocialGame name=\"Brag\">\n";
			baseline += "<Preconditions>\n";
			baseline += "<Rule>\n"
			baseline += "<Predicate type=\"trait\" trait=\"confidence\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</Rule>\n"
			baseline += "<Rule>\n"
			baseline += "<Predicate type=\"trait\" trait=\"attention hog\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</Rule>\n"
			baseline += "<Rule>\n"
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"greaterthan\" value=\"39\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</Rule>\n"
			baseline += "<Rule>\n"
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"lessthan\" value=\"40\" negated=\"true\" isSFDB=\"false\" />\n"
			baseline += "</Rule>\n"
			baseline += "<Rule>\n"
			baseline += "<Predicate type=\"trait\" trait=\"confidence\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</Rule>\n"
			baseline += "</Preconditions>\n";
			baseline += "<InitiatorInfluenceRuleSet>\n"
			baseline += "<InfluenceRule weight = \"20\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"witty\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</InfluenceRule>\n"
			baseline += "</InitiatorInfluenceRuleSet>\n"
			baseline += "<ResponderInfluenceRuleSet>\n"
			baseline += "<InfluenceRule weight = \"10\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"responder\" second=\"initiator\" comparator=\"greaterthan\" value=\"39\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</InfluenceRule>\n"
			baseline += "<InfluenceRule weight = \"-30\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"humble\" first=\"responder\" negated=\"true\" isSFDB=\"false\" />\n"
			baseline += "</InfluenceRule>\n"
			baseline += "<InfluenceRule weight = \"-20\">\n"
			baseline += "<Predicate type=\"status\" status=\"jealous\" first=\"responder\" second=\"initiator\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</InfluenceRule>\n"
			baseline += "</ResponderInfluenceRuleSet>\n"
			baseline += "<Effects>\n"
			baseline += "<Effect id=\"1\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"+\" value=\"20\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</Effect>\n"
			baseline += "<Effect id=\"3\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</Effect>\n"
			baseline += "<Effect id=\"4\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "<Predicate type=\"status\" status=\"emnity\" first=\"responder\" second=\"initiator\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "<Predicate type=\"status\" status=\"jealous\" first=\"responder\" second=\"initiator\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</Effect>\n"
			baseline += "<Effect id=\"5\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "<Predicate type=\"trait\" trait=\"humble\" first=\"responder\" negated=\"false\" isSFDB=\"false\" />\n"
			baseline += "</Effect>\n"
			baseline += "</Effects>\n"
			baseline += "<Instantiations>\n";
			baseline += "<Instantiation id=\"1\">\n"
			baseline += "<LineOfDialogue lineNumber=\"1\" initiatorLine=\"initiator's line\" responderLine=\"responder's line\" otherLine=\"other's line\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" />\n"
			baseline += "</Instantiation>\n"
			baseline += "</Instantiations>\n";
			baseline += "</SocialGame>\n"
			baseline += "</SocialGameLibrary>\n";*/
			
			baseline += "<SocialGameLibrary>\n";
			baseline += "<SocialGame name=\"Brag\">\n";
			baseline += "<Preconditions>\n";
			baseline += "<Rule name=\"Anonymous Rule\">\n";
			baseline += "<Predicate type=\"SFDB label\" first=\"initiator\" second=\"initiator\" label=\"cool\" negated=\"false\" isSFDB=\"true\" window=\"0\"/>\n";
			baseline += "</Rule>\n";
			baseline += "</Preconditions>\n";
			baseline += "<InitiatorInfluenceRuleSet>\n"
			baseline += "<InfluenceRule weight=\"20\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"confident\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "<InfluenceRule weight=\"10\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"attention hog\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "<InfluenceRule weight=\"10\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"greaterthan\" value=\"39\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "<InfluenceRule weight=\"-10\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"lessthan\" value=\"40\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "<InfluenceRule weight=\"-20\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"humble\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "</InitiatorInfluenceRuleSet>\n"
			baseline += "<ResponderInfluenceRuleSet>\n"
			baseline += "<InfluenceRule weight=\"20\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"smooth talker\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "<InfluenceRule weight=\"10\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"responder\" second=\"initiator\" comparator=\"greaterthan\" value=\"39\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "<InfluenceRule weight=\"-30\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"humble\" first=\"responder\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "<InfluenceRule weight=\"-20\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"status\" status=\"jealous of\" first=\"responder\" second=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "</ResponderInfluenceRuleSet>\n"
			baseline += "<Effects>\n";
			baseline += "<Effect id=\"1\" accept=\"true\" instantiationID=\"-1\">\n";
			baseline += "<PerformanceRealization>%I% bragged about %SFDB_cool(I)%</PerformanceRealization>\n";
			baseline += "<ConditionRule>\n";
			baseline += " </ConditionRule>\n";
			baseline += "<ChangeRule>\n";
			baseline += "<Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"+\" value=\"20\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "</ChangeRule>\n";
			baseline += "</Effect>\n";
			baseline += "<Effect id=\"3\" accept=\"false\" instantiationID=\"-1\">\n";
			baseline += "<PerformanceRealization>%I% was not so cool at %CKB(I,likes,*,*,cool)%</PerformanceRealization>\n";
			baseline += "<ConditionRule>\n";
			baseline += " </ConditionRule>\n";
			baseline += "<ChangeRule>\n";
			baseline += "<Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "</ChangeRule>\n";
			baseline += "</Effect>\n";
			baseline += "<Effect id=\"4\" accept=\"false\" instantiationID=\"-1\">\n";
			baseline += "<PerformanceRealization>%R% was jealous about %IP% %CKB(I,likes,R,likes,cool)%</PerformanceRealization>\n";
			baseline += "<ConditionRule>\n";
			baseline += " <Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "</ConditionRule>\n";
			baseline += "<ChangeRule>\n";
			baseline += "<Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "<Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "</ChangeRule>\n";
			baseline += "</Effect>\n";
			baseline += "<Effect id=\"5\" accept=\"false\" instantiationID=\"-1\">\n";
			baseline += "<PerformanceRealization>%I% was totally humble about %CKB(I,likes,*,*,cool)%</PerformanceRealization>\n";
			baseline += "<ConditionRule>\n";
			baseline += " <Predicate type=\"trait\" trait=\"humble\" first=\"responder\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "</ConditionRule>\n";
			baseline += "<ChangeRule>\n";
			baseline += "<Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "</ChangeRule>\n";
			baseline += "</Effect>\n";
			baseline += "</Effects>\n";
			baseline += "<Instantiations>\n";
			baseline += "<Instantiation id=\"1\" name=\"null\">\n"
			baseline += "<LineOfDialogue lineNumber=\"0\" initiatorLine=\"Hey %r%\" responderLine=\"\" otherLine=\"\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" initiatorIsThought=\"false\" responderIsThought=\"false\" otherIsThought=\"false\" initiatorIsPicture=\"false\" responderIsPicture=\"false\" otherIsPicture=\"false\" initiatorAddressing=\"responder\" responderAddressing=\"initiator\" otherAddressing=\"initiator\" isOtherChorus=\"false\" />\n"
			baseline += "<LineOfDialogue lineNumber=\"1\" initiatorLine=\"\" responderLine=\"Oh, hi %i%\" otherLine=\"\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" initiatorIsThought=\"false\" responderIsThought=\"false\" otherIsThought=\"false\" initiatorIsPicture=\"false\" responderIsPicture=\"false\" otherIsPicture=\"false\" initiatorAddressing=\"responder\" responderAddressing=\"initiator\" otherAddressing=\"initiator\" isOtherChorus=\"false\" />\n"
			baseline += "<LineOfDialogue lineNumber=\"2\" initiatorLine=\"How's it going?\" responderLine=\"\" otherLine=\"\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" initiatorIsThought=\"false\" responderIsThought=\"false\" otherIsThought=\"false\" initiatorIsPicture=\"false\" responderIsPicture=\"false\" otherIsPicture=\"false\" initiatorAddressing=\"responder\" responderAddressing=\"initiator\" otherAddressing=\"initiator\" isOtherChorus=\"false\" />\n"
			baseline += "<LineOfDialogue lineNumber=\"3\" initiatorLine=\"\" responderLine=\"Good.  What did you do this weekend?\" otherLine=\"\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" initiatorIsThought=\"false\" responderIsThought=\"false\" otherIsThought=\"false\" initiatorIsPicture=\"false\" responderIsPicture=\"false\" otherIsPicture=\"false\" initiatorAddressing=\"responder\" responderAddressing=\"initiator\" otherAddressing=\"initiator\" isOtherChorus=\"false\" />\n"
			baseline += "<LineOfDialogue lineNumber=\"4\" initiatorLine=\"Just a %SFDB_(i, cool)%\" responderLine=\"\" otherLine=\"\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" initiatorIsThought=\"false\" responderIsThought=\"false\" otherIsThought=\"false\" initiatorIsPicture=\"false\" responderIsPicture=\"false\" otherIsPicture=\"false\" initiatorAddressing=\"responder\" responderAddressing=\"initiator\" otherAddressing=\"initiator\" isOtherChorus=\"false\" />\n"
			baseline += "<LineOfDialogue lineNumber=\"5\" initiatorLine=\"\" responderLine=\"Oh wow! That's amazing! I didn't even know you could even do that!  That sounds awesome!\" otherLine=\"\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" initiatorIsThought=\"false\" responderIsThought=\"false\" otherIsThought=\"false\" initiatorIsPicture=\"false\" responderIsPicture=\"false\" otherIsPicture=\"false\" initiatorAddressing=\"responder\" responderAddressing=\"initiator\" otherAddressing=\"initiator\" isOtherChorus=\"false\" />\n"
			baseline += "<ToC1>null</ToC1>\n";
			baseline += "<ToC2>null</ToC2>\n";
			baseline += "<ToC3>null</ToC3>\n";
			baseline += "</Instantiation>\n";
			baseline += "</Instantiations>\n";
			baseline += "</SocialGame>\n";
			baseline += "</SocialGameLibrary>\n";
			
			//Debug.debug(this, "baseline:\n" + baseline);
			//Debug.debug(this, "SocialFactsDB.toXMLString():\n" + sgl.toXMLString());
			Assert.assertTrue(baseline == sgl.toXMLString());
			
		}
	}

}