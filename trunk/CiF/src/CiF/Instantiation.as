package CiF 
{
	
	/**
	 * Instantiations store the performance realization for a particular Effect
	 * brance when performing social game play.
	 * 
	 * The Instantiation class aggregates lines of dialogs into Instantiations
	 * to be associated with Effects of SocialGames. 
	 * 
	 * @see CiF.LineOfDialog
	 */
	public class Instantiation
	{
		/**
		 * The vector of LineOfDialogue class that comprises the animations,
		 * dialogue, and timing of an instantiation.
		 */
		public var lines:Vector.<LineOfDialogue>;
		/**
		 * The ID of the instantiation used to link social game effects with
		 * instantiations.
		 */
		public var id:Number;
		public var name:String;
		
		public var toc1:ToCLocution;
		public var toc2:ToCLocution;
		public var toc3:ToCLocution;
		 
		/**
		 * The bank of conditional rules for use in performance
		 * realization tags -- especially the if/conditional tags.
		 */
		public var conditionalRules:Vector.<Rule>;
		
		public function Instantiation() 
		{
			toc1 = new ToCLocution();
			toc1.tocID = 1;
			toc2 = new ToCLocution();
			toc2.tocID = 2;
			toc3 = new ToCLocution();
			toc3.tocID = 3;
			
			this.lines = new Vector.<LineOfDialogue>();
			this.id = -1;
			this.conditionalRules = new Vector.<Rule>();
		}

		//Processes ToC's into locution vectors
		//happens at the beginning
		//context free
		public function createLocutionVectors():void {
			
		}
		
		
		public function realizeDialogue(initiator:Character, responder:Character, other:Character = null):Instantiation 
		{
			var newInst:Instantiation = new Instantiation();
			
			//render toc strings
			var newLod:LineOfDialogue;
			var locution:Locution;
			var line:LineOfDialogue;
			var tocLoc:ToCLocution;
			var conditionalLocution:ConditionalLocution;
			var i:int;
			var conditionalStringAdded:Boolean;
			
			for each (line in this.lines)
			{
				
				newLod = line.clone();
				
				newLod.initiatorLine = "";
				newLod.responderLine = "";
				newLod.otherLine = "";

				//if we are testing, just print out the type of locution
				if (CiFSingleton.getInstance().isInPromToolPreviewMode)
				{
					for each (locution in line.initiatorLocutions)
					{
						toc1.speaker = "initiator";
						toc2.speaker = "initiator";
						toc3.speaker = "initiator";
						
						toc1.renderText(initiator, responder, other, line);
						toc2.renderText(initiator, responder, other, line);
						toc3.renderText(initiator, responder, other, line);
						newLod.initiatorLine += locution.getType();
					}
					for each (locution in line.responderLocutions)
					{
						toc1.speaker = "responder";
						toc2.speaker = "responder";
						toc3.speaker = "responder";
						
						toc1.renderText(initiator, responder, other, line);
						toc2.renderText(initiator, responder, other, line);
						toc3.renderText(initiator, responder, other, line);
						newLod.responderLine += locution.getType();
					}
					for each (locution in line.otherLocutions)
					{
						toc1.speaker = "other";
						toc2.speaker = "other";
						toc3.speaker = "other";
						
						toc1.renderText(initiator, responder, other, line);
						toc2.renderText(initiator, responder, other, line);
						toc3.renderText(initiator, responder, other, line);
						
						newLod.otherLine += locution.getType();
					}
				}
				else
				{
					for each (locution in line.initiatorLocutions)
					{
						toc1.speaker = "initiator";
						toc2.speaker = "initiator";
						toc3.speaker = "initiator";
						
						toc1.renderText(initiator, responder, other, line);
						toc2.renderText(initiator, responder, other, line);
						toc3.renderText(initiator, responder, other, line);
						if (locution.getType() == "ToCLocution")
						{
							tocLoc = locution as ToCLocution;
							if (tocLoc.tocID == 1)
							{	
								newLod.initiatorLine += toc1.realizedString;
							}
							else if (tocLoc.tocID == 2)
							{
								newLod.initiatorLine += toc2.realizedString;
							}
							else if (tocLoc.tocID == 3)
							{
								newLod.initiatorLine += toc3.realizedString;
							}
						}
						else if (locution.getType() == "MixInLocution")
						{
							initiator.isSpeakerForMixInLocution = true;
							newLod.initiatorLine += locution.renderText(initiator, responder, other, line);
							initiator.isSpeakerForMixInLocution = false;
						}
						else if (locution.getType() == "ConditionalLocuation")
						{
							conditionalLocution = locution as ConditionalLocution;
							conditionalStringAdded = false;
							
							if (conditionalLocution.ifRuleID < this.conditionalRules.length)
							{
								if (this.conditionalRules[conditionalLocution.ifRuleID].evaluate(initiator, responder, other))
								{
									newLod.initiatorLine += conditionalLocution.ifRuleString;
									conditionalStringAdded = true;
								}
							}
							
							if (!conditionalStringAdded)
							{
								for (i = 0; i < conditionalLocution.elseIfRuleIDs.length; i++ )
								{
									if (conditionalLocution.elseIfRuleIDs[i] > this.conditionalRules.length - 1) continue;
									if (this.conditionalRules[conditionalLocution.elseIfRuleIDs[i]].evaluate(initiator, responder, other))
									{
										newLod.initiatorLine += conditionalLocution.elseIfStrings[i];
										conditionalStringAdded = true;
										break;
									}
								}
							}
							
							if (!conditionalStringAdded)
							{
								newLod.initiatorLine += conditionalLocution.elseString;
							}
							
						}
						else
						{
							if (locution.getType() == "SFDBLabelLocution")
							{
								(locution as SFDBLabelLocution).speaker = "i";
							}
							//Debug.debug(this, "realizeDialogue(): initiator locution: " + l);
							newLod.initiatorLine += locution.renderText(initiator, responder, other, line);
						}
					}
					//make the responder line
					for each (locution in line.responderLocutions)
					{
						toc1.speaker = "responder";
						toc2.speaker = "responder";
						toc3.speaker = "responder";
						
						toc1.renderText(initiator, responder, other, line);
						toc2.renderText(initiator, responder, other, line);
						toc3.renderText(initiator, responder, other, line);
						if (locution.getType() == "ToCLocution")
						{
							tocLoc = locution as ToCLocution;
							if (tocLoc.tocID == 1)
							{
								newLod.responderLine += toc1.realizedString;
							}
							else if (tocLoc.tocID == 2)
							{
								newLod.responderLine += toc2.realizedString;
							}
							else if (tocLoc.tocID == 3)
							{
								newLod.responderLine += toc3.realizedString;
							}
						}
						else if (locution.getType() == "MixInLocution")
						{
							responder.isSpeakerForMixInLocution = true;
							newLod.responderLine += locution.renderText(initiator, responder, other, line);
							responder.isSpeakerForMixInLocution = false;
						}
						else if (locution.getType() == "ConditionalLocuation")
						{
							conditionalLocution = locution as ConditionalLocution;
							conditionalStringAdded = false;
							
							if (conditionalLocution.ifRuleID < this.conditionalRules.length)
							{
								if (this.conditionalRules[conditionalLocution.ifRuleID].evaluate(initiator, responder, other))
								{
									newLod.responderLine += conditionalLocution.ifRuleString;
									conditionalStringAdded = true;
								}
							}
							
							if (!conditionalStringAdded)
							{
								for (i = 0; i < conditionalLocution.elseIfRuleIDs.length; i++ )
								{
									if (conditionalLocution.elseIfRuleIDs[i] > this.conditionalRules.length - 1) continue;
									if (this.conditionalRules[conditionalLocution.elseIfRuleIDs[i]].evaluate(initiator, responder, other))
									{
										newLod.responderLine += conditionalLocution.elseIfStrings[i];
										conditionalStringAdded = true;
										break;
									}
								}
							}
							
							if (!conditionalStringAdded)
							{
								newLod.responderLine += conditionalLocution.elseString;
							}
							
						}
						else
						{
							if (locution.getType() == "SFDBLabelLocution")
							{
								(locution as SFDBLabelLocution).speaker = "r";
							}
							
							//Debug.debug(this, "realizeDialogue(): initiator locution: " + l);
							newLod.responderLine += locution.renderText(initiator, responder, other,line);
						}
					}
					//make the other line
					for each (locution in line.otherLocutions)
					{
						toc1.speaker = "other";
						toc2.speaker = "other";
						toc3.speaker = "other";
						
						toc1.renderText(initiator, responder, other, line);
						toc2.renderText(initiator, responder, other, line);
						toc3.renderText(initiator, responder, other, line);
						if (locution.getType() == "ToCLocution")
						{
							tocLoc = locution as ToCLocution;
							if (tocLoc.tocID == 1)
							{
								newLod.otherLine += toc1.realizedString;
							}
							else if (tocLoc.tocID == 2)
							{
								newLod.otherLine += toc2.realizedString;
							}
							else if (tocLoc.tocID == 3)
							{
								newLod.otherLine += toc3.realizedString;
							}
						}
						else if (locution.getType() == "MixInLocution")
						{
							other.isSpeakerForMixInLocution = true;
							newLod.otherLine += locution.renderText(initiator, responder, other, line);
							other.isSpeakerForMixInLocution = false;
						}
						else if (locution.getType() == "ConditionalLocuation")
						{
							conditionalLocution = locution as ConditionalLocution;
							conditionalStringAdded = false;
							
							if (conditionalLocution.ifRuleID < this.conditionalRules.length)
							{
								if (this.conditionalRules[conditionalLocution.ifRuleID].evaluate(initiator, responder, other))
								{
									newLod.otherLine += conditionalLocution.ifRuleString;
									conditionalStringAdded = true;
								}
							}
							
							if (!conditionalStringAdded)
							{
								for (i = 0; i < conditionalLocution.elseIfRuleIDs.length; i++ )
								{
									if (conditionalLocution.elseIfRuleIDs[i] > this.conditionalRules.length - 1) continue;
									if (this.conditionalRules[conditionalLocution.elseIfRuleIDs[i]].evaluate(initiator, responder, other))
									{
										newLod.otherLine += conditionalLocution.elseIfStrings[i];
										conditionalStringAdded = true;
										break;
									}
								}
							}
							
							if (!conditionalStringAdded)
							{
								newLod.otherLine += conditionalLocution.elseString;
							}
							
						}
						else
						{
							if (locution.getType() == "SFDBLabelLocution")
							{
								(locution as SFDBLabelLocution).speaker = "o";
							}
							
							//Debug.debug(this, "realizeDialogue(): initiator locution: " + l);
							newLod.otherLine += locution.renderText(initiator, responder, other, line);
						}
					}
					newInst.lines.push(newLod);
				}
			}

			return newInst;
		}
		
		
		public function requiresOtherToPerform():Boolean
		{
			for each (var lod:LineOfDialogue in this.lines)
			{
				if (lod.otherApproach || lod.otherLine != "")
				{
					return true;
				}
			}
			return false;
		}
		
		
		
		/**********************************************************************
		 * Utility Functions
		 *********************************************************************/

		 public function toString(): String {
			var returnstr:String = new String();
			for (var i:Number = 0; i < this.lines.length; ++i) {
				returnstr += this.lines[i];
				if (i < this.lines.length - 1) {
					//returnstr += "^";
				}
				returnstr += "\n";
			}
			return returnstr;
		}
		
		public function toXMLString():String {
			var returnstr:String = new String();
			returnstr += "<Instantiation id=\"" + this.id + "\" name=\"" + this.name + "\">\n";
			for (var i:Number = 0; i < this.lines.length; ++i) {
				//returnstr += "   ";
				returnstr += this.lines[i].toXMLString();
				returnstr += "\n";
			}
			
			returnstr += "<ToC1>" + toc1.rawString + "</ToC1>\n";
			returnstr += "<ToC2>"+toc2.rawString+"</ToC2>\n";
			returnstr += "<ToC3>"+toc3.rawString+"</ToC3>\n";
			
			returnstr += "<ConditionalRules>\n";
			
			for each (var r:Rule in this.conditionalRules) {
				returnstr += r.toXMLString() + "\n";
			}
			returnstr += "</ConditionalRules>\n";
			
			returnstr += "</Instantiation>\n";
			return returnstr;
		}
		
		public function toXML():String {
			var returnXML:XML;
			
			returnXML = <Instantiation id ={this.id} name={this.name}></Instantiation>;
			returnXML.appendChild(<ToC1>{this.toc1}</ToC1>);
			returnXML.appendChild(<ToC2>{this.toc2}</ToC2>);
			returnXML.appendChild(<ToC3>{this.toc3}</ToC3>);
			
			for (var i:Number = 0; i < this.lines.length; ++i) {
				returnXML.appendChild(new XML(this.lines[i].toXMLString()));
			}
			
			returnXML.appendChild(<ConditionRules/>);
			for each (var r:Rule in this.conditionalRules) {
				returnXML.ConditionRules.appendChild(r.toXML());
			}
			
			return returnXML;
		}
		
		
		public function clone(): Instantiation {
			var i:Instantiation = new Instantiation();
			i.id = this.id;
			i.name = this.name;
			i.lines = new Vector.<LineOfDialogue>();
			for each(var l:LineOfDialogue in this.lines) {
				i.lines.push(l.clone());
			}
			
			for each(var r:Rule in this.conditionalRules) {
				i.conditionalRules.push(r.clone());
			}
			
			
			i.toc1.rawString = this.toc1.rawString;
			i.toc2.rawString = this.toc2.rawString;
			i.toc3.rawString = this.toc3.rawString;
			
			return i;
		}
		
		public static function equals(x:Instantiation, y:Instantiation): Boolean {
			if (x.id != y.id) return false;
			if (x.name != y.name) return false;
			if (x.lines.length != y.lines.length) return false;
			if (x.toc1.rawString != y.toc1.rawString) return false;
			if (x.toc2.rawString != y.toc2.rawString) return false;
			if (x.toc3.rawString != y.toc3.rawString) return false;
			
			for (var i:Number = 0; i < x.conditionalRules.length; ++i) {
				if (!Rule.equals(x.conditionalRules[i], y.conditionalRules[i])) return false;
			}
			
			for (i = 0; i < x.lines.length; ++i) {
				if (!LineOfDialogue.equals(x.lines[i], y.lines[i])) return false;
			}
			return true;
		}
	}

}
