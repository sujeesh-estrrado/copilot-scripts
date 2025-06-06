IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_Transport_Registrtion_Without_Search_Count]') 
    AND type = N'P'
)
BEGIN
    EXEC('
                                       
CREATE procedure [dbo].[SP_Get_Student_Transport_Registrtion_Without_Search_Count]     
                                  
AS                                      
BEGIN         
                                     
SELECT  ROW_NUMBER() over (ORDER BY Student_Transport_Id DESC) AS RowNumber,  
  
 TA.Student_Transport_Id as ID,  
  
SR.Student_Reg_No as [Admission Number],  
  
case when TA.Student_Employee_Status=''false''  
             
then             
            
(Select Tbl_Candidate_Personal_Det.Candidate_Fname+'' ''+Tbl_Candidate_Personal_Det.Candidate_Mname+'' ''+Tbl_Candidate_Personal_Det.Candidate_Lname as CandidateName             
         
 FROM  Tbl_Candidate_Personal_Det    
                   
 where Tbl_Candidate_Personal_Det.Candidate_Id=TA.Student_Employee_Id)  
                     
 end as [Student Name],  
  
CC.Course_Category_Name+''-''+D.Department_Name as [Class],            
          
RD.Route_Name as [Route Name],   
       
RS.Route_Stop_Name as [Route Stop Name],  
  
Vd.Vehicle_Name as [Vehicle Name],  
          
Vd.Vehicle_Number as [Vehicle Number],  
   
TA.Joining_Date as [Joining Date]   
  
         
FROM  Tbl_Transport_Admission TA    
    
    
LEFT JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id= TA.Student_Employee_Id     
    
left join Tbl_Student_Registration SR on SR.Candidate_Id=CPD.Candidate_Id    
                
left join Tbl_Course_Category CC on CC.Course_Category_Id=SR.Course_Category_Id  
                 
left join Tbl_Department D on D.Department_Id=SR.Department_Id     
          
inner join Tbl_Route_Settings RS on RS.Route_Set_Id= TA.RouteStopId   
         
inner join Tbl_RouteDetails RD on RD.Route_Id = RS.Route_Id    
        
inner join Tbl_Vehicle_Route_Mapping VR on VR.Route_Id = RS.Route_Id   
         
inner join Tbl_Vehicle_details Vd on Vd.Vehicle_Id = VR.Vehicle_Id  
  
WHERE Leaving_Date is NULL and Student_Employee_Status=''false''           
            
end

    ')
END
