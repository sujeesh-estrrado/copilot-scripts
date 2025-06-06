IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_BasicInformationEmployee]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[LMS_SP_Get_BasicInformationEmployee]-- 361       
@Employee_Id bigint      
AS            
BEGIN      
         
select E.Employee_Phone,E.Employee_Mobile,E.Employee_Mail,E.Employee_Permanent_Address,CI.Employee_Id,Batch_Code+''-''+Semester_Code as Batch,E.Employee_DOB,E.Blood_Group,''Active'' as Status,EO.Employee_DOJ from Tbl_Class_InCharge CI  
INNER JOIN Tbl_Course_Duration_Mapping cdm   ON CI.Duration_Mapping_Id=cdm.Duration_Mapping_Id  
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                    
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id             
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id            
inner join  Tbl_Course_Department CD on   cdm.Course_Department_Id=CD.Course_Department_Id  
inner join Tbl_Employee E on CI.Employee_Id=E.Employee_Id   
inner join Tbl_Employee_Official EO on E.Employee_Id=EO.Employee_Id   
where Class_InCharge_Status=0 and E.Employee_Status=0 and E.Employee_Id=@Employee_Id   
END
    ')
END
