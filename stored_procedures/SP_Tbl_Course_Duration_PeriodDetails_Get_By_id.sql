IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_PeriodDetails_Get_By_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Course_Duration_PeriodDetails_Get_By_id]  -- 1
@Duration_Period_Id bigint  
AS    
BEGIN    
SELECT Duration_Period_Id    
      ,Batch_Id    
      ,Semester_Id    
      ,Duration_Period_From    
      ,Duration_Period_To    
      ,Duration_Period_Status,
       Closing_Date  ,Org_Id       
  FROM Tbl_Course_Duration_PeriodDetails  
WHERE Duration_Period_Id=@Duration_Period_Id    
END

    ')
END
