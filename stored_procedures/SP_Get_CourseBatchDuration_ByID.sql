IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CourseBatchDuration_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_CourseBatchDuration_ByID] --1
(@Batch_Id bigint)    
AS      
BEGIN      
     
      
SELECT BD.Duration_Id as DurationID,BD.Org_Id,BD.Batch_Id as ID,      
BD.Batch_Code as BatchCode,      
BD.Batch_From,BD.Batch_To,      
Tbl_Program_Duration.Program_Category_Id as CatID,      
Tbl_Program_Duration.Program_Duration_Type,Tbl_Program_Duration.Program_Duration_Year,      
Tbl_Program_Duration.Program_Duration_Sem,Tbl_Program_Duration.Program_Duration_Month,      
Tbl_Program_Duration.Program_Duration_Days,      
Tbl_Department.Department_Name as CategoryName , IM.lastnumber,  Tbl_Department.Department_id, 
BD.Study_Mode ,  
BD.Intro_Date ,  
BD.SyllubusCode  ,
BD.Close_Date,BD.dateregsatart as Regdate
      
FROM dbo.Tbl_Course_Batch_Duration    BD  
left join Tbl_IntakeMaster IM on IM.id=BD.IntakeMasterID
left JOIN Tbl_Program_Duration on BD.Duration_Id=Tbl_Program_Duration.Duration_Id      
left join  dbo.Tbl_Department on Tbl_Department.Department_Id=Tbl_Program_Duration.Program_Category_Id      
WHERE  Batch_Id=@Batch_Id and BD.Batch_DelStatus=0  and Tbl_Department.Department_Status = 0       
      
      
      
END   

    ');
END;
