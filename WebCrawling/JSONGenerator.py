def generateJson(file) :
    f = open(f"{file}.txt", "r", encoding="UTF-8")
    txt = f.read().split("\n")
    f.close()
    txtData = ""
    data="{"
    for i in range(len(txt)//3) :
        data += f"\n\t\"{txt[3*i]}\": \"{txt[3*i+2]}\","
        txtData += f"{txt[3*i]}\n{txt[3*i+2]}\n"

    data = data[:-1] + "\n}"
    f = open(f"{file}.txt", "w", encoding="UTF-8")
    f.write(txtData[:-1])
    f.close()
    jsonF = open(f"{file}.json", "w", encoding="UTF-8")
    jsonF.write(data)
    jsonF.close()