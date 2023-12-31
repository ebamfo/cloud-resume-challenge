import logging
import os
import azure.functions as func
import json

from azure.data.tables import TableClient, UpdateMode
from azure.core.exceptions import ResourceExistsError, HttpResponseError

func.HttpResponse.mimetype = 'application/json'
func.HttpResponse.charset = 'utf-8'
    
def main(req: func.HttpRequest) -> func.HttpResponse:
        

        with TableClient.from_connection_string(conn_str=os.environ['CONNECTION_STR'], table_name="ViewsCounter") as table:
            
            my_entity = {
            "PartitionKey": "pk-01",
            "RowKey": "rk-01",
            "CurrentCounter": 0
            }
            
            # Create a table in case it does not already exist
            try:
                table.create_table()
            except HttpResponseError:
                 print("Table already exists")
            
            # Create entity in case it does not exist ie table rows and default values #1
            try:
                table.create_entity(entity=my_entity)
            except ResourceExistsError:
                print("Entity already exists")

            #Get Entity
            updated_entity = table.get_entity(partition_key="pk-01", row_key="rk-01")

            if req.method=="GET":
                current_view_num=updated_entity["CurrentCounter"]

                return func.HttpResponse(json.dumps(updated_entity))
            
            if req.method=="POST":
                  
                #Increase view counter
                updated_entity["CurrentCounter"]=updated_entity["CurrentCounter"] + 1

                #Updating db with new counter
                table.update_entity(mode=UpdateMode.REPLACE, entity=updated_entity)

                current_view_num=updated_entity["CurrentCounter"]

                return func.HttpResponse(json.dumps(updated_entity))
            

        
