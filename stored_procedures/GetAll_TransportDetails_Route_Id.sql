IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetAll_TransportDetails_Route_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[GetAll_TransportDetails_Route_Id]        
          
@Route_Id bigint          
AS                      
BEGIN           
select    
distinct TA.Student_Transport_Id,           
TA.Student_Employee_Status,          
TA.Student_Employee_Id,          
TA.RouteStopId,          
RD.Route_Id,          
RD.Route_Name,        
RS.Route_Stop_Name,        
TA.Leaving_Date,        
Vd.Vehicle_Name,          
Vd.Vehicle_Number,          
case when TA.Student_Employee_Status=''true''             
then            
''Employee''            
Else            
''Student'' end as Type,            
case when TA.Student_Employee_Status=''true''             
then             
            
(select Tbl_Employee.Employee_FName+'' ''+Employee_LName as Employeename  from Tbl_Employee             
where Tbl_Employee.Employee_Id=TA.Student_Employee_Id)            
             
else             
            
(Select Tbl_Candidate_Personal_Det.Candidate_Fname+'' ''+Tbl_Candidate_Personal_Det.Candidate_Mname+'' ''+Tbl_Candidate_Personal_Det.Candidate_Lname as CandidateName             
            
 FROM  Tbl_Candidate_Personal_Det                     
 where Tbl_Candidate_Personal_Det.Candidate_Id=TA.Student_Employee_Id)                     
 end as StudentEmpName            
          
from Tbl_Transport_Admission TA          
          
inner join Tbl_Route_Settings RS on RS.Route_Set_Id= TA.RouteStopId          
inner join Tbl_RouteDetails RD on RD.Route_Id = RS.Route_Id          
inner join Tbl_Vehicle_Route_Mapping VR on VR.Route_Id = RS.Route_Id          
inner join Tbl_Vehicle_details Vd on Vd.Vehicle_Id = VR.Vehicle_Id          
          
where RS.Route_Id=@Route_Id          
          
END
    ')
END
