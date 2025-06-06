IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_EmailHistory_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_EmailHistory_Insert]                    
(                  
@GroupEmail_Id bigint=0,        
@Template_id bigint=0 ,  
@Created_date datetime,  
@StatusName Varchar(50)=''''  
)         
AS        
BEGIN        
Insert Into Tbl_EmailHistory (GroupEmail_Id,Template_id,Created_date,StatusName) values(@GroupEmail_Id,@Template_id,@Created_date,@StatusName)  
END 
    ')
END
