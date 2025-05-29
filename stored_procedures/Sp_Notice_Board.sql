IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Notice_Board]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Notice_Board]  
  (  
  @flag bigint=0  
  )  
as  
BEGIN  
if(@flag=0)  
begin  
   select distinct Department_Id as Department_Id,Department_Name as Department_Name from Tbl_Department 
end
else if (@flag=1)
begin
  select distinct Course_Level_Id as Course_Level_Id,Course_Level_Name as Course_Level_Name from Tbl_Course_Level 
end
else if (@flag=2)
begin
SELECT 
    Duration_Period_Id AS Duration_Mapping_Id, 
    CAST(Duration_Period_From AS DATE) AS Duration_Period
FROM Tbl_Course_Duration_PeriodDetails;
end
else if (@flag=3)
begin
SELECT 
   Candidate_Id ,
    Candidate_Fname + '' '' + Candidate_Lname AS StudentName
FROM 
    [dbo].[Tbl_Candidate_Personal_Det]
WHERE 
    ApplicationStatus IS NOT NULL 
    AND [Candidate_DelStatus] = 0
    AND (New_Admission_Id <> '''' AND New_Admission_Id <> 0)
	end

	else if (@flag=4)
	begin
		SELECT      
BD.Batch_Id as ID,                              
BD.Batch_Code as BatchCode                                    
FROM dbo.Tbl_Course_Batch_Duration BD          
end
else if (@flag=5)
begin
SELECT 
    Employee_FName + '' '' + Employee_LName AS EmployeeName
FROM 
    [dbo].[Tbl_Employee]
end
end    ');
END;
