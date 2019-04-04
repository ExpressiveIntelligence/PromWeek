import MySQLdb

#this part needs to be run locally for some reason, or we need to get the port that the server uses
db = MySQLdb.connect(host="db-01.soe.ucsc.edu",user="promweek_test",passwd="A5kCqFiKHWh85irU",db="promweek_test")


cursor = db.cursor()
query = "SELECT HashKey FROM LevelTraceAnalysis"
cursor.execute(query)

#get all the results
rows = cursor.fetchall()

#open a file for writing
f = open("bigasslistofleveltraces.txt",'w')

#because we can't access the DB for some reason, here's our test :D
#rows = open("testtuples.txt",'r')


#define the delinneator between each level trace
delinneator = ">"

#go through each tuple in rows
for row in rows:
    #row[0] is a string, let's split it via |
    tmpstrlist = row[0].split('|')
    #go through each of the chunks (things between the |'s)
    for chunk in tmpstrlist:
        #write each one in a line
        f.write(chunk + "\n")
    #when each game is done, put the delinneator in and a newline :D
    f.write(delinneator + "\n")

#don't forget to close the file!
f.close()
