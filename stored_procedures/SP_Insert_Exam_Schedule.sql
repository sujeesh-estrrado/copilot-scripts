IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Exam_Schedule]') 
    AND type = N'P'
)
BEGIN
    EXEC('
Create procedure [dbo].[SP_Insert_Exam_Schedule]                                                        
(                                                          
@Exam_Name varchar(100)='''',                                      
@Exam_Type_Id bigint=0,                                      
@exam_master_id bigint=0,                                      
                         
@Course_id bigint=0,                      
@Exam_Date datetime=null ,                      
@Exam_Time_From time(7)=null,                      
@Exam_Time_To time(7)=null,                      
                      
@Created_by bigint=0                      
                      
                                
)                                                          
                                                          
AS                                                          
    begin                 
              
IF EXISTS(SELECT * FROM [Tbl_Exam_Schedule] WHERE Exam_Master_Id=@exam_master_id and Course_id=@Course_id and Exam_Schedule_Status=0 )                                
BEGIN               
  update Tbl_Exam_Master  set  Exam_start_date=@Exam_Date where( Exam_start_date>@Exam_Date  or Exam_start_date is null) AND Exam_Master_Id=@exam_master_id       
  update Tbl_Exam_Master  set  Exam_end_date=@Exam_Date where (Exam_end_date<@Exam_Date  or Exam_end_date is null)  AND Exam_Master_Id=@exam_master_id      
   update Tbl_Exam_Schedule set  Exam_Date=@Exam_Date,Exam_Time_From=@Exam_Time_From,Exam_Time_To=@Exam_Time_To                      
   where Exam_Master_Id=@exam_master_id and Exam_Schedule_Status=0  and Course_id=@Course_id                    
    SELECT Exam_Schedule_Id FROM [Tbl_Exam_Schedule] WHERE Exam_Master_Id=@exam_master_id  and Course_id=@Course_id and Exam_Schedule_Status=0                  
END                                
ELSE                                                        
BEGIN                                                         
             
  update Tbl_Exam_Master  set  Exam_start_date=@Exam_Date where( Exam_start_date>@Exam_Date  or Exam_start_date is null)  AND Exam_Master_Id=@exam_master_id        
  update Tbl_Exam_Master  set  Exam_end_date=@Exam_Date where (Exam_end_date<@Exam_Date  or Exam_end_date is null)    AND Exam_Master_Id=@exam_master_id      
          
  INSERT INTO [Tbl_Exam_Schedule]                                      
           ([Exam_Name]                                      
           ,[Exam_Type_Id]                                      
           ,[Exam_Master_id]                                      
           ,[Course_id]                                      
           ,[Exam_Date],                      
     Exam_Time_From,Exam_Time_To,create_date,Created_by,Exam_Schedule_Status,Is_Result_Published)                                      
     VALUES                                      
           (@Exam_Name                                      
           ,@Exam_Type_Id                                       
           ,@exam_master_id                                      
           ,@Course_id,                      
     @Exam_Date,@Exam_Time_From,@Exam_Time_To,getdate(),@Created_by                      
                      
           ,0,0)                                                        
                                                          
SELECT SCOPE_IDENTITY();                                                        
                                                        
                                      
                                     
END                   
end              ');
END;
