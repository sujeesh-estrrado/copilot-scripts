IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Rpt_Get_HostelFees_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('


CREATE procedure [dbo].[SP_Rpt_Get_HostelFees_By_Id]                          
@Hostel_Fee_Payment_Id bigint                          
AS                          
                          
BEGIN       
Select * from (        
Select      
ROW_NUMBER() OVER  (PARTITION BY f.Hostel_Fee_Payment_Id Order by f.Hostel_Fee_Payment_Id) AS RNO,                        
f.Hostel_Fee_Payment_Id,                        
(Case when StudenOrEmployee_Status=0 Then ''Student''        
Else ''Employee'' END) As [User],                      
Case when StudenOrEmployee_Status=0 Then c.Candidate_Fname+'' ''+c.Candidate_Mname+'' ''+c.Candidate_Lname        
Else E.Employee_FName+E.Employee_LName END As [UserName],           
(Case when f.StudenOrEmployee_Status=0 Then cc.Course_Category_Name+''-''+d.Department_Name+''-''+cs.Semester_Code         
when f.StudenOrEmployee_Status=1 Then ED.Dept_Name Else '''' End) As Department,                  
f.Invoice_Code_id,                     
i. Invoice_Code_Prefix+f.Invoice_Code+i.Invoice_Code_Suffix as Invoice_code,                    
f.Total_Amount,                        
f.Date,        
STUFF((SELECT distinct '', '' + CONVERT(CHAR(4), t1.[month], 100) + CONVERT(CHAR(4), t1.[month], 120)         
         from Tbl_Hostel_Fee_Payment_Detail t1        
         where f.Hostel_Fee_Payment_Id = t1.Hostel_Fee_Payment_Id        
            FOR XML PATH(''''), TYPE        
            ).value(''.'', ''NVARCHAR(MAX)'')         
        ,1,2,'''') [Month]        
                 
from                          
Tbl_Hostel_Fee_Payment  f          
Inner Join Tbl_Hostel_Fee_Payment_Detail fd on f.Hostel_Fee_Payment_Id =fd.Hostel_Fee_Payment_Id        
Inner Join Tbl_Inventory_Invoice_Code i on f.Invoice_Code_id=i.Invoice_Code_Id         
Left Join Tbl_Candidate_Personal_Det c on f.StudentOrEmployee_Id=c.Candidate_Id and f.StudenOrEmployee_Status=0                       
Left Join Tbl_Course_Duration_Mapping cdm on f.Department_Id=cdm.Duration_Mapping_Id           
Left Join Tbl_Course_Duration_PeriodDetails cdp on cdp.Duration_Period_Id=cdm.Duration_Period_Id            
Left Join Tbl_Course_Department cd on cd.Course_Department_Id=cdm.Course_Department_Id                 
Left Join Tbl_Department d on cd.Department_Id=d.Department_Id                 
Left Join Tbl_Course_Category cc on cd.Course_Category_Id=cc.Course_Category_Id          
Left Join Tbl_Course_Semester cs on cs.Semester_Id =cdp.Semester_Id        
Left Join Tbl_Employee E on f.StudentOrEmployee_Id=E.Employee_Id and f.StudenOrEmployee_Status=1        
Left Join Tbl_Emp_Department ED on ED.Dept_Id=f.Department_Id        
WHERE  f.Delete_Status=0 and f.Hostel_Fee_Payment_Id=@Hostel_Fee_Payment_Id) t      
Where t.RNO=1                            
END

');
END;