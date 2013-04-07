/**
* BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
* 
* Copyright (c) 2012 BigBlueButton Inc. and by respective authors (see below).
*
* This program is free software; you can redistribute it and/or modify it under the
* terms of the GNU Lesser General Public License as published by the Free Software
* Foundation; either version 3.0 of the License, or (at your option) any later
* version.
* 
* BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
* WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
* PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
*
* You should have received a copy of the GNU Lesser General Public License along
* with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
*
*/

package org.bigbluebutton.modules.users.managers
{
	import com.asfusion.mate.events.Dispatcher;
	
	import org.bigbluebutton.common.IBbbModuleWindow;
	import org.bigbluebutton.common.LogUtil;
	import org.bigbluebutton.common.Role;
	import org.bigbluebutton.common.events.CloseWindowEvent;
	import org.bigbluebutton.common.events.OpenWindowEvent;
	import org.bigbluebutton.common.events.ToolbarButtonEvent;
	import org.bigbluebutton.core.managers.UserManager;
	import org.bigbluebutton.main.events.MadePresenterEvent;
	import org.bigbluebutton.modules.users.views.ToolbarButton;
			
	public class ToolbarButtonManager {		
		private var button:ToolbarButton;
		private var isRaisedHand:Boolean = false;
		private var globalDispatcher:Dispatcher;
		
		private var buttonShownOnToolbar:Boolean = false;
		private var isRoleViewer:Boolean = false;
		
		public function ToolbarButtonManager() {
			globalDispatcher = new Dispatcher();
			button = new ToolbarButton();			

			isRoleViewer = (UserManager.getInstance().getConference().getMyRole() == Role.VIEWER);
		}
													
		public function addToolbarButton():void {
			LogUtil.debug("Users::addToolbarButton");
			
			if ((button != null) && (!buttonShownOnToolbar) && isRoleViewer) {
				button = new ToolbarButton();
				var event:ToolbarButtonEvent = new ToolbarButtonEvent(ToolbarButtonEvent.ADD);
				event.button = button;
				event.module="Users";
				globalDispatcher.dispatchEvent(event);	
				buttonShownOnToolbar = true;	
				button.enabled = true;		
			}
		}
			
		public function removeToolbarButton():void {
			LogUtil.debug("Users::removeToolbarButton");
			
			if (buttonShownOnToolbar) {
				var event:ToolbarButtonEvent = new ToolbarButtonEvent(ToolbarButtonEvent.REMOVE);
				event.button = button;
				globalDispatcher.dispatchEvent(event);	
				buttonShownOnToolbar = false;			
			}
		}
	}
}
