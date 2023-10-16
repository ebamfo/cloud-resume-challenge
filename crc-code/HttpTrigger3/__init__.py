import logging
import os
import azure.functions as func
from azure.data.tables import TableClient, UpdateMode
from azure.core.exceptions import ResourceExistsError, HttpResponseError
import json

func.HttpResponse.mimetype = 'application/json'
func.HttpResponse.charset = 'utf-8'
    
def main(req: func.HttpRequest) -> func.HttpResponse:
        with TableClient.from_connection_string(conn_str=os.environ['CONNECTION_STR'], table_name="ViewsCounter") as table:

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
            

        
