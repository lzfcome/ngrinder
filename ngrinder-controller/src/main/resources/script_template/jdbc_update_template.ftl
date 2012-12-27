# -*- coding:utf-8 -*-

# Database update test. 
#
# This script is auto generated by ngrinder.
#
# @author ${user.userName}
from java.sql import DriverManager
from net.grinder.script.Grinder import grinder
from net.grinder.script import Test
from ${driverPath} import ${jdbcDriver}
 
test1 = Test(1, "Database update")
 
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
 
# You must ensure that the table and records already exist in the database.
# statement.execute("create table ngrinder_update_temp(thread integer, run integer)")
 
ensureClosed(statement)
ensureClosed(connection)
 
class TestRunner:
    def __call__(self):
        connection = None
        updateStatement = None
 
        try:
            connection = getConnection()
            updateStatement = connection.createStatement()
 
            insertStatement = test1.wrap(insertStatement)
            updateStatement.execute("update ngrinder_update_temp set run=%d where thread=%d" %
                                   (grinder.threadNumber, grinder.runNumber))

        finally:
            ensureClosed(updateStatement)
            ensureClosed(connection)