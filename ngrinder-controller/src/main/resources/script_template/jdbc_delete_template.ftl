# -*- coding:utf-8 -*-

# Database delete test. 
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
 
test1 = Test(1, "Database delete")
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
# statement = connection.createStatement()
 
# You must ensure that the table and records already exist in the database.
# statement.execute("create table ngrinder_delete_test(test_id integer, test_number integer)")
 
# ensureClosed(statement)
# ensureClosed(connection)
 
class TestRunner:
    def __call__(self):
        deleteStatement = None
 
        try:
            deleteStatement = connection.createStatement()
            tmpId = random.nextInt(10240)
            deleteStatement = test1.wrap(deleteStatement)
            deleteStatement.execute("delete from ngrinder_delete_test where test_id=%d" % tmpId)

        finally:
            ensureClosed(deleteStatement)
