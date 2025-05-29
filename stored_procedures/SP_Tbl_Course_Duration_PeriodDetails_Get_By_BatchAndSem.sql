IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_PeriodDetails_Get_By_BatchAndSem]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Tbl_Course_Duration_PeriodDetails_Get_By_BatchAndSem]   
@Batch_Id bigint,
@Semester_Id bigint
AS    
BEGIN    
SELECT Duration_Period_Id    
      ,Batch_Id    
      ,Semester_Id    
      ,Duration_Period_From    
      ,Duration_Period_To    
      ,Duration_Period_Status          
  FROM Tbl_Course_Duration_PeriodDetails  
WHERE   Batch_Id=@Batch_Id and Semester_Id=@Semester_Id and Duration_Period_Status=0
END
    ')
END
