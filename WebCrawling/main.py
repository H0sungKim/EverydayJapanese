'''
2022 Hosung.Kim <hyongak516@mail.hongik.ac.kr>
=====================
Web Crawling
---------------------
Issues
* page 하나하나 지정하는거 귀찮음
---------------------
Update 2022.03.23
-----  ------  ------
JLPT    PAGE    WORDS
   5      75      744
   4     104     1037
   3     155     1546
   2     265     2648
   1     325     3246
=====================
'''


from selenium import webdriver

import JSONGenerator
import Util
import time

# https://ja.dict.naver.com/#/jlpt/list?level=5&part=allClass&page=1
def crawlingDict(level, page) :
    result = ""
    FILE_NAME = f"JLPT{level}"
    driver = webdriver.Chrome('/Users/kihoon.kim/Hosung/Project/python/WebCrawling/chromedriver')
    driver.implicitly_wait(time_to_wait=10)
    for p in range(1, page+1) :
        url = f"https://ja.dict.naver.com/#/jlpt/list?level={level}&part=allClass&page={p}"
        # result += f"\n\npage : {p}\n\n"
        driver.get(url)

        words = driver.find_elements_by_css_selector("#my_jlpt_list_template")
        time.sleep(1)
        print(p)
        for i in words :
            result += i.text
        result += "\n"

    driver.quit()

    f = open(f"{FILE_NAME}.txt", "w", encoding="UTF-8")
    f.write(result)
    f.close()
    Util.processText(f"{FILE_NAME}.txt")
    time.sleep(2)
    JSONGenerator.generateJson(FILE_NAME)
    time.sleep(2)
    # CsvGenerator.generateCsv(FILE_NAME)

crawlingDict(5, 75)
crawlingDict(4, 104)
crawlingDict(3, 155)
crawlingDict(2, 265)
crawlingDict(1, 325)
