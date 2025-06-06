IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Agent]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_Delete_Agent]  
(@Agent_Id bigint,
@flag bigint=0)  
  
AS  
  
BEGIN  
if(@flag=0)
    begin
         UPDATE [dbo].[Tbl_Agent]  
          SET     Delete_Status = 1,Updated_Date=getdate()  
          WHERE  Agent_ID = @Agent_Id  
    end
if(@flag=1)
    begin
         DELETE  FROM  Tbl_Temp_Agent
          WHERE  Temp_Agent_ID = @Agent_Id  
    end
if(@flag=2)
    begin
         UPDATE [dbo].[Tbl_Agent]  
          SET     PSO_Status=1,Updated_Date=getdate()  
          WHERE  Agent_ID = @Agent_Id  
    end
END  
    ')
END
