# crawling했을 때 자꾸 빈 줄이 추가되는 버그때문에 빈줄 지워주는 함수
def processText(file) :

    f = open(file, "r", encoding="UTF-8")

    data = ""
    while True :
        line = f.readline()

        if not line :
            break
        if line != "\n" :
            data += line
    f.close()
    data = data[:-1]
    nf = open(file, "w", encoding="UTF-8")
    nf.write(data)
    nf.close()