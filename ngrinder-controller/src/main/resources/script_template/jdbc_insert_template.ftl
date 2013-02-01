# -*- coding:utf-8 -*-

# Database insert test. 
#
# This script is auto generated by ngrinder.
#
# @author ${user.userName}
from java.sql import DriverManager
from net.grinder.script.Grinder import grinder
from net.grinder.script import Test
from ${driverPath} import ${jdbcDriver}
from java.util import Random
from java.lang import System
 
test1 = Test(1, "Database insert")
random = Random(long(System.nanoTime()))
 
# Load the JDBC driver.
DriverManager.registerDriver(${jdbcDriver}())
 
def getConnection():
    return DriverManager.getConnection(
        "${url}", "${account}", "${password}")
 
def ensureClosed(object):
    try: object.close()
    except: pass
 
# One time initialisation that cleans out old data.
connection = getConnection()
statement = connection.createStatement()
 
try: statement.execute("drop table ngrinder_insert_test")
except: pass
 
statement.execute("create table ngrinder_insert_test(test_id integer, test_number integer)")
 
ensureClosed(statement)
# ensureClosed(connection)
 
class TestRunner:
    def __call__(self):
        insertStatement = None
 
        try:
            insertStatement = connection.createStatement()
            tmpId = random.nextInt(10240)
            tmpNumber = random.nextInt(10240)
            insertStatement = test1.wrap(insertStatement)
            insertStatement.execute("insert into ngrinder_insert_test values(%d, %d)" % (tmpId, tmpNumber))
 

        finally:
            ensureClosed(insertStatement)
