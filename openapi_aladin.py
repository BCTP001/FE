import urllib.request
import urllib.parse
from bs4 import BeautifulSoup

# #### Reference #####
# 1. APIBook
#  	 https://docs.google.com/document/d/1mX-WxuoGs8Hy-QalhHcvuV17n50uGI2Sg_GHofgiePE/edit?tab=t.0"
# 2. Create ttbkey
#	 https://www.aladin.co.kr/ttb/wblog_manage.aspx

#### 1. Search query string type against database" #####
url = 'http://www.aladin.co.kr/ttb/api/ItemSearch.aspx'
data = urllib.parse.urlencode({
	'ttbkey' : 'ttbts25261620001',
    'Query': '나미야 잡화점',
    'QueryType': 'Title',
    'SearchTarget': 'All',
    'Output': 'XML'
})

# #### 2. Search query ISBN against database" #####
# url= 'http://www.aladin.co.kr/ttb/api/ItemLookUp.aspx'

# data = urllib.parse.urlencode({
# 	'ttbkey' : 'ttbts25261620001',
# 	'ItemId': 'K252830652',
#     'Output': 'XML'
# })
con = urllib.request.urlopen(url +'?' + data)
objectXml = con.read()
con.close()

soup = BeautifulSoup(objectXml,features='xml')
result = soup.find('error')
import pdb
pdb.set_trace()
# 에러가 아닌 경우.
if result is None:
	result_item = soup.find('item')
	print(result_item.find('title').text)
else:
	print(result.find('errorMessage').text)