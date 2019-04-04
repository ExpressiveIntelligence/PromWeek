package com.arcadiocarballares {
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.controls.List;
	import mx.controls.listClasses.*;
	
	[Event(name="comboChecked", type="com.arcadiocarballares.ComboCheckEvent")]

    public class ComboCheckDropDownFactory extends List {

        private var index:int=0;
        public function ComboCheckDropDownFactory(): void {
            addEventListener("comboChecked", onComboChecked);
        }

        override protected function mouseEventToItemRenderer(event:MouseEvent):IListItemRenderer {
            var row:IListItemRenderer = super.mouseEventToItemRenderer(event);
            if (row!=null) {
            	index=itemRendererToIndex(row);
            }
            return null;
        }
	    private function onComboChecked (event:Event):void {
	    	var myComboCheckEvent:ComboCheckEvent=new ComboCheckEvent(ComboCheckEvent.COMBO_CHECKED);
	    	myComboCheckEvent.obj=ComboCheckEvent(event).obj;
	        owner.dispatchEvent(myComboCheckEvent);
	    }
    }
}