IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_PeriodDetails_Update]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Course_Duration_PeriodDetails_Update]      
@Duration_Period_Id bigint,      
@Batch_Id bigint,      
@Semester_Id bigint,      
@Duration_Period_From datetime,      
@Duration_Period_To datetime ,

@org_Id bigint     
AS      
BEGIN   
if exists(select * from Tbl_Course_Batch_Duration where (@Duration_Period_From between Batch_From and Batch_To) and( @Duration_Period_To between Batch_From and Batch_To) and (Batch_Id=@Batch_Id ))
begin     
UPDATE [Tbl_Course_Duration_PeriodDetails]      
   SET [Batch_Id] = @Batch_Id      
      ,[Semester_Id] = @Semester_Id      
      ,[Duration_Period_From] = @Duration_Period_From      
      ,[Duration_Period_To] = @Duration_Period_To ,
       Closing_Date=GETDATE(),
       Org_Id=@org_Id    
 WHERE Duration_Period_Id=@Duration_Period_Id    
SELECT @Duration_Period_Id  
end  
END
    ')
END
