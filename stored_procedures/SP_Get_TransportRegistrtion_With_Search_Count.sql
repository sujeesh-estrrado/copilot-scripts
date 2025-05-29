IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_TransportRegistrtion_With_Search_Count]')
    AND type = N'P'
)
BEGIN
    EXEC('
                                     
CREATE procedure [dbo].[SP_Get_TransportRegistrtion_With_Search_Count]   
  
@SearchTerm varchar(100)      
                                  
AS                                      
BEGIN         
                                     
SELECT ROW_NUMBER() over (ORDER BY Student_Transport_Id DESC) AS RowNumber,   
     
 TA.Student_Transport_Id as ID,   
  
case when TA.Student_Employee_Status=''true''             
then             
            
(select Tbl_Employee.Employee_FName+'' ''+Employee_LName as [Employee Name]  from Tbl_Employee   
            
where Tbl_Employee.Employee_Id=TA.Student_Employee_Id)            
             
else             
            
(Select Tbl_Candidate_Personal_Det.Candidate_Fname+'' ''+Tbl_Candidate_Personal_Det.Candidate_Mname+'' ''+Tbl_Candidate_Personal_Det.Candidate_Lname as [Candidate Name]             
    
 FROM  Tbl_Candidate_Personal_Det    
                   
 where Tbl_Candidate_Personal_Det.Candidate_Id=TA.Student_Employee_Id)  
                     
 end as [Name],    
  
case when TA.Student_Employee_Status=''true''             
then            
''Employee''            
Else            
''Student'' end as Type,   
  
RD.Route_Name as [Route Name],   
  
Vd.Vehicle_Name as [Vehicle Name],   
         
Vd.Vehicle_Number as [Vehicle Number],   
  
RS.Route_Stop_Name as [Route Stop Name],  
  
TA.Joining_Date as [Joining Date],  
        
TA.Leaving_Date as [Leaving Date]              
                 
          
from Tbl_Transport_Admission TA          
          
inner join Tbl_Route_Settings RS on RS.Route_Set_Id= TA.RouteStopId   
         
inner join Tbl_RouteDetails RD on RD.Route_Id = RS.Route_Id    
        
inner join Tbl_Vehicle_Route_Mapping VR on VR.Route_Id = RS.Route_Id   
         
inner join Tbl_Vehicle_details Vd on Vd.Vehicle_Id = VR.Vehicle_Id  
   
  
WHERE (TA.Student_Employee_Id like  ''''+ @SearchTerm+''%''   
  
      
      
or TA.Student_Employee_Status like  ''''+ @SearchTerm+''%''   
  
or  Route_Name like  ''''+ @SearchTerm+''%''  
  
or  Route_Stop_Name like  ''''+ @SearchTerm+''%''   
  
or  Vehicle_Name like  ''''+ @SearchTerm+''%''   
  
or  Vehicle_Number like  ''''+ @SearchTerm+''%''   
  
or  Joining_Date like  ''''+ @SearchTerm+''%''    
  
or  Leaving_Date like  ''''+ @SearchTerm+''%''      
      
)           
            
end

    ')
END
GO