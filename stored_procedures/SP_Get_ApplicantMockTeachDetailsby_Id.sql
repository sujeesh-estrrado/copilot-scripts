IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_ApplicantMockTeachDetailsby_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Get_ApplicantMockTeachDetailsby_Id] --66  
@Job_Id bigint  
AS  
BEGIN  
 begin tran  
 SELECT J.[Applicant_Name],CONCAT(E1.[Employee_FName],E1.[Employee_LName]) AS [Interviewer1],R.role_Name as Position1  
 ,CONCAT(E2.[Employee_FName],E2.[Employee_LName]) AS [Interviewer2],R1.role_Name Position2  
 ,CONCAT(E3.[Employee_FName],E3.[Employee_LName]) AS [Interviewer3],R2.role_Name Position3  
 FROM [dbo].[Tbl_JobApplication_Deatils] J  
 LEFT JOIN [dbo].[Tbl_HRMS_MockTeaching_Session] H ON H.Application_No=J.Job_Id  
 inner join Tbl_Employee E1 on H.Lead_Assessor=E1.Employee_Id  
 inner join tbl_Employee E2 on H.Assessor1=E2.Employee_Id  
 inner join tbl_Employee E3 on H.Assessor2=E3.Employee_Id  
 inner join Tbl_RoleAssignment RA1 on RA1.employee_id=E1.Employee_Id  
 inner join tbl_Role R on RA1.role_id=R.role_Id  
 inner join Tbl_Role R1 on RA1.role_id=R1.role_Id  
 inner join Tbl_Role R2 on RA1.role_id=R2.role_Id  
 WHERE J.Job_Id=@Job_Id  
 commit  
END
    ')
END
