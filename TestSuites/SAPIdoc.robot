*** Settings ***
Resource    ../Resource/ObjectRepositories/CustomVariables.robot
#Library    Browser
Library    ScreenCapLibrary

*** Test Cases ***
ValidatSAP
     open sap logon window    ${SAPGUIPATH}    ${SAPUSERNAME}    ${SAPPASSWORD}    ${ENTERBUTTON}    ${CONNECTION}    ${continuebutton}
     run transaction    /nWE02
     sapguilibrary.input text     ${idocnumberwe02}    135317794
     sapguilibrary.input text    /app/con[0]/ses[0]/wnd[0]/usr/tabsTABSTRIP_IDOCTABBL/tabpSOS_TAB/ssub%_SUBSCREEN_IDOCTABBL:RSEIDOC2:1100/ctxtCREDAT-LOW    ${EMPTY}
     send vkey    8
     sapguilibrary.select node    /app/con[0]/ses[0]/wnd[0]/shellcont/shell    Datarecords    expand=True
     sapguilibrary.select node    /app/con[0]/ses[0]/wnd[0]/shellcont/shell    000001    expand=True
     sapguilibrary.select node    /app/con[0]/ses[0]/wnd[0]/shellcont/shell    000002    expand=True
     sapguilibrary.select node link    /app/con[0]/ses[0]/wnd[0]/shellcont/shell   000003   Spalte1
     ${val}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tblIDOC_TREE_CONTROLINT_SEG_CONTROL/txtINT_SEG-STRING[1,1]
     ${val1}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tblIDOC_TREE_CONTROLINT_SEG_CONTROL/txtINT_SEG-STRING[1,1]
     ${val2}=    SapGuiLibrary.Get Value    /app/con[0]/ses[0]/wnd[0]/usr/tblIDOC_TREE_CONTROLINT_SEG_CONTROL/txtINT_SEG-STRING[1,1]
     log to console    ${val}
