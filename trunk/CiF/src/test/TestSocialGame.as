package test 
{
	import CiF.*;
	import org.flexunit.Assert;
	
	/**
	 * ...
	 * @author Travis
	 */
	public class TestSocialGame {		
		public var traitPred:Predicate;
		public var relationshipPred:Predicate;
		public var statusPred:Predicate;
		public var ckbPred:Predicate;
		public var networkPred:Predicate;
		public var sfdbPred:Predicate;
		
		public var preconditions:Vector.<Rule>;
		public var initiatorIRS:InfluenceRuleSet;
		public var responderIRS:InfluenceRuleSet;
		public var effects:Vector.<Effect>;
		public var instantiations:Vector.<Instantiation>;
		public var brag:SocialGame;
		public var flirt:SocialGame;
		
		[Before]
		public function setUp():void {
			
			traitPred = new Predicate();
			relationshipPred = new Predicate();
			statusPred = new Predicate();
			ckbPred = new Predicate();
			networkPred = new Predicate();
			sfdbPred = new Predicate();
			
			traitPred.setTraitPredicate("initiator", Trait.CONFIDENT, false);
			networkPred.setNetworkPredicate("initiator", "responder", ">", 40, SocialNetwork.BUDDY);
			statusPred.setStatusPredicate("initiator", "responder", Status.HAS_A_CRUSH_ON);
			ckbPred.setCKBPredicate("initiator", "responder", "likes", "dislikes", "cool");
			relationshipPred.setRelationshipPredicate("initiator", "responder", RelationshipNetwork.DATING, true);
			
			
			//add some social games to the social game library
			
			brag = new SocialGame();
			flirt = new SocialGame();
			brag.name = "Brag";
			flirt.name = "Flirt";
			var p:Predicate = new Predicate();
			var r:Rule = new Rule();
			var r2:Rule = new Rule();
			var r3:Rule = new Rule();
			var r4:Rule = new Rule();
			var r5:Rule = new Rule();
			//preconditions
			
			p.setTraitPredicate("initiator", Trait.CONFIDENT);
			r.predicates.push(p.clone());
			brag.preconditions.push(r.clone());
			p.setTraitPredicate("initiator", Trait.ATTENTION_HOG);
			r2.predicates.push(p.clone());
			brag.preconditions.push(r2.clone());
			
			p.setNetworkPredicate("initiator", "responder", "greaterthan", 39);
			r3.predicates.push(p.clone());
			brag.preconditions.push(r3.clone());
			p.setNetworkPredicate("initiator", "responder", "lessthan", 40, SocialNetwork.BUDDY, true);
			r4.predicates.push(p.clone());
			brag.preconditions.push(r4.clone());
			p.setTraitPredicate("initiator", Trait.HUMBLE, true);
			r5.predicates.push(p.clone());
			brag.preconditions.push(r.clone());
			
			//initiator IRS
			var ir:InfluenceRule = new InfluenceRule();
			p.setTraitPredicate("initiator", Trait.WITTY);
			ir.predicates.push(p.clone());
			ir.weight = 20;
			brag.initiatorIRS.influenceRules.push(ir.clone());
			/* SFDB label should go here:
			 *SFDB(Y was a part of the cool act) -> + 20 
			 **/
			
			//responder IRS
			
			ir = new InfluenceRule();
			p.setNetworkPredicate("responder", "initiator", "greaterthan", 39);
			ir.predicates.push(p.clone());
			ir.weight = 10;
			brag.responderIRS.influenceRules.push(ir.clone());
			
			p.setTraitPredicate("responder", Trait.HUMBLE, true);
			ir = new InfluenceRule();
			ir.predicates.push(p.clone());
			ir.weight = -30;
			brag.responderIRS.influenceRules.push(ir.clone());
			
			p.setStatusPredicate("responder", "initiator", Status.ENVIES);
			ir = new InfluenceRule();
			ir.predicates.push(p.clone());
			ir.weight = -20;
			brag.responderIRS.influenceRules.push(ir.clone());

			//effects
			var e:Effect = new Effect();
			e.isAccept = true;
			p.setNetworkPredicate("responder", "initiator", "+", 20, SocialNetwork.COOL);
			e.change.predicates.push(p.clone());
			e.id = 1;
			e.referenceAsNaturalLanguage = "%I% bragged about %SFDB_cool(I)%";
			brag.effects.push(e.clone());
			
			/**
			 * effect with SFDBLABEL in it:
			 * II::Accept&&YwasAPartOftheCoolAct(X)->CoolUp(Y->X)&&BuddyUp(Y->X)
			 */
			
			e = new Effect();
			e.isAccept = false;
			p.setNetworkPredicate("responder", "initiator", "-", 20, SocialNetwork.COOL);
			e.change.predicates.push(p.clone());
			e.id = 3;
			e.referenceAsNaturalLanguage = "%I% was not so cool at %CKB(I,likes,*,*,cool)%";
			brag.effects.push(e.clone());
			
			e = new Effect();
			e.isAccept = false;
			p.setStatusPredicate("responder", "initiator", Status.ENVIES);
			e.condition.predicates.push(p.clone());
			p.setNetworkPredicate("responder", "initiator", "-", 20, SocialNetwork.COOL);
			e.change.predicates.push(p.clone());
			p.setStatusPredicate("responder", "initiator", Status.ANGRY_AT);
			e.change.predicates.push(p.clone());
			e.id = 4;
			e.referenceAsNaturalLanguage = "%R% was jealous about %IP% %CKB(I,likes,R,likes,cool)%";
			brag.effects.push(e.clone());
			
			e = new Effect();
			e.isAccept = false;
			p.setTraitPredicate("responder", Trait.HUMBLE);
			e.condition.predicates.push(p.clone());
			p.setNetworkPredicate("responder", "initiator", "-", 20, SocialNetwork.COOL);
			e.change.predicates.push(p.clone());
			p.setNetworkPredicate("responder", "initiator", "-", 20, SocialNetwork.BUDDY);
			e.change.predicates.push(p.clone());
			e.id = 5;
			e.referenceAsNaturalLanguage = "%I% was totally humble about %CKB(I,likes,*,*,cool)%";
			brag.effects.push(e.clone());
			
			//instantiations
			//I(Flavorless Accept)
			var inst:Instantiation = new Instantiation();
			var lod:LineOfDialogue = new LineOfDialogue();
			inst.id = 1;
			inst.name = "test";
			
			lod.lineNumber = 1;
			lod.initiatorLine = "initiator's line";
			lod.responderLine = "responder's line";
			lod.otherLine = "other's line";
			lod.primarySpeaker = "initiator";
			lod.initiatorBodyAnimation = "accuse";
			lod.initiatorFaceAnimation = "happy";
			lod.responderBodyAnimation = "accuse";
			lod.responderFaceAnimation = "happy";
			lod.otherBodyAnimation = "accuse";
			lod.otherFaceAnimation = "happy";
			lod.time = 5;
			lod.initiatorIsThought = false;
			lod.responderIsThought = false;
			lod.responderIsThought = false;
			lod.initiatorIsPicture = false;
			lod.responderIsPicture = false;
			lod.responderIsPicture = false;
			lod.initiatorAddressing = "responder";
			lod.responderAddressing = "initiator";
			lod.otherAddressing = "initiator";
			
			inst.lines.push(lod);
			inst.id = 1;
			brag.instantiations.push(inst.clone());
			
			
			//A REAL social game would be even longer!
			//II (Accept with better results)
		
			//III (Reject flavorless)
			
			//IV (Based in Jealousy)
			
			//V(Reject based on humility)

		}
		
		[Test]
		public function testXMLSocialGame():void {
			
			//Are you ready for a very big baseline?
			var baseline:String = "";
			baseline += "<SocialGame name=\"Brag\">\n";
			baseline += "<Preconditions>\n";
			baseline += "<Rule name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"confident\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</Rule>\n"
			baseline += "<Rule name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"attention hog\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</Rule>\n"
			baseline += "<Rule name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"greaterthan\" value=\"39\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</Rule>\n"
			baseline += "<Rule name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"initiator\" second=\"responder\" comparator=\"lessthan\" value=\"40\" negated=\"true\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</Rule>\n"
			baseline += "<Rule name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"confident\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</Rule>\n"
			baseline += "</Preconditions>\n";
			baseline += "<InitiatorInfluenceRuleSet>\n"
			baseline += "<InfluenceRule weight=\"20\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"witty\" first=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "</InitiatorInfluenceRuleSet>\n"
			baseline += "<ResponderInfluenceRuleSet>\n"
			baseline += "<InfluenceRule weight=\"10\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"network\" networkType=\"buddy\" first=\"responder\" second=\"initiator\" comparator=\"greaterthan\" value=\"39\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n"
			baseline += "</InfluenceRule>\n"
			baseline += "<InfluenceRule weight=\"-30\" name=\"Anonymous Rule\">\n"
			baseline += "<Predicate type=\"trait\" trait=\"humble\" first=\"responder\" negated=\"true\" isSFDB=\"false\" window=\"0\"/>\n"
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
			baseline += " <Predicate type=\"status\" status=\"jealous of\" first=\"responder\" second=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "</ConditionRule>\n";
			baseline += "<ChangeRule>\n";
			baseline += "<Predicate type=\"network\" networkType=\"cool\" first=\"responder\" second=\"initiator\" comparator=\"-\" value=\"20\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
			baseline += "<Predicate type=\"status\" status=\"angry at\" first=\"responder\" second=\"initiator\" negated=\"false\" isSFDB=\"false\" window=\"0\"/>\n";
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
			baseline += "<Instantiation id=\"1\" name=\"test\">\n"
			baseline += "<LineOfDialogue lineNumber=\"1\" initiatorLine=\"initiator's line\" responderLine=\"responder's line\" otherLine=\"other's line\" primarySpeaker=\"initiator\" initiatorBodyAnimation=\"accuse\" initiatorFaceAnimation=\"happy\" responderBodyAnimation=\"accuse\" responderFaceAnimation=\"happy\" otherBodyAnimation=\"accuse\" otherFaceAnimation=\"happy\" time=\"5\" initiatorIsThought=\"false\" responderIsThought=\"false\" otherIsThought=\"false\" initiatorIsPicture=\"false\" responderIsPicture=\"false\" otherIsPicture=\"false\" initiatorAddressing=\"responder\" responderAddressing=\"initiator\" otherAddressing=\"initiator\" isOtherChorus=\"false\" />\n"
			baseline += "<ToC1>null</ToC1>\n";
			baseline += "<ToC2>null</ToC2>\n";
			baseline += "<ToC3>null</ToC3>\n";
			baseline += "</Instantiation>\n";
			baseline += "</Instantiations>\n";
			baseline += "</SocialGame>\n";
			
			
			//Debug.debug(this, "baseline:\n" + baseline)
			//Debug.debug(this, "socialgameToXMLString():\n" + brag.toXMLString());
			Assert.assertTrue(baseline == brag.toXMLString());
		}
		
		[Test]
		public function testEquals():void {
			Assert.assertTrue(SocialGame.equals(brag, brag));
			Assert.assertFalse(SocialGame.equals(brag, flirt));
		}
		
		[Test]
		public function testClone():void {
			Assert.assertTrue(SocialGame.equals(brag, brag.clone()));
		}


	}

}