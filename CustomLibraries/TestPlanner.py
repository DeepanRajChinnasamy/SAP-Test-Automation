import xlrd
import fileinput
import sys
from os import path
from _ast import Assert

class TestPlanner:

    def prepare_execute_tags_string(self,excelWBNameWithExt):
        #testPlannerPath = path.dirname(__file__) + 'Test_Planner/{}.xlsx'.format('CRM_Test_Planner')
        testPlannerPath = 'Test_Planner/'+excelWBNameWithExt
        #print("Excel path: "+testPlannerPath)
        wb = xlrd.open_workbook(testPlannerPath)
        sheet = wb.sheet_by_name("TestCases")
        number_of_rows = sheet.nrows
        
        list_value = []
        
        for row in range(1, number_of_rows):
            
            Runmode = (sheet.cell(row, 1).value)
            TC_id = (sheet.cell(row, 2).value)
    
            
            if 'Yes' in Runmode:
                    list_value.append('id='+TC_id+'OR')
   
        strTags = ''.join(list_value)
        strTags=strTags[:-2]
        #print("Total tags: "+strTags)
        #return 'robot -d Results -i {} TestSuites/*'.format(strTags[:-2])
        #return 'robot -d Results -i '+strTags+' TestSuites/*'
        return strTags


if __name__ == '__main__':
    # User will pass the testplanner excel name as argument to this method when run 
    arg=sys.argv[1]
    #print("User input of excel workbook name with extention :"+arg)
    t=TestPlanner()
    print(t.prepare_execute_tags_string(arg))
	
