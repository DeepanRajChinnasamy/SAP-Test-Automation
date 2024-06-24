
import pandas as pd
import xml.etree.ElementTree as ET

def getMetrics(file_name):
	tree = ET.parse(file_name)
	root = tree.getroot()
	print(root)
	onlytag = []
	result = []
	goround = len(list(tree.findall('.//suite/suite')))
	TagsTagCount= len(list(tree.findall('./tags/tag')))
	print("Goround=", goround)
	print("TagsCount=", TagsTagCount)
	for tagname in tree.findall('.//suite//test//tag'):
		if(tagname.text).__contains__("id="):
			onlytag.append(tagname.text.strip("id="))
	if(goround>0):
		print("This has suite/suite/test tag - Probably mutiple result mergred on this XML")
		i=0
		for suite in tree.findall('.//suite/suite'):
			sid=suite.attrib.get("id")
			sname = suite.attrib.get("name")
			for measure in suite.findall('./test'):                          #Get all 'measure' tag
				#tid = measure.attrib.get("id")
				tid = ""
				tname = measure.attrib.get("name")    #Get Node
				status=measure.find("status").attrib.get("status")
				failr=measure.find("status").text
				if(TagsTagCount==0):
					tid=onlytag[i]
				else:
					for tags in measure.findall('./tags/tag'):
						if(tags.text.find("id=")>-1):
							tid=tags.text.strip("id=")
				i+=1
				result.append(dict(suiteid=sid,suitename=sname,testid=tid,testname=tname, status=status,failReason=failr))
	if(goround==0):
		print("This is direct suite/test")
		i = 0
		for suite in root.iter('suite'):
			sid = suite.attrib.get("id")
			sname = suite.attrib.get("name")
			for measure in suite.iter('test'):                         #Get all 'measure' tag
				#tid = measure.attrib.get("id")
				tid = ""
				tname = measure.attrib.get("name")    #Get Node
				status=measure.find("status").attrib.get("status")
				failr=measure.find("status").text
				if (TagsTagCount == 0):
					tid = onlytag[i]
				else:
					for tags in measure.findall('./tags/tag'):
						if((tags.text.find("id="))>-1):
							tid=tags.text.strip("id=")
				i+=1
				result.append(dict(suiteid=sid,suitename=sname,testid=tid,testname=tname, status=status,failReason=failr))

	return result
filename="output"
df = pd.DataFrame(getMetrics("Results/"+filename+".xml"), columns=["suiteid","suitename","testid","testname", "status", "failReason"])          #Form Dataframe
print(df)

df.to_csv("Results/"+filename+".csv")     #Write to CSV.