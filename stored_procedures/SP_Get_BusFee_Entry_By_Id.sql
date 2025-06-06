IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_BusFee_Entry_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Get_BusFee_Entry_By_Id]            
@Transport_Fees_Id bigint        
AS                
                
BEGIN                
                
Select  
f.Transport_Fees_Id,    
fd.RouteFeeId,     
StudentOrEmployee_Id,               
(Case when StudenOrEmployee_Status=0 Then ''Student''    
Else ''Employee'' END) As [User],                  
Case when StudenOrEmployee_Status=0 Then c.Candidate_Fname+'' ''+c.Candidate_Mname+'' ''+c.Candidate_Lname    
Else E.Employee_FName+E.Employee_LName END As [UserName],              
f.Invoice_Code_id,                 
i. Invoice_Code_Prefix+f.Invoice_Code+i.Invoice_Code_Suffix as Invoice_code,                
f.Total_Amount,                    
f.Date,    
f.Department_Id,  
rs.Route_Set_Id,  
rs.Route_Stop_Name,  
(Case when StudenOrEmployee_Status=0 Then cc.Course_Category_Name+''-''+d.Department_Name+''-''+cs.Semester_Code     
Else ED.Dept_Name End) As Department                  
from                      
Tbl_Transport_Fees  f      
Inner Join Tbl_Transport_Fees_Details fd on f.Transport_Fees_Id =fd.Transport_Fees_Id    
Inner Join Tbl_Inventory_Invoice_Code i on f.Invoice_Code_Id=i.Invoice_Code_Id  
Inner Join Tbl_Transport_Route_Fee rf On  rf.RouteFeeId=fd.RouteFeeId  
Inner Join Tbl_Route_Settings rs on rs.Route_Set_Id=rf.RouteStopId  
Left Join Tbl_Candidate_Personal_Det c on f.StudentOrEmployee_Id=c.Candidate_Id  and f.StudenOrEmployee_Status=0                 
Left Join Tbl_Course_Duration_Mapping cdm on f.Department_Id=cdm.Duration_Mapping_Id       
Left Join Tbl_Course_Duration_PeriodDetails cdp on cdp.Duration_Period_Id=cdm.Duration_Period_Id        
Left Join Tbl_Course_Department cd on cd.Course_Department_Id=cdm.Course_Department_Id             
Left Join Tbl_Department d on cd.Department_Id=d.Department_Id             
Left Join Tbl_Course_Category cc on cd.Course_Category_Id=cc.Course_Category_Id      
Left Join Tbl_Course_Semester cs on cs.Semester_Id =cdp.Semester_Id    
Left Join Tbl_Employee E on f.StudentOrEmployee_Id=E.Employee_Id and f.StudenOrEmployee_Status=1    
Left Join Tbl_Emp_Department ED on ED.Dept_Id=f.Department_Id    
WHERE  f.Transport_Fees_Id=@Transport_Fees_Id                
END
    ');
END
