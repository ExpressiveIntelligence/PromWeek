/*
 * ComboCheck
 * v1.1
 * Arcadio Carballares Martín, 2009
 * http://www.carballares.es/arcadio
 */
package com.arcadiocarballares {
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.ComboBox;
	import mx.core.ClassFactory;
	import mx.events.FlexEvent;
	
	[Event(name="addItem", type="flash.events.Event")]
	
    public class ComboCheck extends ComboBox {
    	private var _selectedItems:ArrayCollection;
    	
    	[Bindable("change")]
    	[Bindable("valueCommit")]
    	[Bindable("collectionChange")]
    	
    	public function set selectedItems(value:ArrayCollection):void {
    		_selectedItems=value;
    	}
        
    	public function get selectedItems():ArrayCollection {
    		return _selectedItems;
    	}
    	
        public function ComboCheck() {
            super();
            addEventListener("comboChecked", onComboChecked);
            addEventListener(FlexEvent.CREATION_COMPLETE, onCreationComplete);
            var render:ClassFactory = new ClassFactory(ComboCheckItemRenderer);
		    itemRenderer=render;
		    var myDropDownFactory:ClassFactory = new ClassFactory(ComboCheckDropDownFactory);
        	super.dropdownFactory=myDropDownFactory;
        	selectedItems=new ArrayCollection();
        }
        
        private function onCreationComplete(event:Event):void {
        	dropdown.addEventListener(FlexEvent.CREATION_COMPLETE, onDropDownComplete);
        }
        
        private function onDropDownComplete(event:Event):void {
        	trace ("dropdown complete!");
        }
        
        private function onComboChecked(event:ComboCheckEvent):void {
        	var obj:Object=event.obj;
        	var index:int=selectedItems.getItemIndex(obj);
        	if (index==-1) {
        		selectedItems.addItem(obj);
        	} else {
        		selectedItems.removeItemAt(index);
        	}
        	
        	if (selectedItems.length>1) {
        		text='multiple'
        	}
        	if (selectedItems.length==1) {
        		text=selectedItems.getItemAt(0)[labelField];
        	}
        	if (selectedItems.length<1) {
        		text='';
        	}
        	
        	dispatchEvent(new Event("valueCommit"));
        	dispatchEvent(new Event("addItem"));
        }
        
    }
}