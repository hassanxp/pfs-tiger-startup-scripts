import sys
import sqlite3

startDate = sys.argv[1]
endDate = sys.argv[2]
expTime = sys.argv[3]

db = '/projects/HSC/PFS/Subaru/registry.sqlite3'

query = ('select r.visit from raw r inner join raw b on r.visit = b.visit and r.arm="r" and b.arm="b" and r.pfsDesignId=0xdeadbeef and r.expTime > :expTime and r.dateObs between date(:startDate) and date(:endDate);')

# query = ('select * from raw where pfsDesignId=0xdeadbeef and expTime > 1000 and arm in ("b", "r") and dateObs between date(:startDate) and date(:endDate);')

# Open registry in read-only mode
conn = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
cursor = conn.cursor()

visits = set()

for row in cursor.execute(query, {"expTime": expTime, "startDate": startDate, "endDate": endDate}):
    visits.add(row[0])

visitStr = ""
for visit in sorted(visits):
    visitStr += f'{visit}^'
visitStr = visitStr.rstrip('^')

print(visitStr)
