IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Department_Fine]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Department_Fine]        
        
AS        
        
BEGIN        
        
Select        
DF.Dept_Fine_Id,        
DF.Candidate_Id,        
CP.Candidate_Fname+'' ''+CP.Candidate_Mname+'' ''+CP.Candidate_Lname as Candidate_Name,       
SR.Student_Reg_No as [Admission Number],      
CC.Course_Category_Name+'' ''+D.Department_Name as Class,        
DF.Dept_Fine_Amount,      
DF.Dept_Fine_Reason,      
DF.Dept_Fine_Date ,      
CC.Course_Category_Id,        
D.Department_Id,    
Case when Department_Fine_Payment_Id IS NULL Then ''Not Paid''    
Else ''Paid'' End As PaymentStatus,    
ISNULL(Department_Fine_Payment_Id,0) As Department_Fine_Payment_Id    
        
From dbo.Tbl_Department_Fine   DF        
        
LEFT JOIN dbo.Tbl_Candidate_Personal_Det CP  on CP.Candidate_Id=DF.Candidate_Id        
LEFT JOIN dbo.Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=DF.Duration_Mapping_Id        
LEFT JOIN dbo.Tbl_Course_Department CD on CD.Course_Department_Id=CDM.Course_Department_Id         
LEFT JOIN dbo.Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id      
LEFT JOIN dbo.Tbl_Department D on D.Department_Id=CD.Department_Id      
LEFT JOIN dbo.Tbl_Student_Registration  SR on SR.Candidate_Id=CP.Candidate_Id      
LEFT JOIN dbo.Tbl_Department_Fine_Payment DP on  DP.Dept_Fine_Id=DF.Dept_Fine_Id    
        
END 

');
END;