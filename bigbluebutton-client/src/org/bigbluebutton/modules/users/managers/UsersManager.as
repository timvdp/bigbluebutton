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
	
	import org.bigbluebutton.common.LogUtil;
	import org.bigbluebutton.common.events.CloseWindowEvent;
	import org.bigbluebutton.common.events.OpenWindowEvent;
	import org.bigbluebutton.core.BBB;
	import org.bigbluebutton.core.managers.UserManager;
	import org.bigbluebutton.main.events.MadePresenterEvent;
	import org.bigbluebutton.main.model.users.events.LowerHandEvent;
	import org.bigbluebutton.main.model.users.events.RaiseHandEvent;
	import org.bigbluebutton.modules.users.events.StartUsersModuleEvent;
	import org.bigbluebutton.modules.users.model.UsersOptions;
	import org.bigbluebutton.modules.users.views.UsersWindow;
	

	public class UsersManager
	{		
		private var dispatcher:Dispatcher;
		private var usersWindow:UsersWindow;
		private var toolbarButtonManager:ToolbarButtonManager;
		
		public function UsersManager(){
			dispatcher = new Dispatcher();
			toolbarButtonManager = new ToolbarButtonManager();		
		}
		
		public function moduleStarted(event:StartUsersModuleEvent):void{
			if (usersWindow == null){
				usersWindow = new UsersWindow();
				usersWindow.partOptions = new UsersOptions();
				
				var e:OpenWindowEvent = new OpenWindowEvent(OpenWindowEvent.OPEN_WINDOW_EVENT);
				e.window = usersWindow;
				dispatcher.dispatchEvent(e);
			}
		}
		
		public function moduleEnded():void{
			var event:CloseWindowEvent = new CloseWindowEvent(CloseWindowEvent.CLOSE_WINDOW_EVENT);
			event.window = usersWindow;
			dispatcher.dispatchEvent(event);
		}
		
		public function handleMadePresenterEvent(e:MadePresenterEvent):void {
			LogUtil.debug("UsersManager :: Got MadePresenterEvent ");

			toolbarButtonManager.removeToolbarButton();
		}
		
		public function handleMadeViewerEvent(e:MadePresenterEvent):void{
			LogUtil.debug("UsersManager :: Got MadeViewerEvent ");
			
			//if(option.showButton)
			{
				toolbarButtonManager.addToolbarButton();
			}
		}

		public function handleLowerHandEvent(e:LowerHandEvent):void{
			
			var myUserId:String = UserManager.getInstance().getConference().getMyUserId();
			
			LogUtil.debug("UsersManager :: Got LowerHandEvent (UserId=" + e.userid + ", MyUserId="+ myUserId + ")");
			
			if(e.userid == myUserId)
			{
				toolbarButtonManager.lowerHand();
			}
		}
		
		public function handleRaiseHandEvent(e:RaiseHandEvent):void{
			
			LogUtil.debug("UsersManager :: Got RaiseHandEvent");
			
			if(e.raised)
				toolbarButtonManager.raiseHand();
			else
				toolbarButtonManager.lowerHand();
		}
	}
}