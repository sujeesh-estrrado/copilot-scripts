IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_DriverRouteDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_DriverRouteDetails] 
   @Employee_Id bigint
    
as    
Begin    
    
SELECT    distinct RD.Route_Id, D.Employee_Id,E.Employee_FName+'' ''+Employee_LName as Employeename,E.Employee_Mobile,RD.Route_Name,Vd.Vehicle_Name,        
Vd.Vehicle_Number      
 
FROM         Tbl_Vehicle_details Vd INNER JOIN
                      Tbl_Employee E INNER JOIN
                      Tbl_DriverDetails D ON E.Employee_Id = D.Employee_Id ON 
                      Vd.Vehicle_Driver_Id = E.Employee_Id CROSS JOIN
                      Tbl_Vehicle_Route_Mapping VR  CROSS JOIN
                      Tbl_RouteDetails RD where D.Employee_Id=@Employee_Id 
End
');
END;