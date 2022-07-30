SET /p soql=<sql.txt
sfdx force:data:soql:query -q  "%soql%" -r=csv -u='b2b' > c:\results\result1.csv