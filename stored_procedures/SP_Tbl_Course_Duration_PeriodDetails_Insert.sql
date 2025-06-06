IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Course_Duration_PeriodDetails_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Tbl_Course_Duration_PeriodDetails_Insert]   
@Org_Id bigint,                   
@Batch_Id bigint,                      
@Semester_Id bigint,                      
@Duration_Period_From datetime,                      
@Duration_Period_To datetime         
--@Duration_Period_Status bit,        
                    
AS                
                               
IF NOT EXISTS((select * from Tbl_Course_Duration_PeriodDetails Where Batch_Id=@Batch_Id and Semester_Id=@Semester_Id                  
and Duration_Period_Status=0) )                    
BEGIN       
if exists(select * from Tbl_Course_Batch_Duration where (@Duration_Period_From between Batch_From and Batch_To) and( @Duration_Period_To between Batch_From and Batch_To) and (Batch_Id=@Batch_Id ))
begin 

 if Exists(select * from Tbl_Course_Duration_PeriodDetails where (@Duration_Period_From between Duration_Period_From and Duration_Period_To)
 and (@Duration_Period_To between Duration_Period_From and Duration_Period_To) and (Batch_Id=@Batch_Id ))
 Begin
 RAISERROR(''Semester already exists for this month.'',16,1); 
 End
 else
   Begin           
INSERT INTO [Tbl_Course_Duration_PeriodDetails]                      
           ([Org_Id],
                   [Batch_Id]                      
           ,[Semester_Id]                      
           ,[Duration_Period_From]                      
           ,[Duration_Period_To],         
            Duration_Period_Status,        
            Closing_Date,
                        Created_date,Updated_Date,Delete_Status)                      
     VALUES                      
           (@Org_Id,
                    @Batch_Id                      
           ,@Semester_Id                      
           ,@Duration_Period_From                      
           ,@Duration_Period_To,          
            0,        
           getdate()
                        ,getdate(),getdate(),0)                      
SELECT @@IDENTITY   
   End              
END
end             
ELSE                  
BEGIN                  
       if exists(select * from Tbl_Course_Batch_Duration where (@Duration_Period_From between Batch_From and Batch_To) and( @Duration_Period_To between Batch_From and Batch_To) and (Batch_Id=@Batch_Id ))           
           begin
 UPDATE [Tbl_Course_Duration_PeriodDetails]                  
 SET 
 Org_Id=@Org_Id,
 [Batch_Id]=@Batch_Id,                  
  [Semester_Id]=@Semester_Id,                  
  [Duration_Period_From]=@Duration_Period_From,                  
  [Duration_Period_To]=@Duration_Period_To ,          
   Closing_Date = getdate(), 
   Created_date=getdate()
   ,Updated_Date=getdate()
   ,Delete_Status=0           
  WHERE [Batch_Id]=@Batch_Id and [Semester_Id]=@Semester_Id                  
 SELECT (select top 1 Duration_Period_Id from Tbl_Course_Duration_PeriodDetails where [Batch_Id]=@Batch_Id and [Semester_Id]=@Semester_Id)                  
 end
 END


 --select * from Tbl_Course_Duration_PeriodDetails
    ')
END
