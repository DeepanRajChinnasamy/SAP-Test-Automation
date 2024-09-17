import pythoncom
import win32com.client
import time
#from pythoncom import com_error
import robot.libraries.Screenshot as screenshot
import os
from robot.api import logger


class CustomSAPGuiLib:
    """The SapGuiLibrary is a library that enables users to create tests for the Sap Gui application

    The library uses the Sap Scripting Engine, therefore Scripting must be enabled in Sap in order for this library to work.

    = Opening a connection / Before running tests =

    First of all, you have to *make sure the Sap Logon Pad is started*. You can automate this process by using the
    AutoIT library or the Process Library.

    After the Sap Login Pad is started, you can connect to the Sap Session using the keyword `connect to session`.

    If you have a successful connection you can use `Open Connection` to open a new connection from the Sap Logon Pad
    or `Connect To Existing Connection` to connect to a connection that is already open.

    = Locating or specifying elements =

    You need to specify elements starting from the window ID, for example, wnd[0]/tbar[1]/btn[8]. In some cases the SAP
    ID contains backslashes. Make sure you escape these backslashes by adding another backslash in front of it.

    = Screenshots (on error) =

    The SapGUILibrary offers an option for automatic screenshots on error.
    Default this option is enabled, use keyword `disable screenshots on error` to skip the screenshot functionality.
    Alternatively, this option can be set at import.
    """
    __version__ = '1.1'
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'

    def __init__(self, screenshots_on_error=True, screenshot_directory=None):
        """Sets default variables for the library
        """
        self.explicit_wait = float(0.0)

        self.sapapp = -1
        self.session = -1
        self.connection = -1

        self.take_screenshots = screenshots_on_error
        self.screenshot = screenshot.Screenshot()

        if screenshot_directory is not None:
            if not os.path.exists(screenshot_directory):
                os.makedirs(screenshot_directory)
            self.screenshot.set_screenshot_directory(screenshot_directory)

    def selectTree(self, tree_id):
        self.session.findById(tree_id).selectItem("          5", "&Hierarchy")
        self.session.findById(tree_id).ensureVisibleHorizontalItem("          5", "&Hierarchy")
        self.session.findById(tree_id).doubleClickItem("          5", "&Hierarchy")

    def selectInvoiceTree(self, tree_id):
        self.session.findById(tree_id).selectItem("          2", "&Hierarchy")
        self.session.findById(tree_id).ensureVisibleHorizontalItem("          2", "&Hierarchy")
        self.session.findById(tree_id).doubleClickItem("          2", "&Hierarchy")