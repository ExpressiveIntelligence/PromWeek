package PromWeekVisualization
{
	import flare.display.TextSprite;
	import flare.query.Not;
	import flare.util.Shapes;
	import flare.vis.controls.HoverControl;
	import flare.vis.controls.TooltipControl;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.demos.util.GraphUtil;
	import flare.vis.events.SelectionEvent;
	import flare.vis.events.TooltipEvent;
	import flare.vis.events.VisualizationEvent;
	import flare.vis.operator.layout.NodeLinkTreeLayout;
	import flare.vis.Visualization;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.engine.TextJustifier;
	import flash.text.TextField;
	import mx.collections.ArrayCollection;
	import mx.controls.CheckBox;
	import mx.core.UIComponent;
	import spark.components.List;
	import spark.primitives.Rect;
	/**
	 * PromWeekVisTree object. This class is going to be used by us to visualize all the data.
	 * This will make a tree that holds level trace playthroughs.
	 * @author Ryan
	 */
	[Bindable]
	public class PromWeekVisTree extends UIComponent
	{
		private static var _instance:PromWeekVisTree = new PromWeekVisTree()
		// our tree
		var tree:Tree
		// the root. This just has to be here in case we have two unique starts
		var r:NodeSprite
		
		// set up the 'styles' so we can access them elsewheres
		var nodes:Object // default nodes
		var childs:Object
		var edges:Object
		
		// These will be used for dynamic sizing of nodes
		var maxWeight:Number
		var minWeight:Number
		var avgWeight:Number
		var numWeight:Number
		
		// This is used to maintain _ALL_ the IDs in this tree
		public var idCollection:ArrayCollection
		public var idList:Vector.<Number>
		
		public static function getInstance():PromWeekVisTree {
			return _instance
		}
		
		/**
		 * constructor for the PromWeekVisTree object. It initializes all sorts of things.
		 * tree gets a new AS3 Tree object
		 * r gets a pointer to the tree's root
		 * r.data is an abstract object type, so we give it's value "R"
		 * r.name is the DisplayObject instance name (can be referred to in actionscript)
		 */
		public function PromWeekVisTree() {
			if (_instance != null) {
				throw new Error("PromWeekVisTree can only be accessed via PromWeekVisTree.getInstance()")
			}
			
			// initialize the tree
			initTree()
			
			// initialize the Weights, just so it's cool
			maxWeight = minWeight = avgWeight = numWeight = -1
			
			// init the dude 
			idList = new Vector.<Number>()
			idCollection = new ArrayCollection()
			
			/**
			 * These are essentially the "styles" for the tree. 
			 * nodes is what each standard node is
			 * childs is our custom 
			 */
			nodes = new Object()
			nodes.shape = Shapes.SQUARE
			nodes.fillColor = 0xFF4444aa
			nodes.lineColor = 0xdddddddd
			nodes.lineWidth = 1
			nodes.size = 1
			nodes.alpha = 1
			nodes.visible = true
			
			childs = new Object
			childs.shape = Shapes.CIRCLE
			childs.fillColor = 0x8800aaaa
			childs.lineColor = 0xdddddddd
			childs.lineWidth = 0.5
			childs.size = 1.0
			childs.alpha = 1
			childs.visible = true
			
			edges = new Object
			edges.lineColor = 0xffcccccc,
			edges.lineWidth = 1,
			edges.alpha = 1,
			edges.visible = true
			
			tree.nodes.sortBy("depth")
		}
		
		private function initTree():void {
			tree = new Tree()
			r = tree.addRoot()
			r.data.value = new VisNodeDataObj
			r.data.value.addVSG(new VisSocialGameObj("This","Is","Root",0,0))
			r.name = "R"
		}
		
		/**
		 * this is where the tree Visualization is made and all the styles are manipulated.
		 * It returns a Visualization object so it can be passed around all component-like
		 * @return
		 */
		public function drawTree() : Visualization {
			var vis:Visualization = new Visualization(tree)
			vis.bounds = new Rectangle(0, 0, 500, 500)
			vis.x = 125
			vis.y = 125
			
			vis.operators.add(new NodeLinkTreeLayout("topToBottom",5,5,25))
			
			vis.controls.add(new HoverControl(NodeSprite,
				// by default, move highlighted items to front
				HoverControl.MOVE_AND_RETURN,
				// highlight node border on mouse over
				function(e:SelectionEvent):void {
					e.node.lineWidth = 2;
					e.node.lineColor = 0x88ff0000;
				},
				// remove highlight on mouse out
				function(e:SelectionEvent):void {
					e.node.lineWidth = 1
					e.node.lineColor = 0xdddddddd
				})
			);
			
			// Add the mouse-over Tooltip 
			// here we use getToolTipString function to clean the code up a bit!
			vis.controls.add(new TooltipControl(NodeSprite, null,
			function(e:TooltipEvent):void {
				TextSprite(e.tooltip).text = getToolTipString(e.node)
			}
			));
			
			
			/**
			 * Here is where some customization actually gets applied. I had to move it to 
			 * this part of the code because it wasn't working earlier (cool story, right?)
			 * 
			 * Remember those Objects we made back in the constructor? The so-called "styles"?
			 * Well, here is where we actually use them. 
			 * 
			 * The first one simply sets the standard properties on all nodes
			 */
			tree.nodes.setProperties(nodes)
			// this one sets the edges between. This is probably where we'll want to
			// widen and fatten the edges based on frequencies
			tree.edges.setProperties(edges)
			
			/**
			 * this shows how to put a conditional function in to deciding whether or
			 * not to setting a node to the 'style' of childs. 
			 */
			// IMPORTANT THING TO KNOW
			tree.nodes.setProperties(childs, null, 
				function(x:Object):Boolean {
					return (x as NodeSprite).childDegree == 0
				})
			tree.nodes.setProperty("size", 
				function(x:Object):Number {
					var w:Number = (x as NodeSprite).data.value.weight
					//trace("w is: " + w + " the returned thing is: " + (w - minWeight) / (maxWeight - minWeight))
					if(minWeight == maxWeight) return 0.5
					return 0.5 + ((w-minWeight)/(maxWeight-minWeight)) * 1
				},null,null)
			
			vis.update()		
					
			return vis
		}
		
		/**
		 * clears the tree, making it ready to have new stuff added!
		 */
		public function clear():void {
			initTree()
			minWeight = maxWeight = avgWeight = numWeight = 0
			idCollection = new ArrayCollection()
			idList = new Vector.<Number>()
			
		}
		
		/**
		 * Used to generate a tooltip string cleanly, so we don't have a blob of
		 * code in an in-line function in an argument of a function.
		 * @param	node - e.node is useful to use here :D
		 * @return returns a string we want for the tooltip
		 */
		private function getToolTipString(node:NodeSprite):String {
			return node.data.value.name + " /|\ IDS:" + node.data.value.getIDs()
		}
		
		/**
		 * inserts an array of paths, in the format that 
		 * TestTheTree.parseFormattedTraceFileToArray returns.
		 * This is an array of strings.
		 * @param	path- an array of strings
		 */
		public function insertPathArray(path:Array):void {
			for (var i:int = 0; i < path.length ; ++i){
				this.insertPath(r, path[i])
			}
			calculateWeights()
			//trace("Weights calculated: Min/Max/Total: " + minWeight + "," + maxWeight + "," + numWeight)
		}
		
		/**
		 * This is here because of KISS.
		 * @param	num - the weight you just manipulated
		 */
		private function calculateWeights():void{
			travelTreeForWeights(this.r)
			//trace("Total Weight: " + numWeight)
			for each (var v:Number in idList) {
				idCollection.addItem(v)
			}
		}
		
		/**
		 * recursive function to travel the tree for calculating the weights
		 */
		private function travelTreeForWeights(n:NodeSprite):Number {
			var w:Number = n.data.value.weight
			if (n.childDegree == 0) return w
			
			// figure out mins and max-
			if (minWeight == -1 || w < minWeight) minWeight = w
			if (maxWeight == -1 || w > maxWeight) maxWeight = w
						
			// init the result
			var result:Number = 0
			
			// iterate through each of the children
			var tmp:NodeSprite = n.firstChildNode
			while (tmp != null) {
				result += travelTreeForWeights(tmp)
				tmp = tmp.nextNode
			}
			//trace("Result is: " + result)
			numWeight += result
			return result
		}
		
		/*
		 * Tree Helper Functions
		 */
		
		/**
		 * This is the "does this node have this child by it's name" function
		 * @param	current - the node you are checking
		 * @param	name - the string to compare, currently it's a social game.
		 * 				   formatted as such: initiator,responder,game
		 * @return
		 */
		private function hasChildByName(current:NodeSprite, name:String) : NodeSprite{
			if(current.childDegree == 0) return null // no kids? 
			// this is how you iterate through a NodeSprite!
			var tmp:NodeSprite = current.firstChildNode
			// when there are no more children, nextNode will be null, so here's our quit case
			while (tmp != null) {
				// the comparator
				if (tmp.data.value.name == name) {
					return tmp
				}
				// move next!
				tmp = tmp.nextNode
			}
			// nothing found :(
			return null
		}
		
		/**
		 * This function is used by the PWVT class to insert a single path.
		 * 
		 * @param	current - used for recursion. On first pass, it should be called on the root
		 * @param	path - an array of VisSocialGameObj objects. These are typically filled in
		 * 					from TestTheTree.onTextFileLoaded, but make sure to read up on how
		 * 					exactly that happens, as it's quite hairy.
		 */
		private function insertPath(current:NodeSprite, path:Array) : void {
			if (path.length == 0) { // empty path. Don't do anything
				return
			}
			// does current have this child? If so, do some stuff.
			// child will be null if it does not have this child
			var child:NodeSprite = hasChildByName(current,(path[0] as VisSocialGameObj).name)
			if (child) {
				// add the vsg to this node's VNDO
				child.data.value.addVSG(path[0])
				// if path.length is 1 basically, we're at the end of the path
				if (path.length < 2) {
					// and done!
					return
				} else {
					path.shift() // remove the first one
					insertPath(child, path) //insert the rest!
				}
			} else {
				// if we don't already have this ID in the ID list:
				if (idList.indexOf((path[0] as VisSocialGameObj).playerID) == -1)				{
					idList.push((path[0] as VisSocialGameObj).playerID)
				}
				// DEBUG
				//trace("Making new node: " + (path[0] as VisSocialGameObj).name)
				// make a new child node of this node
				var tmp:NodeSprite = new NodeSprite()
				// make a new VisNodeDataObj to work with
				var tmpVNDO = new VisNodeDataObj()
				// add our current VisSocialGameObj to the VNDO
				tmpVNDO.addVSG(path[0] as VisSocialGameObj)
				// set the node's value to this VisNodeDataObj we just made
				tmp.data.value = tmpVNDO
				tree.addChild(current, tmp)
				path.shift() // remove the first one
				insertPath(tmp,path) // insert the remainder
			}			
		}
			
		
		// ***
		// the rest of these functions are kind of not necessary, but I still wanted to leave
		// them in there just because.
		// ***
		
		// code taken from:
		// http://www.java2s.com/Code/Flash-Flex-ActionScript/Development/Generaterandomnumberinarange.htm
		function randomInRange(min:Number, max:Number):Number {
			var scale:Number = max - min + 1;
			return (int)(Math.random() * scale + min)
		}
		
		function testTree() {
			// TEST DATA BEGIN
			// Let's make a set of data:
			var s:Array  = new Array()
			var paths:int = 9
			var length:int = 3
			for (var m:int = 0; m < paths; ++m){
				for (var j:int = 0; j <= length; ++j) {
					//make random capital letters
					var k:int = randomInRange(65, 90)
					s.push(String.fromCharCode(k))
				}
				//trace(s)
				insertPath(r, s)
				s = new Array()
			}
			printTree(r,0)
		}
		
		public function printTree(n:NodeSprite, d:int) : void{
			var s:String = "";
			for (var k:uint = 0; k < d; k++) {
				s += "  ";
			}			
			//trace(s+n.name+"\t"+n.data.value);
			for (var i:uint = 0; i < n.childDegree; ++i) {
				printTree(n.getChildNode(i), d+1);
			}
		}
		
	}

}