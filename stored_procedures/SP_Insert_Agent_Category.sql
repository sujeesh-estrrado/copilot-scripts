IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_Agent_Category]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_Agent_Category]

(
@Category_Name Varchar(Max),
@Commission_Rate bigint,
@Active_status Varchar(Max)
         
)              
AS              
                  
              
BEGIN  

if not exists(select Category_Name from Tbl_Agent_Category where Category_Name=@Category_Name) 
begin           
INSERT INTO dbo.Tbl_Agent_Category(Category_Name,Commission_Rate,Active_status,Created_Date,Delete_Status)              
VALUES(@Category_Name,@Commission_Rate,@Active_status,getdate(),0)              
end             
              
END
    ');
END;
